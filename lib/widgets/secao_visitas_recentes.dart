import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SecaoVisitasRecentes extends StatelessWidget {
  final List<Map<String, dynamic>> visitas;

  const SecaoVisitasRecentes({super.key, required this.visitas});

  String _formatarData(DateTime data) {
    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inHours < 24) {
      return 'Hoje às ${DateFormat.Hm().format(data)}';
    } else if (diferenca.inDays == 1) {
      return 'Ontem às ${DateFormat.Hm().format(data)}';
    } else {
      return DateFormat('dd/MM/yyyy – HH:mm').format(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Visitados recentemente',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...visitas.map(
          (v) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v['mercado'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        v['bairro'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _formatarData(v['data']),
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
