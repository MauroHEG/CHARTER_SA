import 'package:charter_appli_travaux_mro/view/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  group('Test de la méthode enregistrerUtilisateur', () {
    late AuthService authService;
    late MockFirebaseAuth auth;
    late FakeFirebaseFirestore firestore;

    setUp(() {
      auth = MockFirebaseAuth(signedIn: false);
      firestore = FakeFirebaseFirestore();
      authService = AuthService(auth: auth, firestore: firestore);
    });

    test("Un utilisateur doit être ajouté à Firebase", () async {
      // Les données pour l'inscription
      final email = 'test@test.com';
      final password = 'motdepasse';
      final firstName = 'Jean';
      final lastName = 'Dupont';
      final phoneNumber = '0123456789';

      await authService.enregistrerUtilisateur(
          email, password, firstName, lastName, phoneNumber);

      // Vérifier si l'utilisateur est bien créé dans FirebaseAuth
      final firebaseUser = auth.currentUser!;
      expect(firebaseUser.email, email);

      // Vérifier si les données de l'utilisateur sont bien stockées dans Firestore
      final userDoc = await firestore
          .collection('utilisateurs')
          .doc(firebaseUser.uid)
          .get();

      expect(userDoc['prenom'], firstName);
      expect(userDoc['nom'], lastName);
      expect(userDoc['email'], email);
      expect(userDoc['telephone'], phoneNumber);
      expect(userDoc['role'], 'user');
    });
  });
}
