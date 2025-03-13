// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TarifAI';

  @override
  String get addIngredient => 'Add ingredient';

  @override
  String get ingredientHint => 'Enter ingredient name';

  @override
  String get ingredientLabel => 'Ingredient';

  @override
  String get addedIngredients => 'Added Ingredients:';

  @override
  String get clearAllIngredients => 'Clear all ingredients';

  @override
  String get listRecipes => 'List Recipes';

  @override
  String get suggestedRecipes => 'Suggested Recipes:';

  @override
  String get pleaseAddIngredient => 'Please add at least one ingredient';

  @override
  String error(String error) {
    return 'Error occurred: $error';
  }

  @override
  String get login => 'Login';
}
