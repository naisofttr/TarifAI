// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'TarifAI';

  @override
  String get addIngredient => 'Malzeme ekle';

  @override
  String get ingredientHint => 'Malzeme ismi girin';

  @override
  String get ingredientLabel => 'Malzeme';

  @override
  String get addedIngredients => 'Eklenen Malzemeler:';

  @override
  String get clearAllIngredients => 'Tüm malzemeleri temizle';

  @override
  String get listRecipes => 'Tarifleri Listele';

  @override
  String get suggestedRecipes => 'Önerilen Tarifler:';

  @override
  String get pleaseAddIngredient => 'Lütfen en az bir malzeme ekleyin';

  @override
  String error(String error) {
    return 'Hata oluştu: $error';
  }

  @override
  String get login => 'Giriş Yap';
}
