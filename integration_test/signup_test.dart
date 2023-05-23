import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Test d\'inscription', () {
    final firstNameField = find.byValueKey('firstName');
    final lastNameField = find.byValueKey('lastName');
    final emailField = find.byValueKey('email');
    final passwordField = find.byValueKey('password');
    final confirmPasswordField = find.byValueKey('confirmPassword');
    final phoneNumberField = find.byValueKey('phoneNumber');
    final signUpButton = find.text('S\'inscrire');

    late FlutterDriver driver;

    // Connexion au driver Flutter avant les tests
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Déconnexion du driver Flutter après les tests
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Remplir le formulaire d\'inscription', () async {
      // Assurez-vous que l'application est entièrement chargée
      await driver.waitFor(find.text('Inscription'));

      // Remplir le formulaire
      await driver.tap(firstNameField);
      await driver.enterText('PrénomTest');

      await driver.tap(lastNameField);
      await driver.enterText('NomTest');

      await driver.tap(emailField);
      await driver.enterText('test@test.com');

      await driver.tap(passwordField);
      await driver.enterText('passwordTest');

      await driver.tap(confirmPasswordField);
      await driver.enterText('passwordTest');

      await driver.tap(phoneNumberField);
      await driver.enterText('0123456789');

      // Appuyer sur le bouton d'inscription
      await driver.tap(signUpButton);
    });
  });
}
