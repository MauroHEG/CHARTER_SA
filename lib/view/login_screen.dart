import 'package:charter_appli_travaux_mro/view/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_info_provider.dart';
import '../utils/appStrings.dart';
import '../web_admin/screens/admin_dashboard_screen.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
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
        backgroundColor: Color(0xFF7BF853),
        title: Text('Connexion', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image(
                    image: AssetImage(AppStrings.cheminLogo),
                  ),
                  SizedBox(
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
      decoration: InputDecoration(labelText: 'Email'),
      validator: (String? value) {
        if (value!.isEmpty) return "L'email est obligatoire.";
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
          return 'Entrez un email valide.';
        return null;
      },
      onSaved: (String? value) => _email = value!,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Mot de passe'),
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
        SizedBox(
            height:
                80), // Ajoutez cette ligne pour ajouter de l'espace au-dessus du bouton de connexion
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            _formKey.currentState?.save();
            _authService.seConnecter(
                context, _email, _password); // Modifiez cette ligne
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF7BF853),
            minimumSize: Size(200, 60), // Modifiez la taille du bouton ici
            padding: EdgeInsets.symmetric(
                horizontal: 20), // Modifiez le padding ici si nécessaire
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Définir le rayon ici
            ),
          ),
          child: Text('Connexion',
              style: TextStyle(
                  fontSize:
                      20)), // Modifiez la taille du texte ici si nécessaire
        ),
        SizedBox(height: 30), // Modifiez la hauteur si nécessaire
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF7BF853),
            minimumSize: Size(200, 60), // Modifiez la taille du bouton ici
            padding: EdgeInsets.symmetric(
                horizontal: 20), // Modifiez le padding ici si nécessaire
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Définir le rayon ici
            ),
          ),
          child: Text("S'inscrire",
              style: TextStyle(
                  fontSize:
                      20)), // Modifiez la taille du texte ici si nécessaire
        ),
      ],
    );
  }
}
