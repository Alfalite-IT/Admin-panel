import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthService with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  // TODO: Make this configurable
  final String _baseUrl = 'http://localhost:8080';

  static const tokenKey = 'auth_token';

  AuthStatus _status = AuthStatus.loading;
  AuthStatus get status => _status;

  Future<void> init() async {
    final token = await getToken();
    if (token != null) {
      try {
        if (!JwtDecoder.isExpired(token)) {
          _status = AuthStatus.authenticated;
        } else {
          // If token is expired, delete it
          await _storage.delete(key: tokenKey);
          _status = AuthStatus.unauthenticated;
        }
      } catch (e) {
        // If token is invalid, delete it
        await _storage.delete(key: tokenKey);
        _status = AuthStatus.unauthenticated;
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final token = body['token'];
        if (token != null) {
          await _storage.write(key: tokenKey, value: token);
          _status = AuthStatus.authenticated;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Login failed: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: tokenKey);
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<String?> getToken() async {
    return await _storage.read(key: tokenKey);
  }
}