package handlers

import (
	"fmt"
	"log"
	"net/http"
	"shopApi/models"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
)

func GetOrders(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		// Получаем ID из параметров маршрута
		userIdmail := c.Param("id")

		var userId []int

		db.Select(&userId, `SELECT id FROM users 
		WHERE mail = $1`, userIdmail)

		id := userId[0]

		// Выполняем запрос к базе данных для получения заказов и связанных продуктов
		query := `
			SELECT o.id AS order_id, o.total, o.status, o.created_at,
			       p.id AS product_id, op.quantity, p.image
			FROM orders o
			LEFT JOIN order_products op ON o.id = op.order_id
			LEFT JOIN products p ON op.product_id = p.id
			WHERE o.user_id = $1
		`

		rows, err := db.Query(query, id)
		if err != nil {
			log.Println("Ошибка запроса к базе данных:", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка получения заказов"})
			return
		}
		defer rows.Close()

		type Product struct {
			ProductID int    `json:"ProductID"`
			Quantity  int    `json:"Quantity"`
			Image     string `json:"Image"`
		}

		type Order struct {
			OrderID   int       `json:"OrderID"`
			Total     float64   `json:"Total"`
			Status    string    `json:"Status"`
			CreatedAt time.Time `json:"CreatedAt"`
			Products  []Product `json:"products"`
		}

		var orders []Order

		for rows.Next() {
			var order Order
			var product Product

			if err := rows.Scan(&order.OrderID, &order.Total, &order.Status, &order.CreatedAt,
				&product.ProductID, &product.Quantity, &product.Image); err != nil {
				log.Println("Ошибка сканирования строки:", err)
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка обработки данных"})
				return
			}

			if product.ProductID != 0 { // Проверяем наличие продукта
				order.Products = append(order.Products, product)
			}

			if len(orders) == 0 || orders[len(orders)-1].OrderID != order.OrderID {
				order.Products = []Product{product} // Инициализируем список продуктов для нового заказа
				orders = append(orders, order)
			} else {
				lastOrderIndex := len(orders) - 1
				if product.ProductID != 0 { // Проверяем наличие продукта
					orders[lastOrderIndex].Products = append(orders[lastOrderIndex].Products, product)
				}
			}
		}

		// Отправляем ответ в формате JSON
		c.JSON(http.StatusOK, orders)
	}
}

func CreateOrder(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userIdmail := c.Param("userId")

		var products []models.Product
		db.Select(&products, `SELECT products.id, products.name, products.image, products.cost, products.description, 
									(CASE WHEN (favorites.id IS NOT NULL) THEN true ELSE false END) as favorite,
									(CASE WHEN (cart.id IS NOT NULL) THEN true ELSE false END) as shop_cart,
									(CASE WHEN (cart.count IS NOT NULL) THEN cart.count ELSE 0 END) as count 
									FROM products 
									JOIN cart ON products.id = cart.product_id 
									LEFT JOIN favorites ON products.id = favorites.product_id
									JOIN users ON cart.user_id = users.id
									WHERE users.mail = $1`, userIdmail)

		var totalCost []float64

		err := db.Select(&totalCost, `SELECT SUM(products.cost * cart.count) as total
FROM products, cart, users 
WHERE products.id = cart.product_id AND cart.user_id = users.id AND users.mail = $1`, userIdmail)
		if err != nil {
			fmt.Println("Ошибка выполнения запроса:", err)
		}
		var userId []int

		db.Select(&userId, `SELECT id FROM users 
		WHERE mail = $1`, userIdmail)
		var orderId []int

		db.Select(&orderId, `INSERT INTO orders (user_id, total)
					VALUES ($1, $2)
					RETURNING id`, userId[0], totalCost[0])
		fmt.Println(orderId)

		for _, product := range products {
			var answer []int
			db.Select(&answer, `INSERT INTO order_products (order_id, product_id, quantity)
					VALUES ($1, $2, $3) RETURNING order_id`, orderId[0], product.ID, product.Count)
		}

		db.Exec("DELETE FROM cart WHERE user_id = (SELECT id FROM users WHERE mail = $1)", userIdmail)

		// Отправляем ответ
		c.JSON(http.StatusCreated, orderId)
	}
}
