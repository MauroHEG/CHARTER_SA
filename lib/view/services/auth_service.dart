import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_info_provider.dart';
import '../../web_admin/screens/admin_dashboard_screen.dart';
import '../home_screen.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> enregistrerUtilisateur(String email, String password,
      String firstName, String lastName, String phoneNumber) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Enregistrer les autres informations dans Cloud Firestore
      await _firestore
          .collection('utilisateurs')
          .doc(userCredential.user!.uid)
          .set({
        'prenom': firstName,
        'nom': lastName,
        'email': email,
        'telephone': phoneNumber,
        'role': 'user'
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Le mot de passe est trop faible.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Le compte existe déjà pour cet e-mail.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> seConnecter(String email, String password,
      {BuildContext? context}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      String userId = userCredential.user!.uid;
      String nom = await _recupererNom(userId);

      // Récupérez le rôle de l'utilisateur
      String role = await _recupererRole(userId);

      // Stockez le rôle dans le UserInfoProvider
      Provider.of<UserInfoProvider>(context!, listen: false).setRole(role);

      // Connexion réussie, naviguer vers l'écran d'accueil ou l'écran du tableau de bord administrateur
      if (role == 'admin') {
        // Si l'utilisateur est un administrateur, naviguez vers AdminDashboardScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        );
      } else {
        // Si l'utilisateur est un utilisateur normal, naviguez vers HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              avatarPath: '',
              fullName: nom,
            ),
          ),
        );
      }
    } on FirebaseAuthException {
      String messageErreur;

      messageErreur =
          "L'email ou le mot de passe sont incorrets. Veuillez réessayer";

      // Afficher le message d'erreur avec un SnackBar
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          content: Text(messageErreur),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<String> _recupererNom(String userId) async {
    DocumentSnapshot doc =
        await _firestore.collection('utilisateurs').doc(userId).get();
    return doc['prenom'] + ' ' + doc['nom'];
  }

  Future<String> _recupererRole(String userId) async {
    DocumentSnapshot doc =
        await _firestore.collection('utilisateurs').doc(userId).get();
    return doc['role'];
  }
}
