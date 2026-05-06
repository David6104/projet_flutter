import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/services/local_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tests LocalStorage (Remplacement de SettingViewModel)', () {
    test('charge et sauvegarde correctement l état de l écran d accueil',
        () async {
      // Simule les SharedPreferences
      SharedPreferences.setMockInitialValues({'hide_welcome': true});

      bool hide = await LocalStorage.shouldHideWelcomeScreen();
      expect(hide, true);

      // Modifie et revérifie
      await LocalStorage.setHideWelcomeScreen(false);
      hide = await LocalStorage.shouldHideWelcomeScreen();
      expect(hide, false);
    });
  });
}
