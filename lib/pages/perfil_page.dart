import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_user_page.dart';

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
    final larguraTela = MediaQuery.of(context).size.width;
    final alturaTela = MediaQuery.of(context).size.height;
    final paddingBase = larguraTela * 0.05;
    final fontBase = larguraTela * 0.045;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  margin: EdgeInsets.symmetric(
                    horizontal: paddingBase,
                    vertical: 16,
                  ),
                  padding: EdgeInsets.all(paddingBase),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
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
                              radius: larguraTela * 0.15,
                              backgroundImage: _fotoPerfil != null
                                  ? FileImage(_fotoPerfil!)
                                  : (widget.imagemUrl.isNotEmpty
                                            ? NetworkImage(widget.imagemUrl)
                                            : const AssetImage(
                                                'assets/default_avatar.png',
                                              ))
                                        as ImageProvider,
                              child:
                                  _fotoPerfil == null &&
                                      widget.imagemUrl.isEmpty
                                  ? const Icon(
                                      Icons.camera_alt,
                                      size: 36,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                          SizedBox(height: alturaTela * 0.02),
                          Text(
                            widget.nome,
                            style: TextStyle(
                              fontSize: fontBase + 4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: alturaTela * 0.01),
                          Text(
                            widget.email,
                            style: TextStyle(
                              fontSize: fontBase - 2,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: alturaTela * 0.03),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Organização / Unidade',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontBase,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.organizacao,
                                  style: TextStyle(
                                    fontSize: fontBase - 1,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Função / Cargo',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontBase,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.funcao,
                                  style: TextStyle(
                                    fontSize: fontBase - 1,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: alturaTela * 0.03),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Categorias de Estabelecimento:',
                              style: TextStyle(
                                fontSize: fontBase + 2,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange[700],
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: alturaTela * 0.25,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.shade200.withOpacity(
                                    0.4,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: ListView(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                children: categorias.keys.map((categoria) {
                                  return CheckboxListTile(
                                    activeColor: Colors.deepOrange,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    title: Text(
                                      categoria[0].toUpperCase() +
                                          categoria.substring(1),
                                      style: TextStyle(
                                        fontSize: fontBase - 1,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                          ),
                          SizedBox(height: alturaTela * 0.03),
                          if (widget.funcao == 'ADM') ...[
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.person_add),
                                label: const Text('Criar Novo Usuário'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange.shade700,
                                  padding: EdgeInsets.symmetric(
                                    vertical: alturaTela * 0.02,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 5,
                                  shadowColor: Colors.deepOrangeAccent.shade100,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CreateUserPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: alturaTela * 0.02),
                          ],
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.save),
                              label: const Text('Salvar Preferências'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade600,
                                padding: EdgeInsets.symmetric(
                                  vertical: alturaTela * 0.02,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 6,
                                shadowColor: Colors.orangeAccent.shade100,
                              ),
                              onPressed: _salvarPreferencias,
                            ),
                          ),
                        ],
                      ),
                    ),
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
