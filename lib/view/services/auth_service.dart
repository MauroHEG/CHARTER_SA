import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String?> enregistrerUtilisateur(String email, String password,
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
        'nom_lower': lastName.toLowerCase(),
        'email': email,
        'telephone': phoneNumber,
        'role': 'user'
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Mot de passe trop faible';
      } else if (e.message!
          .contains('The email address is already in use by another account')) {
        return 'Cet e-mail est déjà utilisé.';
      }
    } catch (e) {
      return 'Une erreur est survenue lors de l\'inscription.';
    }

    return null;
  }

  Future<String> seConnecter(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      String userId = userCredential.user!.uid;

      // Récupérez le rôle de l'utilisateur
      String role = await recupererRole(userId);

      return role;
    } on FirebaseAuthException {
      return "L'email ou le mot de passe sont incorrets. Veuillez réessayer";
    } catch (e) {
      print(e);
      return 'Une erreur est survenue. Veuillez réessayer';
    }
  }

  Future<String> recupererNom(String userId) async {
    DocumentSnapshot doc =
        await _firestore.collection('utilisateurs').doc(userId).get();
    return doc['prenom'] + ' ' + doc['nom'];
  }

  Future<String> recupererRole(String userId) async {
    DocumentSnapshot doc =
        await _firestore.collection('utilisateurs').doc(userId).get();
    return doc['role'];
  }
}
