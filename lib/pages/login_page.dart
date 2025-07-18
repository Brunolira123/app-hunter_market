import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    final success = await _authService.login(
      _userController.text,
      _passController.text,
    );

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Usuário ou senha inválidos')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(Icons.map_outlined, size: 80, color: Colors.green),
                SizedBox(height: 16),
                Text(
                  "Hunter Market",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32),
                TextField(
                  controller: _userController,
                  decoration: InputDecoration(labelText: 'Usuário'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passController,
                  decoration: InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                ),
                SizedBox(height: 24),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(onPressed: _login, child: Text('Entrar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
