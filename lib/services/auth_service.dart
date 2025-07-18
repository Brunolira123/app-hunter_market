class AuthService {
  Future<bool> login(String usuario, String senha) async {
    await Future.delayed(Duration(seconds: 1)); // simulação de requisição

    // Autenticação mockada
    return usuario == 'admin' && senha == '1234';
  }
}
