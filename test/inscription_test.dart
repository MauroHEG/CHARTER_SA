import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:test/test.dart';
import 'package:charter_appli_travaux_mro/view/signup_screen.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

//Test unitaire pour la fonctionnalitée "Inscription" --> [signup_screen.dart]
void main() async {
  //setUp() est appelée avant chaque test (nettoyer bdd)
  /*setUp(() {
    //Code nettoyer bdd
  });*/
  //Initialisation de la cloud firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  group('Utilisateur unique', () {
    //Création d'un utilisateur inexistant sur une FakeFirebase (bdd pour les tests)
    test('test fonctionnalitée : _enregistrerUtilisateur()', () async {
      // Créer une instance de FakeFirebaseFirestore
      final fakeFirestore = FakeFirebaseFirestore();

      // Créer une instance de FirebaseAuth avec un utilisateur enregistré
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: 'elvio.vic@gmail.com', password: 'mdp123!test');

      await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(userCredential.user!.uid)
          .set({
        'prenom': "elvio",
        'nom': "Dupont",
        'email': "elvio.vic@gmail.com",
        'telephone': "0779415789",
        'role': 'user'
      });

      // Vérifier que l'utilisateur a été enregistré dans Firestore
      final snapshot = await fakeFirestore
          .collection('utilisateurs')
          .doc(userCredential.user!.uid)
          .get();
      expect(snapshot.exists, isTrue);
      expect(snapshot.data()!['prenom'], equals('elvio'));
      expect(snapshot.data()!['nom'], equals('Dupont'));
      expect(snapshot.data()!['email'], equals('elvio.vic@gmail.com'));
      expect(snapshot.data()!['telephone'], equals('0779415789'));
      expect(snapshot.data()!['role'], equals('user'));
      /*final instance = FakeFirebaseFirestore();
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: "elvio.vic@gmail.com", password: "mdp123!test");
      await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(userCredential.user!.uid)
          .set({
        'prenom': "elvio",
        'nom': "Dupont",
        'email': "elvio.vic@gmail.com",
        'telephone': "0779415789",
        'role': 'user'
      });*/
    });

    //Création du même utilisateur (doit générer une erreur)
    test('utilisateur en double', () {});
  });
}
