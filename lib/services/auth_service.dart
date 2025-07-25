import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Login com Google
  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // usuário cancelou

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      // Validação do domínio do email
      if (user != null && user.email!.endsWith("@vrinteriorpaulista.com.br")) {
        return user;
      } else {
        await signOut();
        throw Exception("Email fora do domínio permitido.");
      }
    } catch (e) {
      rethrow;
    }
  }

  // 🔐 Login com usuário e senha (mock ou backend real futuramente)
  Future<bool> loginComUsuarioSenha(String usuario, String senha) async {
    // Substituir com lógica real se for o caso
    if (usuario == "admin" && senha == "1234") {
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
