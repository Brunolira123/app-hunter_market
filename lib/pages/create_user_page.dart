import 'package:flutter/material.dart';
import 'package:hunter_market/pages/home_page.dart';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>();

  String? _organizacao;
  String? _nome;
  String? _senha;
  String? _funcao;

  final List<String> _organizacoes = [
    'VR Interior Paulista',
    'Supermercado Central',
  ];
  final List<String> _funcoes = ['Comercial', 'ADM', 'Diretor'];

  bool validarCnpj(String cnpj) {
    final cnpjNumeros = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    if (cnpjNumeros.length != 14) return false;
    if (!RegExp(r'^\d{14}$').hasMatch(cnpjNumeros)) return false;
    return true;
  }

  void _abrirModalCriarOrganizacao() {
    String? novaOrganizacao;
    String? novoCnpj;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white.withOpacity(0.95),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Nova Unidade / Organização",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Nome da Organização",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => novaOrganizacao = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "CNPJ (somente números)",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => novoCnpj = value,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (novaOrganizacao == null || novaOrganizacao!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Por favor, preencha o nome da organização',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (novoCnpj == null || !validarCnpj(novoCnpj!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Por favor, insira um CNPJ válido com 14 dígitos numéricos',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  setState(() {
                    _organizacoes.add('$novaOrganizacao - CNPJ: $novoCnpj');
                    _organizacao = '$novaOrganizacao - CNPJ: $novoCnpj';
                  });
                  Navigator.pop(context);
                },
                child: const Text("Salvar"),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      prefixIcon: icon != null
          ? Icon(icon, color: Colors.deepOrange.shade300)
          : null,
      labelText: label,
      filled: true,
      fillColor: Colors.white.withOpacity(0.85),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Criar Usuário'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          const BackgroundImage(),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(
                  0.85,
                ), // fundo branco translúcido
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        "Criar Usuário",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange.shade300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Organização
                      DropdownButtonFormField<String>(
                        value: _organizacao,
                        decoration: _inputDecoration(
                          "Unidade / Organização",
                          icon: Icons.apartment,
                        ),
                        items: _organizacoes.map((org) {
                          return DropdownMenuItem(value: org, child: Text(org));
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _organizacao = value),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: _abrirModalCriarOrganizacao,
                        icon: const Icon(Icons.add),
                        label: const Text("Criar nova organização"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.deepOrange.shade300,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Nome
                      TextFormField(
                        decoration: _inputDecoration(
                          "Nome",
                          icon: Icons.person,
                        ),
                        onChanged: (value) => _nome = value,
                      ),
                      const SizedBox(height: 20),

                      // Senha
                      TextFormField(
                        decoration: _inputDecoration("Senha", icon: Icons.lock),
                        obscureText: true,
                        onChanged: (value) => _senha = value,
                      ),
                      const SizedBox(height: 20),

                      // Função
                      DropdownButtonFormField<String>(
                        value: _funcao,
                        decoration: _inputDecoration(
                          "Função / Cargo",
                          icon: Icons.work,
                        ),
                        items: _funcoes.map((func) {
                          return DropdownMenuItem(
                            value: func,
                            child: Text(func),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _funcao = value),
                      ),
                      const SizedBox(height: 40),

                      // Botão Criar
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange.shade300,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Lógica de criação de usuário
                          }
                        },
                        child: const Text(
                          "Criar Usuário",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
