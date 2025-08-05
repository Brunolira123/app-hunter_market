// widgets/header_usuario.dart
import 'package:flutter/material.dart';

class HeaderUsuario extends StatelessWidget {
  final String nome;
  final String saudacao;
  final String cidade;
  final VoidCallback onFotoClick;

  const HeaderUsuario({
    super.key,
    required this.nome,
    required this.saudacao,
    required this.cidade,
    required this.onFotoClick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$saudacao, $nome 👋",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    cidade,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onFotoClick,
          child: const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(
              "assets/images/foto-perfil.jpg",
            ), // substitua por NetworkImage se for dinâmico
          ),
        ),
      ],
    );
  }
}
