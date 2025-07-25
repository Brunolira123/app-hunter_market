// Arquivo: home_page.dart
import 'package:flutter/material.dart';
import 'package:hunter_market/widgets/grafico_visitas.dart';
import 'package:hunter_market/widgets/header_usuario.dart';
import 'package:hunter_market/widgets/botao_busca.dart';
import 'package:hunter_market/controller/dashboard_controller.dart';
import 'package:hunter_market/widgets/modal_confirmacao_visita.dart';
import 'package:hunter_market/widgets/secao_notificacoes.dart';
import 'package:hunter_market/widgets/secao_visitas_recentes.dart';
import 'map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DashboardController _controller = DashboardController();
  final String nomeUsuario = "Bruno";
  String cidadeAtual = "Carregando...";

  final List<int> _visitasMock = [0, 2, 4, 1, 3, 5, 2];
  final List<String> _notificacoes = [
    "Você tem 2 mercados pendentes para visitar hoje.",
    "Meta do dia: visitar pelo menos 5 mercados.",
    "Lembrete: atualizar informações da loja XPTO.",
  ];

  final List<Map<String, dynamic>> _visitasRecentes = [
    {
      "mercado": "Mercado Central",
      "bairro": "Centro",
      "data": DateTime.now().subtract(Duration(hours: 1)),
    },
    {
      "mercado": "SuperXPTO",
      "bairro": "Aldeota",
      "data": DateTime.now().subtract(Duration(days: 1, hours: 2)),
    },
    {
      "mercado": "MiniBox Express",
      "bairro": "Meireles",
      "data": DateTime.now().subtract(Duration(days: 2, hours: 4)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCidade();
  }

  Future<void> _loadCidade() async {
    final cidade = await _controller.getCityName();
    setState(() => cidadeAtual = cidade);
  }

  void _iniciarBusca() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MapPage()));
  }

  void _mostrarModalConfirmacaoVisita() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => ModalConfirmacaoVisita(
        nomeMercado: "SuperXPTO",
        endereco: "Av. Brasil, 123",
        fotoUrl: "https://via.placeholder.com/400x200.png?text=SuperXPTO",
        onConfirmar: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Visita registrada com sucesso!")),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final saudacao = _gerarSaudacao(DateTime.now());

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderUsuario(
                      nome: nomeUsuario,
                      saudacao: saudacao,
                      cidade: cidadeAtual,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Pronto para visitar mais mercados hoje?",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 24),
                    BotaoBusca(onTap: _iniciarBusca),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: _mostrarModalConfirmacaoVisita,
                      child: const Text("Simular chegada ao mercado"),
                    ),
                    const SizedBox(height: 32),
                    GraficoVisitas(visitas: _visitasMock),
                    const SizedBox(height: 32),
                    SecaoNotificacoes(notificacoes: _notificacoes),
                    const SizedBox(height: 32),
                    SecaoVisitasRecentes(visitas: _visitasRecentes),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _gerarSaudacao(DateTime agora) {
    final hora = agora.hour;
    if (hora < 12) return "Bom dia";
    if (hora < 18) return "Boa tarde";
    return "Boa noite";
  }
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/fundo-login.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
