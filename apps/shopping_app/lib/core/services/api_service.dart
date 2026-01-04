import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../features/auth/models/user.dart';
import '../../features/products/models/product.dart';
import '../logging/logger.dart';

class ApiService {
  static const _baseUrl = 'https://fakestoreapi.com';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Product>> getProducts() async {
    const url = '$_baseUrl/products';
    logger.apiRequest('GET', url);

    try {
      final response = await _client.get(Uri.parse(url));
      logger.apiResponse('GET', url, response.statusCode);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        logger.info('API', 'Loaded ${data.length} products');
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      logger.apiError('GET', url, e);
      rethrow;
    }
  }

  Future<Product> getProduct(int id) async {
    final url = '$_baseUrl/products/$id';
    logger.apiRequest('GET', url);

    try {
      final response = await _client.get(Uri.parse(url));
      logger.apiResponse('GET', url, response.statusCode);

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      logger.apiError('GET', url, e);
      rethrow;
    }
  }

  Future<List<String>> getCategories() async {
    const url = '$_baseUrl/products/categories';
    logger.apiRequest('GET', url);

    try {
      final response = await _client.get(Uri.parse(url));
      logger.apiResponse('GET', url, response.statusCode);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<String>();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      logger.apiError('GET', url, e);
      rethrow;
    }
  }

  Future<String> login(String username, String password) async {
    const url = '$_baseUrl/auth/login';
    logger.apiRequest('POST', url, {'username': username});

    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );
      logger.apiResponse('POST', url, response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        logger.info('API', 'Login successful for user: $username');
        return data['token'] as String;
      } else {
        logger.warning('API', 'Login failed for user: $username');
        throw Exception('Login failed');
      }
    } catch (e) {
      logger.apiError('POST', url, e);
      rethrow;
    }
  }

  Future<User> getUser(int id) async {
    final url = '$_baseUrl/users/$id';
    logger.apiRequest('GET', url);

    try {
      final response = await _client.get(Uri.parse(url));
      logger.apiResponse('GET', url, response.statusCode);

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      logger.apiError('GET', url, e);
      rethrow;
    }
  }

  Future<int> registerUser({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    const url = '$_baseUrl/users';
    logger.apiRequest('POST', url, {'username': username, 'email': email});

    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'username': username,
          'password': password,
          'name': {'firstname': firstName, 'lastname': lastName},
          'phone': phone,
          'address': {
            'city': '',
            'street': '',
            'number': 0,
            'zipcode': '',
            'geolocation': {'lat': '0', 'long': '0'},
          },
        }),
      );
      logger.apiResponse('POST', url, response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        logger.info('API', 'Registration successful for user: $username');
        return data['id'] as int;
      } else {
        logger.warning('API', 'Registration failed for user: $username');
        throw Exception('Registration failed');
      }
    } catch (e) {
      logger.apiError('POST', url, e);
      rethrow;
    }
  }
}
