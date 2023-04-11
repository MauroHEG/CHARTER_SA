import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/test.dart';
import 'package:charter_appli_travaux_mro/view/signup_screen.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

//Test unitaire pour la fonctionnalitée "Inscription" --> [signup_screen.dart]
void main() {
  //setUp() est appelée avant chaque test (nettoyer bdd)
  setUp(() {
    //Code nettoyer bdd
  });

  group('Utilisateur unique', () {
    //Création d'un utilisateur inexistant
    test('utilisateur unique', () async {
      final instance = FakeFirebaseFirestore();
      /*try {
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
        });
      } catch (e) {}*/
    });

    //Création du même utilisateur (doit générer une erreur)
    test('utilisateur en double', () {});
  });
}
