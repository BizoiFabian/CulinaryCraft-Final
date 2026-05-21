import 'package:culinary_craft_wireframe/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Components/auth_scaffold.dart';
import '../l10n/app_localizations.dart';

class SignInWithGoogleOrFacebookWidget extends StatefulWidget {
  const SignInWithGoogleOrFacebookWidget({super.key});

  @override
  State<SignInWithGoogleOrFacebookWidget> createState() =>
      _SignInWithGoogleOrFacebookWidgetState();
}

class _SignInWithGoogleOrFacebookWidgetState
    extends State<SignInWithGoogleOrFacebookWidget> {

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AuthScaffold(
      title: l10n.welcomeHeroTitle,
      subtitle: l10n.welcomeHeroSubtitle,
      heroIcon: Icons.restaurant_menu_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElevatedButton.icon(
            onPressed: _handleGoogleSignIn,
            icon: const FaIcon(
              FontAwesomeIcons.google,
              size: 18,
              color: Colors.white,
            ),
            label: Text(l10n.continueWithGoogle),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDB4437),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: <Widget>[
              Expanded(child: Divider(color: colorScheme.outlineVariant)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  l10n.or,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(child: Divider(color: colorScheme.outlineVariant)),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pushNamed('/signin');
                  },
                  icon: const Icon(Icons.login_rounded),
                  label: Text(l10n.signIn),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: colorScheme.primary),
                    foregroundColor: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () => Navigator.of(context).pushNamed('/signup'),
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                  label: Text(l10n.signUp),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      await GoogleSignIn.instance.initialize();
      final GoogleSignInAccount account =
          await GoogleSignIn.instance.authenticate();
      final String username =
          (account.displayName != null && account.displayName!.trim().isNotEmpty)
              ? account.displayName!.trim()
              : account.email.split('@').first;

      final String? errorMessage =
          await AuthService.signInWithGoogle(context, username, account.email);
      if (errorMessage != null) {
        _showError(errorMessage);
      }
    } on GoogleSignInException catch (e) {
      _showError(e.description ?? 'Google Sign-In failed.');
    } catch (_) {
      _showError('Google Sign-In failed. Please try again.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
