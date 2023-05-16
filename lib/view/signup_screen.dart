import 'package:flutter/material.dart';
import '../utils/appStrings.dart';
import 'login_screen.dart';
import 'services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();

  void enregistrerUtilisateur(
      String e, String p, String f, String l, String t) {}
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  String? _firstName,
      _lastName,
      _email,
      _password,
      _confirmPassword,
      _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BF853),
        title: const Text('Inscription', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
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
                  const SizedBox(height: 30),
                  _buildFirstNameField(),
                  _buildLastNameField(),
                  _buildEmailField(),
                  _buildPasswordField(),
                  _buildConfirmPasswordField(),
                  _buildPhoneNumberField(),
                  //_buildDateOfBirthField(),
                  const SizedBox(height: 30),
                  _buildSignUpButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Prénom'),
      validator: (String? value) {
        if (value!.isEmpty) return 'Le prénom est obligatoire.';
        return null;
      },
      onSaved: (String? value) => _firstName = value!,
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Nom'),
      validator: (String? value) {
        if (value!.isEmpty) return 'Le nom est obligatoire.';
        return null;
      },
      onSaved: (String? value) => _lastName = value!,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (String? value) {
        if (value!.isEmpty) return 'L\'email est obligatoire.';
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Entrez un email valide.';
        }
        return null;
      },
      onSaved: (String? value) => _email = value,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Mot de passe'),
      obscureText: true,
      validator: (String? value) {
        if (value!.isEmpty) return 'Le mot de passe est obligatoire.';
        if (value.length < 6) {
          return 'Le mot de passe doit contenir au moins 6 caractères.';
        }
        return null;
      },
      onSaved: (String? value) => _password = value,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Confirmer le mot de passe'),
      obscureText: true,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'La confirmation du mot de passe est obligatoire.';
        }
        if (_password != null && value != _password) {
          return 'Les mots de passe ne correspondent pas.';
        }
        return null;
      },
      onSaved: (String? value) => _confirmPassword = value!,
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Téléphone'),
      keyboardType: TextInputType.phone,
      validator: (String? value) {
        if (value!.isEmpty) return 'Le numéro de téléphone est obligatoire.';
        return null;
      },
      onSaved: (String? value) => _phoneNumber = value!,
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7BF853),
          minimumSize: const Size(200, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
      child: const Text("S'inscrire", style: TextStyle(fontSize: 20)),
      onPressed: () async {
        if (!_formKey.currentState!.validate()) return;
        _formKey.currentState?.save();
        String? errorMessage = await _authService.enregistrerUtilisateur(
            _email!, _password!, _firstName!, _lastName!, _phoneNumber!);
        if (errorMessage != null) {
          // Afficher le message d'erreur
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        } else {
          // Naviguer vers l'écran de connexion ou l'écran d'accueil
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      },
    );
  }
}
