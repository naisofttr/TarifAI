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
  String error(Object error) {
    return 'Hata oluştu: $error';
  }

  @override
  String get login => 'Giriş Yap';

  @override
  String get welcomeTitle => 'TarifAI\'ya Hoş Geldiniz!';

  @override
  String get welcomeDescription => 'Elinizde olan malzemeleri girin, size yapabileceğiniz lezzetli tarifleri önereyim.';

  @override
  String get noIngredientsMessage => 'Mutfağınızda olan malzemeleri eklemeye başlayın';

  @override
  String get addIngredientButtonTooltip => 'Bu malzemeyi listenize ekleyin';

  @override
  String get ingredientInputHelper => 'Bir malzeme yazın ve + tuşuna veya Enter\'a basın';

  @override
  String get ingredientAlreadyExists => 'Bu malzeme zaten listenizde mevcut';
}
