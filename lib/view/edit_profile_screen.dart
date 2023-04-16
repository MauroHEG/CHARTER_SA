import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userProfile;

  EditProfileScreen({required this.userProfile});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _emailController;
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _telephoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();

    // Récupérer les données de l'utilisateur depuis Firebase et les affecter aux contrôleurs
    _fetchUserData();

    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userData =
          await _firestore.collection('utilisateurs').doc(user.uid).get();
      setState(() {
        _emailController = TextEditingController(text: userData['email']);
        _nomController = TextEditingController(text: userData['nom']);
        _prenomController = TextEditingController(text: userData['prenom']);
        _telephoneController =
            TextEditingController(text: userData['telephone']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le profil'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une adresse e-mail';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prenomController,
                decoration: InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prénom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telephoneController,
                decoration: InputDecoration(labelText: 'Téléphone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration:
                    InputDecoration(labelText: 'Confirmer le mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer le mot de passe';
                  }
                  if (value != _passwordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
// Sauvegarder les modifications du profil dans Firebase
                    _updateProfile();
                  }
                },
                child: Text('Enregistrer les modifications'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
// Mettre à jour les données utilisateur dans Firestore
      await _firestore.collection('utilisateurs').doc(user.uid).update({
        'email': _emailController.text,
        'nom': _nomController.text,
        'prenom': _prenomController.text,
        'telephone': _telephoneController.text,
      });

      // Mettre à jour l'adresse e-mail de l'utilisateur dans Firebase Auth
      await user.updateEmail(_emailController.text);

      // Mettre à jour le mot de passe de l'utilisateur dans Firebase Auth
      await user.updatePassword(_passwordController.text);

      // Affichez un message pour indiquer que les modifications ont été enregistrées
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Modifications enregistrées')),
      );

      // Rediriger vers la page précédente
      Navigator.pop(context);
    }
  }
}
