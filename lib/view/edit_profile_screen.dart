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
                decoration: InputDecoration(
                    labelText:
                        'Mot de passe (laisser vide pour conserver le mot de passe actuel)'),
                obscureText: true,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return 'Le mot de passe doit comporter au moins 6 caractères';
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
                  if (_passwordController.text.isNotEmpty &&
                      value != _passwordController.text) {
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
    try {
      // Mettre à jour l'adresse e-mail de l'utilisateur dans FirebaseAuth
      await FirebaseAuth.instance.currentUser!
          .updateEmail(_emailController.text)
          .catchError((error) async {
        if (error.code == 'requires-recent-login') {
          // Demander à l'utilisateur de se reconnecter
          bool reauthenticated = await _reauthenticateUser();
          if (reauthenticated) {
            // Réessayer de mettre à jour l'email après la reconnexion
            await FirebaseAuth.instance.currentUser!
                .updateEmail(_emailController.text);
          }
        } else {
          throw error;
        }
      });

      // Mettre à jour les informations de l'utilisateur dans Firestore
      await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'email': _emailController.text,
        'nom': _nomController.text,
        'prenom': _prenomController.text,
        'telephone': _telephoneController.text,
      });

      // Mettre à jour le mot de passe de l'utilisateur dans FirebaseAuth si un nouveau mot de passe a été saisi
      if (_passwordController.text.isNotEmpty) {
        await FirebaseAuth.instance.currentUser!
            .updatePassword(_passwordController.text);
      }

      // Afficher un message de réussite et revenir à l'écran précédent
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profil mis à jour avec succès")),
      );
      Navigator.pop(context);
    } catch (e) {
      // Afficher un message d'erreur en cas d'échec de la mise à jour
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la mise à jour du profil : $e")),
      );
    }
  }

  Future<bool> _reauthenticateUser() async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    TextEditingController passwordController = TextEditingController();
    bool result = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reconnexion requise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Pour mettre à jour votre adresse e-mail, vous devez vous reconnecter. Veuillez entrer votre mot de passe actuel.'),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Se reconnecter'),
              onPressed: () async {
                try {
                  // Se reconnecter avec l'email et le mot de passe actuels
                  AuthCredential credential = EmailAuthProvider.credential(
                      email: email, password: passwordController.text);
                  await FirebaseAuth.instance.currentUser!
                      .reauthenticateWithCredential(credential);
                  // Fermer la boîte de dialogue
                  Navigator.of(context).pop();
                  result = true;
                } catch (e) {
                  // Afficher un message d'erreur en cas d'échec de la reconnexion
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Erreur lors de la reconnexion : $e")),
                  );
                  result = false;
                }
              },
            ),
          ],
        );
      },
    );
    return result;
  }
}
