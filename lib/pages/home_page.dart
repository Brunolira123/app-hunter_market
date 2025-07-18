// home_page.dart
import 'package:flutter/material.dart';
import 'map_page.dart';

class HomePage extends StatelessWidget {
  void _iniciarBusca(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MapPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.store_mall_directory, size: 80, color: Colors.green),
              SizedBox(height: 24),
              Text(
                'Bem-vindo ao Hunter Market!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Aqui você pode encontrar mercados próximos e registrar visitas.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              ElevatedButton.icon(
                icon: Icon(Icons.search),
                label: Text('Iniciar busca por mercados'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: () => _iniciarBusca(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
