import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_info_provider.dart';
import '../utils/appStrings.dart';
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
        decoration: BoxDecoration(
          color: Color(0xFFD9F5D0),
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
        if (value!.isEmpty) return 'Le mot de passe est obligatoire.';
        if (value.length < 6)
          return 'Le mot de passe doit contenir au moins 6 caractères.';
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
            // Process the entered data here
            _seConnecter();
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF7BF853),
            minimumSize: Size(200, 60), // Modifiez la taille du bouton ici
            padding: EdgeInsets.symmetric(
                horizontal: 20), // Modifiez le padding ici si nécessaire
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
          ),
          child: Text("S'inscrire",
              style: TextStyle(
                  fontSize:
                      20)), // Modifiez la taille du texte ici si nécessaire
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

      // Récupérez le rôle de l'utilisateur
      String role = await _recupererRole(userId);

      // Stockez le rôle dans le UserInfoProvider
      Provider.of<UserInfoProvider>(context, listen: false).setRole(role);

      // Connexion réussie, naviguer vers l'écran d'accueil
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

  Future<String> _recupererRole(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('utilisateurs')
        .doc(userId)
        .get();
    return doc.data()?['role'] ??
        'role'; // Utilisez la clé correspondant au champ 'role' dans votre base de données
  }
}
