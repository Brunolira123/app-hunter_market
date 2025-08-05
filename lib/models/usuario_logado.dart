class UsuarioLogado {
  final String nome;
  final String email;
  final String tipo;
  final String empresa;
  final String? fotoUrl;

  UsuarioLogado({
    required this.nome,
    required this.email,
    required this.tipo,
    required this.empresa,
    this.fotoUrl,
  });

  factory UsuarioLogado.fromJson(Map<String, dynamic> json) {
    return UsuarioLogado(
      nome: json['nome'],
      email: json['email'],
      tipo: json['tipo'],
      empresa: json['empresa'] ?? 'Não definido',
      fotoUrl: json['fotoUrl'], // pode ser null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'tipo': tipo,
      'empresa': empresa,
      'fotoUrl': fotoUrl,
    };
  }
}
