import 'package:charter_appli_travaux_mro/main.dart';
import 'package:charter_appli_travaux_mro/view/login_screen.dart';
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

  group('Sign Up Tests', () {
    // Définition des champs de formulaire
    final Finder firstNameField = find.byKey(Key('firstName'));
    final Finder lastNameField = find.byKey(Key('lastName'));
    final Finder emailField = find.byKey(Key('email'));
    final Finder passwordField = find.byKey(Key('password'));
    final Finder confirmPasswordField = find.byKey(Key('confirmPassword'));
    final Finder phoneNumberField = find.byKey(Key('phoneNumber'));
    final Finder signUpButton = find.byKey(Key('signUpButton'));

    // Finder pour le bouton qui conduit à la page d'inscription
    final Finder goToSignUpButton = find.byKey(Key('goToSignUp'));

    testWidgets('Sign up with valid details', (WidgetTester tester) async {
      // Lancez l'application
      await tester.pumpWidget(MyApp());
      // Accédez à la page d'inscription
      await tester.tap(find.byKey(Key('goToSignUp')));
      await tester.pumpAndSettle();

      // Remplir les champs du formulaire avec des données valides
      await tester.enterText(firstNameField, 'Test');
      await tester.enterText(lastNameField, 'User');
      await tester.enterText(emailField, 'testuser@gmail.com');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'password123');
      await tester.enterText(phoneNumberField, '1234567890');

      // Appuyez sur le bouton d'inscription
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      // Vérifier si l'utilisateur est redirigé vers la page de connexion
      // Remplacez `LoginScreen` par la classe de votre page de connexion
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('Sign up with invalid details', (WidgetTester tester) async {
      // TODO: Remplir le test d'inscription avec des détails non valides
    });
  });
}
