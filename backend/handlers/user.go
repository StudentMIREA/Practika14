package handlers

import (
	"fmt"
	"net/http"
	"shopApi/models"

	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
)

// Получение одного продукта по его ID
func GetUser(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userId := c.Param("userId")
		var product models.User
		err := db.Get(&product, `SELECT * FROM users 
								WHERE mail = $1`, userId)
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Пользователь не найден"})
			fmt.Println("Error")
			return
		}
		c.JSON(http.StatusOK, product)
	}
}

// Получение одного продукта по его ID
func GetAllUsers(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var products []models.User
		err := db.Select(&products, `SELECT * FROM users 
								WHERE not role = 'admin'`)

		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Пользователи не найден"})
			fmt.Println("Error")
			return
		}
		c.JSON(http.StatusOK, products)
	}
}

// Создание нового продукта
func CreateNewUser(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		type NameMail struct {
			Name string
			Mail string
		}
		var product NameMail
		if err := c.ShouldBindJSON(&product); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректные данные"})
			fmt.Println(product)
			return
		}
		query := `INSERT INTO users (name, mail) 
                  VALUES (:Name, :Mail)`
		_, err := db.NamedExec(query, map[string]interface{}{
			"Name": product.Name,
			"Mail": product.Mail,
		})

		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка добавления продукта"})
			fmt.Println("чет не то")
			return
		}

		c.JSON(http.StatusOK, product)
	}
}

// Обновление существующего продукта по его ID
func UpdateUser(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userId := c.Param("userId")

		var product models.User
		if err := c.ShouldBindJSON(&product); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректные данные"})
			return
		}

		query := `UPDATE users SET name = :Name, image = :Image, phone = :Phone, 
                  mail = :Mail WHERE id = :ID`

		// Используем NamedExec для выполнения запроса с именованными параметрами
		_, err := db.NamedExec(query, map[string]interface{}{
			"Name":  product.Name,
			"Image": product.Image,
			"Phone": product.Phone,
			"Mail":  product.Mail,
			"ID":    userId,
		})

		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка обновления продукта"})
			return
		}
		c.JSON(http.StatusOK, product)
	}
}
