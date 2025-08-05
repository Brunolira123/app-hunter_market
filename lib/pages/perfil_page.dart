import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final List<String> categoriasSelecionadas;
  final String nome;
  final String email;
  final String imagemUrl;
  final String organizacao;
  final String funcao;

  const ProfilePage({
    super.key,
    required this.categoriasSelecionadas,
    required this.nome,
    required this.email,
    required this.imagemUrl,
    required this.organizacao,
    required this.funcao,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  File? _fotoPerfil;
  final picker = ImagePicker();

  late Map<String, bool> categorias;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    categorias = {
      'mercado': widget.categoriasSelecionadas.contains('mercado'),
      'supermercado': widget.categoriasSelecionadas.contains('supermercado'),
      'hipermercado': widget.categoriasSelecionadas.contains('hipermercado'),
      'hortifruti': widget.categoriasSelecionadas.contains('hortifruti'),
      'padaria': widget.categoriasSelecionadas.contains('padaria'),
    };

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(_fadeAnimation);

    _carregarPreferencias();

    _animationController.forward();
  }

  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();

    for (var categoria in categorias.keys) {
      if (prefs.containsKey('categoria_$categoria')) {
        categorias[categoria] = prefs.getBool('categoria_$categoria') ?? true;
      }
    }

    final pathFoto = prefs.getString('foto_perfil');
    if (pathFoto != null && File(pathFoto).existsSync()) {
      _fotoPerfil = File(pathFoto);
    }

    setState(() {});
  }

  Future<void> _salvarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    for (var entry in categorias.entries) {
      await prefs.setBool('categoria_${entry.key}', entry.value);
    }
    if (_fotoPerfil != null) {
      await prefs.setString('foto_perfil', _fotoPerfil!.path);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Center(
          child: Text(
            'Salvo com sucesso!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _escolherFoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _fotoPerfil = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Faz o corpo "estender" atrás do appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparente para ver o fundo
        elevation: 0,
        title: const Text('Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
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
                ), // Fundo branco translúcido
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _escolherFoto,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: _fotoPerfil != null
                              ? FileImage(_fotoPerfil!)
                              : (widget.imagemUrl.isNotEmpty
                                        ? NetworkImage(widget.imagemUrl)
                                        : const AssetImage(
                                            'assets/default_avatar.png',
                                          ))
                                    as ImageProvider,
                          child: _fotoPerfil == null && widget.imagemUrl.isEmpty
                              ? const Icon(
                                  Icons.camera_alt,
                                  size: 36,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.nome,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Organização / Unidade',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.organizacao,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Função / Cargo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.funcao,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Categorias de Estabelecimento:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView(
                          children: categorias.keys.map((categoria) {
                            return CheckboxListTile(
                              title: Text(
                                categoria[0].toUpperCase() +
                                    categoria.substring(1),
                              ),
                              value: categorias[categoria],
                              onChanged: (bool? value) {
                                setState(() {
                                  categorias[categoria] = value ?? false;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Salvar Preferências'),
                        onPressed: _salvarPreferencias,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
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
      // Ocupa toda a tela incluindo atrás do AppBar
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/fundo-login.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
