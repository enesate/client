import 'dart:convert';

import 'package:client/src/auth/data/user_model.dart';
import 'package:client/src/auth/domain/base_auth_repository.dart';
import 'package:http/http.dart' as http;

class AuthRepository extends BaseAuthRepository {
  static const baseUrl = 'http://127.0.0.1:8080/users';

  @override
  Future<void> registerWithUsers({required User user}) async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials":
              'true', // Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS",
          'Content-Type': 'application/json',
          'Accept': '*/*'
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        // Başarılı bir yanıt alındığında
        print('Kullanıcı Kayıt oldu');
      } else {
        // Hata durumları-
        print('error: ${response.statusCode}');
      }
    } catch (error) {
      print('error: $error');
    }
  }

  @override
  Future<User?> signInWithUserNameAndPassword(
      {required String userName, required String password}) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      body: {'userName': userName, 'password': password},
    );

    if (response.statusCode == 200) {
      // Giriş başarılı
      return User.fromJson(jsonDecode(response.body));
    } else {
      // Giriş başarısız
      return null;
    }
  }

  @override
  Future<User> updateUser(
      {required String userName,
      required String password,
      required User newUser}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$userName'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          newUser.toJson()), // newUser sınıfınıza uygun toJson metodu olmalı
    );
    if (response.statusCode == 200) {
      print("Response body: ${response.body}");
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }
}
