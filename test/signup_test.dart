import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:charter_appli_travaux_mro/view/services/auth_service.dart';
import 'package:mockito/mockito.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late FakeFirebaseFirestore mockFirestore;
  late AuthService authService;

  setUp(() {
    mockAuth = MockFirebaseAuth(signedIn: false);
    mockFirestore = FakeFirebaseFirestore();
    authService = AuthService(auth: mockAuth, firestore: mockFirestore);
  });

  test('Test enregistrerUtilisateur', () async {
    final email = 'test@test.com';
    final password = 'password';
    final firstName = 'Test';
    final lastName = 'User';
    final phoneNumber = '1234567890';

    // Créer un faux utilisateur
    final user = MockUser(
      isAnonymous: false,
      uid: '123456',
      email: email,
      displayName: '$firstName $lastName',
      phoneNumber: phoneNumber,
    );

    // Simuler la connexion de l'utilisateur
    when(mockAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .thenAnswer((_) => Future.value(user as FutureOr<UserCredential>?));

    // Appeler la méthode à tester
    final result = await authService.enregistrerUtilisateur(
        email, password, firstName, lastName, phoneNumber);

    // Vérifier qu'aucune erreur n'a été renvoyée
    expect(result, isNull);

    // Vérifier que les données de l'utilisateur ont été correctement enregistrées dans Firestore
    final userData =
        await mockFirestore.collection('utilisateurs').doc(user.uid).get();
    expect(userData.data(), isNotNull);
    expect(userData.data()!['prenom'], equals(firstName));
    expect(userData.data()!['nom'], equals(lastName));
    expect(userData.data()!['nom_lower'], equals(lastName.toLowerCase()));
    expect(userData.data()!['email'], equals(email));
    expect(userData.data()!['telephone'], equals(phoneNumber));
    expect(userData.data()!['role'], equals('user'));
  });
}
