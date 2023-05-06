import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:charter_appli_travaux_mro/view/signup_screen.dart';

void main() {
  // Initialiser Firebase avant les tests
  setUpAll(() async {
    
    //final FirebaseFirestore firestore = FirebaseFirestore.instance;
    //await Firebase.initializeApp();
  });

  // Fermer Firebase après les tests
  tearDownAll(() async {
    await FirebaseAuth.instance.signOut();
    await Firebase.app().delete();
  });

  // Test de la fonction enregistrerUtilisateur
  test('enregistrerUtilisateur', () async {
    // Créer une instance de la classe à tester
    final SignUpScreen signUpScreen = SignUpScreen();

    // Appeler la fonction à tester avec des données simulées
    final result = signUpScreen.enregistrerUtilisateur('test@test.com', 'password', 'monsieurTest', 'testman', "0789292896");
    final usersRef = FirebaseFirestore.instance.collection('utilisateurs');
    final snapshot = await usersRef.where('email', isEqualTo: 'test@test.com').limit(1).get();
    // Vérifier que le résultat est celui attendu
    expect(snapshot, equals("test@test.com"));
  });
}