import 'package:charter_appli_travaux_mro/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

//Test unitaire pour la fonctionnalitée "Inscription" --> [signup_screen.dart]
void main() {
  // Initialisez Firebase
  group('Test de la fonctionnalitée Inscription :', () {
    //variable firestore avec le mot clé "late" pour indiquer que sa valeur sera initialisée ultérieurement
    late FirebaseFirestore firestore;

    //setUp() appelée avant l'exécution de chaque test (initialiser ressources dont les tests auront besoins)
    /*setUp(() async {
      //Initialisation de la cloud firebase
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);

      // Utilisez une instance différente de la base de données pour chaque test
      firestore = FirebaseFirestore.instance;
    });

    //tearDown() appelée après l'éxecution de chaque test (nettoyer ressources initialisier par setUp())
    tearDown(() async {
      //vider la persistence locale
      await firestore.clearPersistence();
      //terminer la connexion firestore
      await firestore.terminate();
    });*/

    //Création d'un utilisateur inexistant sur une FakeFirebase (bdd pour les tests)
    test('test inscription nouvel utilisateur', () async {
      //Initialisation de la cloud firebase
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);

      // Utilisez une instance différente de la base de données pour chaque test
      firestore = FirebaseFirestore.instance;

      // Initialiser les entrées de l'utilisateur
      final prenom = 'elvio';
      final nom = 'Dupont';
      final email = 'elvio.vic@gmail.com';
      final password = 'mdp123!test';
      final telephone = '0779415789';
      final role = 'user';

      // Exécuter la fonctionnalité d'inscription
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // Utilisateur créé avec succès

      // Enregistrer les autres informations dans Cloud Firestore
      await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(userCredential.user!.uid)
          .set({
        'prenom': prenom,
        'nom': nom,
        'email': email,
        'telephone': telephone,
        'role': role
      });

      // Vérifier que l'inscription s'est bien déroulée
      //expect(result, true);

      // Vérifier que l'utilisateur a été ajouté à la base de données
      final user = await firestore
          .collection('utilisateurs')
          .doc(userCredential.user!.uid)
          .get();
      expect(user.exists, true);

      //------------------------------------------------------------------------------------------->
      // Vérifier que l'utilisateur a été enregistré dans Firestore
      /*final snapshot = await fakeFirestore
          .collection('utilisateurs')
          .doc(userCredential.user!.uid)
          .get();
      expect(snapshot.exists, isTrue);
      expect(snapshot.data()!['prenom'], equals('elvio'));
      expect(snapshot.data()!['nom'], equals('Dupont'));
      expect(snapshot.data()!['email'], equals('elvio.vic@gmail.com'));
      expect(snapshot.data()!['telephone'], equals('0779415789'));
      expect(snapshot.data()!['role'], equals('user'));*/
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
    test('utilisateur en double', () {
      print("Test");
    });
  });
}
