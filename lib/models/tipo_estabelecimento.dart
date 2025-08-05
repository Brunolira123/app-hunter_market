class TipoEstabelecimento {
  final String nome;
  final String termoBusca;
  bool selecionado;

  TipoEstabelecimento({
    required this.nome,
    required this.termoBusca,
    this.selecionado = true,
  });
}
