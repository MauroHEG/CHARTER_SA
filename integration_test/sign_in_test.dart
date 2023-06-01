import 'package:charter_appli_travaux_mro/main.dart';
import 'package:charter_appli_travaux_mro/view/home_screen.dart';
import 'package:charter_appli_travaux_mro/view/login_screen.dart';
import 'package:charter_appli_travaux_mro/view/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Initialise Firebase
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyMock',
        authDomain: 'charter-bd51b.firebaseapp.com',
        databaseURL: 'https://charter-bd51b.firebaseio.com',
        projectId: 'charter-bd51b',
        storageBucket: 'charter-bd51b.appspot.com',
        messagingSenderId: '256587',
        appId: '1:256587:web:ce1be1be56f3e6c3',
      ),
    );
  });

  group('Login Tests', () {
    // Définition des champs de formulaire
    final Finder emailField = find.byKey(Key('email'));
    final Finder passwordField = find.byKey(Key('password'));
    final Finder loginButton = find.byKey(Key('loginButton'));

    // Finder pour le bouton qui conduit à la page d'inscription
    final Finder goToSignUpButton = find.byKey(Key('goToSignUp'));

    testWidgets('Login with valid details', (WidgetTester tester) async {
      // Lancez l'application
      await tester.pumpWidget(MyApp());

      // Remplir les champs du formulaire avec des données valides
      await tester.enterText(emailField, 'testuser@gmail.com');
      await tester.enterText(passwordField, 'password123');

      // Appuyez sur le bouton de connexion
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Vérifier si l'utilisateur est redirigé vers la page d'accueil
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Login with invalid details', (WidgetTester tester) async {
      // Lancez l'application
      await tester.pumpWidget(MyApp());

      // Remplir les champs du formulaire avec des données non valides
      await tester.enterText(emailField, 'invaliduser@gmail.com');
      await tester.enterText(passwordField, 'wrongpassword');

      // Appuyez sur le bouton de connexion
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Vérifier si l'utilisateur reste sur la page de connexion
      expect(find.byType(LoginScreen), findsOneWidget);

      // Vérifiez si le message d'erreur est affiché
      expect(
          find.text(
              'L\'email ou le mot de passe sont incorrets. Veuillez réessayer'),
          findsOneWidget);
    });

    testWidgets('Navigate to Sign Up', (WidgetTester tester) async {
      // Lancez l'application
      await tester.pumpWidget(MyApp());

      // Appuyez sur le bouton 'goToSignUp'
      await tester.tap(goToSignUpButton);
      await tester.pumpAndSettle();

      // Vérifier si l'utilisateur est redirigé vers la page d'inscription
      expect(find.byType(SignUpScreen), findsOneWidget);
    });
  });
}
