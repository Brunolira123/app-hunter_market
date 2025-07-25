import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class DrawerUser extends StatelessWidget {
  final AuthService authService;
  final VoidCallback onLogout;

  const DrawerUser({
    super.key,
    required this.authService,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;

    return Drawer(
      child: user == null
          ? Center(child: Text("Usuário não logado"))
          : Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(user.displayName ?? "Sem nome"),
                  accountEmail: Text(user.email ?? "Sem email"),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : AssetImage("assets/images/perfil.jpg")
                              as ImageProvider,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Sair"),
                  onTap: () async {
                    await authService.signOut();
                    onLogout();
                  },
                ),
              ],
            ),
    );
  }
}
