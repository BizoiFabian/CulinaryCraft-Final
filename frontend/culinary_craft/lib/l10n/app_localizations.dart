import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ro'),
  ];

  static AppLocalizations of(BuildContext context) {
    final AppLocalizations? result =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(result != null, 'No AppLocalizations found in context');
    return result!;
  }

  static const Map<String, Map<String, String>> _localizedValues =
      <String, Map<String, String>>{
    'en': <String, String>{
      'appTitle': 'Culinary Craft',
      'getStarted': 'Get Started',
      'signIn': 'Sign In',
      'username': 'Username',
      'password': 'Password',
      'forgotPassword': "I don't remember my password",
      'createAccount': 'Create Account',
      'dontHaveAccount': "Don't have an account yet?",
      'loading': 'Loading...',
      'helloUser': 'Hello, {username}',
      'guest': 'Guest',
      'editProfile': 'Edit Profile',
      'myRecipes': 'My Recipes',
      'savedRecipes': 'Saved Recipes',
      'aboutUs': 'About Us',
      'logout': 'Log out',
      'appearance': 'Appearance',
      'theme': 'Theme',
      'language': 'Language',
      'systemTheme': 'System',
      'lightTheme': 'Light',
      'darkTheme': 'Dark',
      'romanian': 'Romanian',
      'english': 'English',
      'enterUsername': 'Please enter your username',
      'enterPassword': 'Please enter your password',
      'createRecipe': 'Create Recipe',
      'recipeName': 'Recipe Name',
      'description': 'Description',
      'ingredients': 'Ingredients',
      'uploadImage': 'Upload Image',
      'requiredFields': 'All fields are required',
      'createRecipeFailed': 'Failed to create recipe',
    },
    'ro': <String, String>{
      'appTitle': 'Culinary Craft',
      'getStarted': 'Incepe',
      'signIn': 'Autentificare',
      'username': 'Nume utilizator',
      'password': 'Parola',
      'forgotPassword': 'Nu imi amintesc parola',
      'createAccount': 'Creeaza cont',
      'dontHaveAccount': 'Nu ai inca un cont?',
      'loading': 'Se incarca...',
      'helloUser': 'Salut, {username}',
      'guest': 'Vizitator',
      'editProfile': 'Editeaza profilul',
      'myRecipes': 'Retetele mele',
      'savedRecipes': 'Retete salvate',
      'aboutUs': 'Despre noi',
      'logout': 'Deconectare',
      'appearance': 'Aspect',
      'theme': 'Tema',
      'language': 'Limba',
      'systemTheme': 'Sistem',
      'lightTheme': 'Luminoasa',
      'darkTheme': 'Intunecata',
      'romanian': 'Romana',
      'english': 'Engleza',
      'enterUsername': 'Te rugam sa introduci numele de utilizator',
      'enterPassword': 'Te rugam sa introduci parola',
      'createRecipe': 'Creeaza reteta',
      'recipeName': 'Nume reteta',
      'description': 'Descriere',
      'ingredients': 'Ingrediente',
      'uploadImage': 'Incarca imagine',
      'requiredFields': 'Toate campurile sunt necesare',
      'createRecipeFailed': 'Crearea retetei a esuat',
    },
  };

  String _text(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key]!;
  }

  String get appTitle => _text('appTitle');
  String get getStarted => _text('getStarted');
  String get signIn => _text('signIn');
  String get username => _text('username');
  String get password => _text('password');
  String get forgotPassword => _text('forgotPassword');
  String get createAccount => _text('createAccount');
  String get dontHaveAccount => _text('dontHaveAccount');
  String get loading => _text('loading');
  String get guest => _text('guest');
  String get editProfile => _text('editProfile');
  String get myRecipes => _text('myRecipes');
  String get savedRecipes => _text('savedRecipes');
  String get aboutUs => _text('aboutUs');
  String get logout => _text('logout');
  String get appearance => _text('appearance');
  String get theme => _text('theme');
  String get language => _text('language');
  String get systemTheme => _text('systemTheme');
  String get lightTheme => _text('lightTheme');
  String get darkTheme => _text('darkTheme');
  String get romanian => _text('romanian');
  String get english => _text('english');
  String get enterUsername => _text('enterUsername');
  String get enterPassword => _text('enterPassword');
  String get createRecipe => _text('createRecipe');
  String get recipeName => _text('recipeName');
  String get description => _text('description');
  String get ingredients => _text('ingredients');
  String get uploadImage => _text('uploadImage');
  String get requiredFields => _text('requiredFields');
  String get createRecipeFailed => _text('createRecipeFailed');

  String helloUser(String username) {
    return _text('helloUser').replaceAll('{username}', username);
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((Locale supported) => supported.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
