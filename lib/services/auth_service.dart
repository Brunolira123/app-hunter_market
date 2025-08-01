import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final _storage = const FlutterSecureStorage();
  final String _baseUrl =
      'http://10.0.2.2:8080'; // Altere conforme o IP do backend

  Future<bool> loginComUsuarioSenha(String email, String senha) async {
    final url = Uri.parse('$_baseUrl/api/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      if (token != null) {
        await _storage.write(key: 'token', value: token);
        return true;
      }
    }

    return false;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
}
