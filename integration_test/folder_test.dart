import 'package:charter_appli_travaux_mro/view/documents_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:charter_appli_travaux_mro/main.dart';
import 'package:firebase_core/firebase_core.dart';

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

  group('Documents Screen Tests', () {
    // Finder for Floating Action Button
    final Finder fabFinder = find.byType(FloatingActionButton);

    testWidgets('FAB should be found', (WidgetTester tester) async {
      // Lancez l'application
      await tester.pumpWidget(MyApp());

      // Vérifiez que le FloatingActionButton pour ajouter un dossier s'affiche
      expect(fabFinder, findsOneWidget);
    });

    testWidgets('FAB should open dialog', (WidgetTester tester) async {
      // Lancez l'application
      await tester.pumpWidget(MyApp());

      // Appuyez sur le FloatingActionButton
      await tester.tap(fabFinder);
      await tester.pumpAndSettle();

      // Vérifiez que le dialogue s'ouvre
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    // TODO: Add more tests to simulate filling the form, deleting a folder, and navigation...
  });
}
