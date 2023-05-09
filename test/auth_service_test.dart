import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:charter_appli_travaux_mro/view/services/auth_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;
    late FirebaseAuth auth;

    setUp(() {
      auth = MockFirebaseAuth(
          mockUser: MockUser(
        uid: '123456',
        email: 'test@test.com',
      ));
      authService = AuthService(auth: auth);
    });

    test('se connecter avec succès', () async {
      await authService.seConnecter('test@test.com', 'password123');

      // Vérifiez que l'utilisateur est connecté
      expect(auth.currentUser!.email, 'test@test.com');
    });

    // Ce test vérifie si une exception est levée lorsque l'email ou le mot de passe sont incorrects
    test('échec de la connexion avec des identifiants incorrects', () async {
      auth = MockFirebaseAuth(signedIn: false);
      authService = AuthService(auth: auth);

      try {
        await authService.seConnecter('test@test.com', 'wrong-password');
        fail('L\'exception FirebaseAuthException n\'a pas été levée');
      } catch (e) {
        expect(e, isA<FirebaseAuthException>());
      }
    });
  });
}
