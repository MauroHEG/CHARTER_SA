import 'package:charter_appli_travaux_mro/view/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../utils/appStrings.dart';
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
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            _formKey.currentState?.save();
            _authService.seConnecter(_email, _password,
                context: context); // Modifiez cette ligne
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
