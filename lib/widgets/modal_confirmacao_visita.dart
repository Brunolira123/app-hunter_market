import 'package:flutter/material.dart';

class ModalConfirmacaoVisita extends StatelessWidget {
  final String nomeMercado;
  final String endereco;
  final String fotoUrl;
  final VoidCallback onConfirmar;

  const ModalConfirmacaoVisita({
    super.key,
    required this.nomeMercado,
    required this.endereco,
    required this.fotoUrl,
    required this.onConfirmar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              fotoUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            nomeMercado,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            endereco,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            onPressed: onConfirmar,
            icon: const Icon(Icons.check),
            label: const Text(
              "Confirmar Visita",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
