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
      const email = 'testtest@test.com';
      const password = 'motdepasse';
      const firstName = 'Jean';
      const lastName = 'Dupont';
      const phoneNumber = '0123456789';

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

    test("Un utilisateur ne peut pas être en double dans Firebase", () async {
      // Les données pour l'inscription
      const email = 'test@test.com';
      const password = 'password';
      const firstName = 'Jean';
      const lastName = 'Dupont';
      const phoneNumber = '0123456789';

      // Créer une instance de FirebaseAuth avec un utilisateur déjà inscrit
      final auth = MockFirebaseAuth(
          mockUser: MockUser(isAnonymous: false, uid: '123', email: email));

      // Instancier le service avec l'instance de FirebaseAuth
      final authService = AuthService(auth: auth, firestore: firestore);

      // On essaie d'inscrire un deuxième utilisateur avec le même email
      String? errorMessage = await authService.enregistrerUtilisateur(
          email, password, firstName, lastName, phoneNumber);

      // Vérifier que le bon message d'erreur est renvoyé
      expect(errorMessage, 'Cet e-mail est déjà utilisé.');
    });
  });

  test('champs obligatoire (peut pas sinscrire sans les champs obligatoires)',
      () {});

  test('mots de passe trop faible', () {});

  test('validation format adresse mail', () {});
}
