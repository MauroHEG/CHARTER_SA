import 'package:charter_appli_travaux_mro/view/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/appStrings.dart';
import '../web_admin/screens/admin_dashboard_screen.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BF853),
        title: const Text('Connexion', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Image(
                    image: AssetImage(AppStrings.cheminLogo),
                  ),
                  const SizedBox(
                      height:
                          80), // Ajoutez cette ligne pour ajouter de l'espace en dessous de l'image
                  _buildEmailField(),
                  _buildPasswordField(),
                  _buildLoginAndSignUpButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (String? value) {
        if (value!.isEmpty) return "L'email est obligatoire.";
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Entrez un email valide.';
        }
        return null;
      },
      onSaved: (String? value) => _email = value!,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Mot de passe'),
      obscureText: true,
      validator: (String? value) {
        if (value!.isEmpty) return 'Veuillez renseigner votre mot de passe.';

        return null;
      },
      onSaved: (String? value) => _password = value!,
    );
  }

  Widget _buildLoginAndSignUpButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
            height:
                80), // Ajoutez cette ligne pour ajouter de l'espace au-dessus du bouton de connexion
        ElevatedButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            _formKey.currentState?.save();

            String result = await _authService.seConnecter(_email, _password);

            if (result == 'admin') {
              // Si l'utilisateur est un administrateur, naviguez vers AdminDashboardScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminDashboardScreen()),
              );
            } else if (result !=
                    "L'email ou le mot de passe sont incorrets. Veuillez réessayer" &&
                result != 'Une erreur est survenue. Veuillez réessayer') {
              // Si l'utilisateur est un utilisateur normal, naviguez vers HomeScreen
              String nom = await _authService
                  .recupererNom(FirebaseAuth.instance.currentUser!.uid);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    avatarPath: '',
                    fullName: nom,
                  ),
                ),
              );
            } else {
              // Afficher le message d'erreur avec un SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7BF853),
            minimumSize:
                const Size(200, 60), // Modifiez la taille du bouton ici
            padding: const EdgeInsets.symmetric(
                horizontal: 20), // Modifiez le padding ici si nécessaire
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Définir le rayon ici
            ),
          ),
          child: const Text('Connexion',
              style: TextStyle(
                  fontSize:
                      20)), // Modifiez la taille du texte ici si nécessaire
        ),

        const SizedBox(height: 30), // Modifiez la hauteur si nécessaire
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7BF853),
            minimumSize:
                const Size(200, 60), // Modifiez la taille du bouton ici
            padding: const EdgeInsets.symmetric(
                horizontal: 20), // Modifiez le padding ici si nécessaire
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Définir le rayon ici
            ),
          ),
          child: const Text("S'inscrire",
              style: TextStyle(
                  fontSize:
                      20)), // Modifiez la taille du texte ici si nécessaire
        ),
      ],
    );
  }
}
