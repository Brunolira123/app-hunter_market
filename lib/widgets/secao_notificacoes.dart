import 'package:flutter/material.dart';

class SecaoNotificacoes extends StatelessWidget {
  final List<String> notificacoes;

  const SecaoNotificacoes({super.key, required this.notificacoes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notificações',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        ...notificacoes.map(
          (n) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(n, style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }
}
