import 'package:flutter/material.dart';

class HeaderUsuario extends StatelessWidget {
  final String nome;
  final String cidade;
  final String saudacao;

  const HeaderUsuario({
    super.key,
    required this.nome,
    required this.cidade,
    required this.saudacao,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, $nome 👋',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.white70, size: 18),
                SizedBox(width: 4),
                Text(cidade, style: TextStyle(color: Colors.white70)),
              ],
            ),
          ],
        ),
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 22,
          child: Icon(Icons.person, color: Colors.green.shade700),
        ),
      ],
    );
  }
}
