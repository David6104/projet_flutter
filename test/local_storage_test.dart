import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_flutter/services/local_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tests de Sauvegarde Locale (SharedPreferences)', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('shouldHideWelcomeScreen doit être FAUX au premier lancement', () async {
      final hide = await LocalStorage.shouldHideWelcomeScreen();
      expect(hide, false);
    });

    test('setHideWelcomeScreen doit mémoriser le choix', () async {
      await LocalStorage.setHideWelcomeScreen(true);
      final hide = await LocalStorage.shouldHideWelcomeScreen();
      expect(hide, true);
    });
  });
}