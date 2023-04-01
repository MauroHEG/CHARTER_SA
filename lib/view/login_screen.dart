import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7BF853),
        title: Text('Connexion', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Color(0xFFD9F5D0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(''),
              _buildEmailField(),
              _buildPasswordField(),
              _buildLoginAndSignUpButtons(),
            ],
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
        if (value!.isEmpty) return 'Le mot de passe est obligatoire.';
        if (value.length < 6)
          return 'Le mot de passe doit contenir au moins 6 caractères.';
        return null;
      },
      onSaved: (String? value) => _password = value!,
    );
  }
// ...

  Widget _buildLoginAndSignUpButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            _formKey.currentState?.save();
            // Process the entered data here
            _seConnecter();
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF7BF853),
          ),
          child: Text('Connexion'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF7BF853),
          ),
          child: Text("S'inscrire"),
        ),
      ],
    );
  }

  Future<String> _recupererNom(String userId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('utilisateurs')
        .doc(userId)
        .get();
    return documentSnapshot.get('nom');
  }

  Future<void> _seConnecter() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      String userId = userCredential.user!.uid;
      String nom = await _recupererNom(userId);
      // Connexion réussie, naviguer vers l'écran d'accueil ou autre écran approprié
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    avatarPath: '',
                    fullName: nom,
                  )));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("Aucun utilisateur trouvé pour cet e-mail.");
      } else if (e.code == 'wrong-password') {
        print("Le mot de passe est incorrect.");
      }
    } catch (e) {
      print(e);
    }
  }
}
