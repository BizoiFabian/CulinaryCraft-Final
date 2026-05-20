import 'package:culinary_craft_wireframe/Pages/change_password_widget.dart';
import 'package:culinary_craft_wireframe/Pages/create_account_widget.dart';
import 'package:culinary_craft_wireframe/Pages/create_recipe_widget.dart';
import 'package:culinary_craft_wireframe/Pages/forgot_password_widget.dart';
import 'package:culinary_craft_wireframe/Pages/onboarding_slideshow_widget.dart';
import 'package:culinary_craft_wireframe/Pages/reset_password_with_code_widget.dart';
import 'package:culinary_craft_wireframe/Pages/view_favorite_recipes.dart';
import 'package:culinary_craft_wireframe/Pages/view_my_recipes.dart';
import 'package:culinary_craft_wireframe/Pages/view_recipes_widget.dart';
import 'package:culinary_craft_wireframe/Components/Ingredient.dart';
import 'package:culinary_craft_wireframe/firebase_options.dart';
import 'package:culinary_craft_wireframe/l10n/app_localizations.dart';
import 'package:culinary_craft_wireframe/state/app_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:culinary_craft_wireframe/theme/app_theme.dart';
import 'Pages/about_us_widget.dart';
import 'Pages/edit_profile_widget.dart';
import 'Pages/get_started_widget.dart';
import 'Pages/home_widget.dart';
import 'Pages/profile_widget.dart';
import 'Pages/sign_in_widget.dart';
import 'Pages/sign_in_with_google_or_facebook_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebaseSafely();
  final AppSettings settings = AppSettings();
  await settings.load();
  runApp(
    ChangeNotifierProvider<AppSettings>.value(
      value: settings,
      child: const CulinaryCraftApp(),
    ),
  );
}

class CulinaryCraftApp extends StatelessWidget {
  const CulinaryCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (BuildContext context, AppSettings settings, Widget? child) {
        return MaterialApp(
          title: 'Culinary Craft',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          locale: settings.locale,
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: GetStartedWidget(),
          routes: {
            '/start': (context) => GetStartedWidget(),
            '/onboarding': (context) => OnboardingSlideshowWidget(),
            '/signin_with_google_or_facebook': (context) => SignInWithGoogleOrFacebookWidget(),
            '/signin': (context) => SignInWidget(),
            '/signup': (context) => CreateAccountWidget(),
            '/profile': (context) => ProfileWidget(),
            '/home': (context) => HomeWidget(),
            '/edit_profile': (context) => EditProfileWidget(),
            '/forgot_password': (context) => ForgotPasswordWidget(),
            '/reset_password_with_code': (context) => ResetPasswordWithCodeWidget(),
            '/change_password': (context) => ChangePasswordWidget(),
            '/view_recipes': (context) => ViewRecipesWidget(
              selectedIngredients: ModalRoute.of(context)!.settings.arguments as List<Ingredient>,
            ),
            '/create_recipes': (context) => CreateRecipeWidget(
              ingredients: ModalRoute.of(context)!.settings.arguments as List<Ingredient>,
            ),
            '/view_favorite_recipes': (context) => ViewFavoriteRecipesWidget(),
            '/view_my_recipes': (context) => ViewMyRecipesWidget(),
            '/about_us': (context) => AboutUsWidget(),
          },
        );
      },
    );
  }
}

Future<void> _initializeFirebaseSafely() async {
  try {
    if (Firebase.apps.isNotEmpty) return;

    if (kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      return;
    }

    await Firebase.initializeApp();
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  }
}

