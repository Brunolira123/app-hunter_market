import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();

  // Simula login com backend
  Future<bool> loginComUsuarioSenha(String usuario, String senha) async {
    // 🔒 Substituir isso pela chamada real de login
    if (usuario == "admin" && senha == "1234") {
      // Simula resposta com token e dados do usuário
      await _storage.write(key: 'token', value: 'mock_token_abc123');
      await _storage.write(
        key: 'usuario',
        value: '''
        {
          "nome": "Administrador",
          "email": "admin@hunter.com",
          "tipo": "ADMIN",
          "empresa": "LS Solution",
          "fotoUrl": null
        }
      ''',
      );
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<Map<String, dynamic>?> getUsuarioLogado() async {
    final jsonStr = await _storage.read(key: 'usuario');
    if (jsonStr == null) return null;
    return Map<String, dynamic>.from(jsonDecode(jsonStr));
  }

  Future<bool> estaLogado() async {
    final token = await getToken();
    return token != null;
  }
}
