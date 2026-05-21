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
      'searchIngredients': 'Search ingredients',
      'noIngredientsFound': 'No ingredients found',
      'helloChef': 'Hello, chef!',
      'selectIngredientsTagline': 'Select ingredients to craft a recipe',
      'recipes': 'Recipes',
      'searchRecipes': 'Search Recipes',
      'addToFavorites': 'Add to favorites',
      'favoriteUpdateFailed': 'Failed to update favorites',
      'connectionError': 'Failed to connect to the server',
      'confirmDelete': 'Confirm delete',
      'confirmDeleteRecipe': 'Are you sure you want to delete this recipe?',
      'delete': 'Delete',
      'recipeDeleted': 'Recipe deleted successfully',
      'recipeDeleteFailed': 'Failed to delete recipe',
      'scanIngredient': 'Scan ingredient',
      'useCamera': 'Use Camera',
      'selectFromGallery': 'Select from Gallery',
      'noRecipesFound': 'No recipes found',
      'failedToLoadIngredients': 'Failed to load ingredients',
      'ingredientAdded': 'Ingredient added: {name}',
      'noIngredientIdentified': 'No ingredient identified from the image',
      'close': 'Close',
      'selectedCount': '{count} selected',
      'clearAll': 'Clear all',
      'welcomeBack': 'Welcome back',
      'account': 'Account',
      'preferences': 'Preferences',
      'email': 'Email',
      'signInSubtitle': 'Sign in to continue cooking',
      'createAccountSubtitle': 'Join the kitchen!',
      'forgotPasswordTitle': 'Forgot password?',
      'forgotPasswordSubtitle': "We'll send you a code to reset your password",
      'sendCode': 'Send Code',
      'enterCodeTitle': 'Enter the code',
      'enterCodeSubtitle': 'Enter the 4-digit code we sent to your email',
      'verifyCode': 'Verify Code',
      'pleaseEnter4DigitCode': 'Please enter a 4-digit code',
      'wrongCode': 'The code is wrong',
      'changePasswordTitle': 'Change password',
      'changePasswordSubtitle': 'Choose a strong, fresh password',
      'newPassword': 'New password',
      'confirmPassword': 'Confirm password',
      'enterNewPassword': 'Please enter a new password',
      'confirmYourPassword': 'Please confirm your new password',
      'passwordsDontMatch': 'Passwords do not match',
      'iAlreadyHaveAccount': 'I already have an account',
      'termsOfUseNote': "By signing up you agree to CulinaryCraft's Terms of Use",
      'continueWithGoogle': 'Continue with Google',
      'signUp': 'Sign Up',
      'or': 'or',
      'welcomeHeroTitle': 'CulinaryCraft',
      'welcomeHeroSubtitle': 'Cook with what you have',
      'dietaryPreferencesTitle': 'Personalize your kitchen',
      'dietaryPreferencesSubtitle': 'Tell us what you avoid — we filter ingredients and recipes for you',
      'dietaryAiHint': 'Gemini AI reads your answers and automatically hides ingredients & recipes you cannot eat.',
      'dietaryFreeTextLabel': 'Or describe in your own words',
      'dietaryFreeTextHint': 'e.g. I am allergic to mushrooms, I do not eat turkey or pork...',
      'dietaryAiAnalyzeAndSave': 'Analyze with AI & save',
      'dietaryVegetarian': 'Vegetarian',
      'dietaryVegan': 'Vegan',
      'dietaryNoMeat': 'No meat',
      'dietaryNoFish': 'No fish / seafood',
      'dietaryNoDairy': 'No dairy',
      'dietaryNoEggs': 'No eggs',
      'dietaryNoGluten': 'No gluten',
      'dietaryNoNuts': 'No nuts',
      'dietaryNoPork': 'No pork',
      'dietarySavePreferences': 'Save preferences',
      'dietarySkipForNow': 'Skip for now',
      'dietaryPreferencesSaved': 'Preferences saved — {count} ingredients hidden',
      'dietaryPreferencesSaveFailed': 'Could not save preferences',
      'dietaryPreferences': 'Dietary preferences',
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
      'searchIngredients': 'Cauta ingrediente',
      'noIngredientsFound': 'Nu am gasit ingrediente',
      'helloChef': 'Salut, bucatare!',
      'selectIngredientsTagline': 'Selecteaza ingrediente pentru o reteta',
      'recipes': 'Retete',
      'searchRecipes': 'Cauta retete',
      'addToFavorites': 'Adauga la favorite',
      'favoriteUpdateFailed': 'Nu s-au putut actualiza favoritele',
      'connectionError': 'Nu s-a putut conecta la server',
      'confirmDelete': 'Confirma stergerea',
      'confirmDeleteRecipe': 'Sigur vrei sa stergi aceasta reteta?',
      'delete': 'Sterge',
      'recipeDeleted': 'Reteta a fost stearsa',
      'recipeDeleteFailed': 'Nu s-a putut sterge reteta',
      'scanIngredient': 'Scaneaza ingredient',
      'useCamera': 'Foloseste camera',
      'selectFromGallery': 'Alege din galerie',
      'noRecipesFound': 'Nu am gasit retete',
      'failedToLoadIngredients': 'Nu am putut incarca ingredientele',
      'ingredientAdded': 'Ingredient adaugat: {name}',
      'noIngredientIdentified': 'Niciun ingredient identificat din imagine',
      'close': 'Inchide',
      'selectedCount': '{count} selectate',
      'clearAll': 'Sterge toate',
      'welcomeBack': 'Bine ai revenit',
      'account': 'Cont',
      'preferences': 'Preferinte',
      'email': 'Email',
      'signInSubtitle': 'Conecteaza-te ca sa gatesti mai departe',
      'createAccountSubtitle': 'Vino la gatit!',
      'forgotPasswordTitle': 'Ai uitat parola?',
      'forgotPasswordSubtitle': 'Iti trimitem un cod pentru resetare',
      'sendCode': 'Trimite codul',
      'enterCodeTitle': 'Introdu codul',
      'enterCodeSubtitle': 'Introdu codul de 4 cifre trimis pe email',
      'verifyCode': 'Verifica codul',
      'pleaseEnter4DigitCode': 'Introdu un cod de 4 cifre',
      'wrongCode': 'Cod incorect',
      'changePasswordTitle': 'Schimba parola',
      'changePasswordSubtitle': 'Alege o parola noua si puternica',
      'newPassword': 'Parola noua',
      'confirmPassword': 'Confirma parola',
      'enterNewPassword': 'Te rugam sa introduci o parola noua',
      'confirmYourPassword': 'Te rugam sa confirmi parola noua',
      'passwordsDontMatch': 'Parolele nu coincid',
      'iAlreadyHaveAccount': 'Am deja un cont',
      'termsOfUseNote': 'Inregistrandu-te accepti Termenii CulinaryCraft',
      'continueWithGoogle': 'Continua cu Google',
      'signUp': 'Inregistrare',
      'or': 'sau',
      'welcomeHeroTitle': 'CulinaryCraft',
      'welcomeHeroSubtitle': 'Gateste cu ce ai in casa',
      'dietaryPreferencesTitle': 'Personalizeaza-ti bucataria',
      'dietaryPreferencesSubtitle': 'Spune-ne ce eviti — filtram ingredientele si retetele pentru tine',
      'dietaryAiHint': 'Gemini AI citeste raspunsurile tale si ascunde automat ingredientele si retetele pe care nu le consumi.',
      'dietaryFreeTextLabel': 'Sau descrie cu cuvintele tale',
      'dietaryFreeTextHint': 'ex: sunt alergic la ciuperci, nu mananc curcan sau porc...',
      'dietaryAiAnalyzeAndSave': 'Analizeaza cu AI si salveaza',
      'dietaryVegetarian': 'Vegetarian',
      'dietaryVegan': 'Vegan',
      'dietaryNoMeat': 'Fara carne',
      'dietaryNoFish': 'Fara peste / fructe de mare',
      'dietaryNoDairy': 'Fara lactate',
      'dietaryNoEggs': 'Fara oua',
      'dietaryNoGluten': 'Fara gluten',
      'dietaryNoNuts': 'Fara nuci',
      'dietaryNoPork': 'Fara porc',
      'dietarySavePreferences': 'Salveaza preferintele',
      'dietarySkipForNow': 'Sari peste deocamdata',
      'dietaryPreferencesSaved': 'Preferinte salvate — {count} ingrediente ascunse',
      'dietaryPreferencesSaveFailed': 'Nu s-au putut salva preferintele',
      'dietaryPreferences': 'Preferinte alimentare',
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
  String get searchIngredients => _text('searchIngredients');
  String get noIngredientsFound => _text('noIngredientsFound');
  String get helloChef => _text('helloChef');
  String get selectIngredientsTagline => _text('selectIngredientsTagline');
  String get recipes => _text('recipes');
  String get searchRecipes => _text('searchRecipes');
  String get addToFavorites => _text('addToFavorites');
  String get favoriteUpdateFailed => _text('favoriteUpdateFailed');
  String get connectionError => _text('connectionError');
  String get confirmDelete => _text('confirmDelete');
  String get confirmDeleteRecipe => _text('confirmDeleteRecipe');
  String get delete => _text('delete');
  String get recipeDeleted => _text('recipeDeleted');
  String get recipeDeleteFailed => _text('recipeDeleteFailed');
  String get scanIngredient => _text('scanIngredient');
  String get useCamera => _text('useCamera');
  String get selectFromGallery => _text('selectFromGallery');
  String get noRecipesFound => _text('noRecipesFound');
  String get failedToLoadIngredients => _text('failedToLoadIngredients');
  String get noIngredientIdentified => _text('noIngredientIdentified');
  String get close => _text('close');
  String get clearAll => _text('clearAll');
  String get welcomeBack => _text('welcomeBack');
  String get account => _text('account');
  String get preferences => _text('preferences');
  String get email => _text('email');
  String get signInSubtitle => _text('signInSubtitle');
  String get createAccountSubtitle => _text('createAccountSubtitle');
  String get forgotPasswordTitle => _text('forgotPasswordTitle');
  String get forgotPasswordSubtitle => _text('forgotPasswordSubtitle');
  String get sendCode => _text('sendCode');
  String get enterCodeTitle => _text('enterCodeTitle');
  String get enterCodeSubtitle => _text('enterCodeSubtitle');
  String get verifyCode => _text('verifyCode');
  String get pleaseEnter4DigitCode => _text('pleaseEnter4DigitCode');
  String get wrongCode => _text('wrongCode');
  String get changePasswordTitle => _text('changePasswordTitle');
  String get changePasswordSubtitle => _text('changePasswordSubtitle');
  String get newPassword => _text('newPassword');
  String get confirmPassword => _text('confirmPassword');
  String get enterNewPassword => _text('enterNewPassword');
  String get confirmYourPassword => _text('confirmYourPassword');
  String get passwordsDontMatch => _text('passwordsDontMatch');
  String get iAlreadyHaveAccount => _text('iAlreadyHaveAccount');
  String get termsOfUseNote => _text('termsOfUseNote');
  String get continueWithGoogle => _text('continueWithGoogle');
  String get signUp => _text('signUp');
  String get or => _text('or');
  String get welcomeHeroTitle => _text('welcomeHeroTitle');
  String get welcomeHeroSubtitle => _text('welcomeHeroSubtitle');
  String get dietaryPreferencesTitle => _text('dietaryPreferencesTitle');
  String get dietaryPreferencesSubtitle => _text('dietaryPreferencesSubtitle');
  String get dietaryAiHint => _text('dietaryAiHint');
  String get dietaryFreeTextLabel => _text('dietaryFreeTextLabel');
  String get dietaryFreeTextHint => _text('dietaryFreeTextHint');
  String get dietaryAiAnalyzeAndSave => _text('dietaryAiAnalyzeAndSave');
  String get dietaryVegetarian => _text('dietaryVegetarian');
  String get dietaryVegan => _text('dietaryVegan');
  String get dietaryNoMeat => _text('dietaryNoMeat');
  String get dietaryNoFish => _text('dietaryNoFish');
  String get dietaryNoDairy => _text('dietaryNoDairy');
  String get dietaryNoEggs => _text('dietaryNoEggs');
  String get dietaryNoGluten => _text('dietaryNoGluten');
  String get dietaryNoNuts => _text('dietaryNoNuts');
  String get dietaryNoPork => _text('dietaryNoPork');
  String get dietarySavePreferences => _text('dietarySavePreferences');
  String get dietarySkipForNow => _text('dietarySkipForNow');
  String get dietaryPreferencesSaveFailed => _text('dietaryPreferencesSaveFailed');
  String get dietaryPreferences => _text('dietaryPreferences');

  String dietaryPreferencesSaved(int count) {
    return _text('dietaryPreferencesSaved').replaceAll('{count}', count.toString());
  }

  String helloUser(String username) {
    return _text('helloUser').replaceAll('{username}', username);
  }

  String ingredientAdded(String name) {
    return _text('ingredientAdded').replaceAll('{name}', name);
  }

  String selectedCount(int count) {
    return _text('selectedCount').replaceAll('{count}', count.toString());
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
