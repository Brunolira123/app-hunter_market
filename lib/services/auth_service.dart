class AuthService {
  // 🔐 Login com usuário e senha (mock ou backend real futuramente)
  Future<bool> loginComUsuarioSenha(String usuario, String senha) async {
    // Substituir com lógica real se for o caso
    if (usuario == "admin" && senha == "1234") {
      return true;
    }
    return false;
  }
}
