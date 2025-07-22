import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hunter_market/controller/dashboard_controller.dart';
import 'map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String nomeUsuario = "Bruno";
  String cidadeAtual = "Carregando...";
  final DashboardController _controller = DashboardController();

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
    setState(() {
      cidadeAtual = cidade;
    });
  }

  void _iniciarBusca() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MapPage()));
  }

  String _gerarSaudacao(DateTime agora) {
    final hora = agora.hour;
    if (hora < 12) return "Bom dia";
    if (hora < 18) return "Boa tarde";
    return "Boa noite";
  }

  @override
  Widget build(BuildContext context) {
    final saudacao = _gerarSaudacao(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Saudação e localização
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$saudacao, $nomeUsuario 👋",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                            SizedBox(width: 4),
                            Text(
                              cidadeAtual,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage("assets/images/perfil.jpg"),
                    ),
                  ],
                ),

                SizedBox(height: 24),
                Text(
                  "Pronto para visitar mais mercados hoje?",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),

                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _iniciarBusca,
                  icon: Icon(Icons.search),
                  label: Text("Iniciar busca por mercados"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                SizedBox(height: 32),
                _buildGrafico(),
                SizedBox(height: 32),
                _buildNotificacoes(),
                SizedBox(height: 32),
                _buildVisitasRecentes(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrafico() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Visitas na semana",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        Container(
          height: 200,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: BarChart(
            BarChartData(
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final dias = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(dias[value.toInt()]),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(7, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: _visitasMock[index].toDouble(),
                      color: Colors.orange,
                      width: 18,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificacoes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Notificações",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        Column(
          children: _notificacoes.map((msg) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 6),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.notifications, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(child: Text(msg, style: TextStyle(fontSize: 14))),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVisitasRecentes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Visitas Recentes",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        ..._visitasRecentes.map((visita) {
          final DateTime data = visita['data'];
          final String dataFormatada =
              "${data.day}/${data.month} às ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}";

          return Container(
            margin: EdgeInsets.symmetric(vertical: 6),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visita['mercado'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        visita['bairro'],
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Text(
                        dataFormatada,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
