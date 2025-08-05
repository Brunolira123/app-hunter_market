import 'package:hunter_market/models/usuario_logado.dart';

class UsuarioSession {
  static final UsuarioSession _instance = UsuarioSession._internal();
  factory UsuarioSession() => _instance;
  UsuarioSession._internal();

  late UsuarioLogado _usuario;

  void setUsuario(UsuarioLogado usuario) {
    _usuario = usuario;
  }

  UsuarioLogado get usuario => _usuario;
}
