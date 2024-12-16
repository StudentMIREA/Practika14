import 'package:dio/dio.dart';
import 'package:pr14/model/items.dart';
import 'package:pr14/model/order.dart';
import 'package:pr14/model/person.dart';

class ApiService {
  final Dio _dio = Dio();

  //final ip = '192.168.137.1';
  final ip = '192.168.1.121';

  Future<List<Items>> getProducts(String email) async {
    try {
      final response = await _dio.get('http://$ip:8080/products/$email');
      if (response.statusCode == 200) {
        List<Items> products = (response.data as List)
            .map((product) => Items.fromJson(product))
            .toList();

        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<Items> getProductsByID(int index, String email) async {
    final link = 'http://${ip}:8080/products/$email/${index.toString()}';
    try {
      final response = await _dio.get(link);
      if (response.statusCode == 200) {
        Items product = Items.fromJson(response.data);
        print(product);
        return product;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> addProduct(Items item) async {
    final link = 'http://${ip}:8080/products';
    try {
      final response = await _dio.post(link, data: {
        'ID': 0,
        'Name': item.name,
        'Image': item.image,
        'Cost': item.cost,
        'Describtion': item.describtion,
        'Favorite': item.favorite,
        'ShopCart': item.shopcart,
        'Count': item.count,
      });
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> updateProductStatus(Items item) async {
    final link = 'http://${ip}:8080/products/${item.id}';
    try {
      final response = await _dio.put(link, data: {
        'ID': item.id,
        'Name': item.name,
        'Image': item.image,
        'Cost': item.cost,
        'Describtion': item.describtion,
        'Favorite': item.favorite,
        'ShopCart': item.shopcart,
        'Count': item.count,
      });
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> deleteProduct(int index) async {
    final link = 'http://${ip}:8080/products/${index}';
    try {
      final response = await _dio.delete(link);
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<Items>> getShopCartProducts(String user_id) async {
    try {
      final response = await _dio.get('http://${ip}:8080/cart/$user_id');
      if (response.statusCode == 200) {
        List<Items> products = (response.data as List)
            .map((product) => Items.fromJson(product))
            .toList();

        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> addProductShopCart(Items item, String user_id) async {
    final link = 'http://${ip}:8080/cart/$user_id';
    try {
      final response = await _dio.post(link, data: {
        'ID': item.id,
        'Name': item.name,
        'Image': item.image,
        'Cost': item.cost,
        'Describtion': item.describtion,
        'Favorite': item.favorite,
        'ShopCart': item.shopcart,
        'Count': item.count,
      });
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> updateProductShopCart(Items item, String user_id) async {
    final link = 'http://${ip}:8080/cart/$user_id';
    try {
      final response = await _dio.put(link, data: {
        'ID': item.id,
        'Name': item.name,
        'Image': item.image,
        'Cost': item.cost,
        'Describtion': item.describtion,
        'Favorite': item.favorite,
        'ShopCart': item.shopcart,
        'Count': item.count,
      });
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> deleteProductShopCart(String user_id, int product_id) async {
    final link = 'http://${ip}:8080/cart/$user_id/$product_id';
    try {
      final response = await _dio.delete(link);
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<Items>> getFavoriteProducts(String user_id) async {
    try {
      final response = await _dio.get('http://${ip}:8080/favorites/$user_id');
      if (response.statusCode == 200) {
        List<Items> products = (response.data as List)
            .map((product) => Items.fromJson(product))
            .toList();

        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> addProductFavorite(Items item, String user_id) async {
    final link = 'http://${ip}:8080/favorites/$user_id';
    try {
      final response = await _dio.post(link, data: {
        'ID': item.id,
        'Name': item.name,
        'Image': item.image,
        'Cost': item.cost,
        'Describtion': item.describtion,
        'Favorite': item.favorite,
        'ShopCart': item.shopcart,
        'Count': item.count,
      });
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> deleteProductFavorite(String user_id, int product_id) async {
    final link = 'http://${ip}:8080/favorites/$user_id/$product_id';
    try {
      final response = await _dio.delete(link);
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<Person> getUserByID(String? index) async {
    final link = 'http://${ip}:8080/users/$index';
    try {
      final response = await _dio.get(link);
      if (response.statusCode == 200) {
        Person product = Person.fromJson(response.data);
        return product;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> updateUser(Person item) async {
    final link = 'http://${ip}:8080/users/${item.id}';
    try {
      final response = await _dio.put(link, data: {
        'ID': item.id,
        'Name': item.name,
        'Image': item.image,
        'Phone': item.phone,
        'Mail': item.mail,
        'Role': item.role
      });
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> addNewUser(String name, String mail) async {
    final link = 'http://${ip}:8080/users';
    try {
      final response = await _dio.post(link, data: {
        'Name': name,
        'Mail': mail,
      });
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<Person>> allUsers() async {
    final link = 'http://${ip}:8080/users';
    try {
      final response = await _dio.get(link);
      if (response.statusCode == 200) {
        List<Person> products = (response.data as List)
            .map((product) => Person.fromJson(product))
            .toList();

        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> createOrder(String mail) async {
    final link = 'http://${ip}:8080/orders/$mail';
    try {
      final response = await _dio.post(link);
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<Order>> getOrders(String mail) async {
    final link = 'http://${ip}:8080/orders/$mail';
    try {
      final response = await _dio.get(link);

      if (response.statusCode == 200) {
        List<Order> products = (response.data as List)
            .map((product) => Order.fromJson(product))
            .toList();
        print(products);
        print(1);
        return products;
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }
}
