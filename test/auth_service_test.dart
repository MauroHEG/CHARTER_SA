import 'package:charter_appli_travaux_mro/view/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late AuthService authService;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFirestore = MockFirebaseFirestore();
    authService =
        AuthService(auth: mockFirebaseAuth, firestore: mockFirebaseFirestore);
  });

  test('seConnecter renvoie le bon message d\'erreur', () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'test@test.com', password: 'password'))
        .thenThrow(FirebaseAuthException(code: 'user-not-found'));

    expect(await authService.seConnecter('test@test.com', 'password'),
        "L'email ou le mot de passe sont incorrets. Veuillez réessayer");
  });
}
