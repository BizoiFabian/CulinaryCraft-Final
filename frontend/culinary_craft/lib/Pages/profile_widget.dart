import 'package:culinary_craft_wireframe/Services/auth_service.dart';
import 'package:culinary_craft_wireframe/l10n/app_localizations.dart';
import 'package:culinary_craft_wireframe/state/app_settings.dart';
import 'package:culinary_craft_wireframe/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Components/appbar_widget.dart';
import '../Models/profile_model.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;
  String? _username;

  @override
  void initState() {
    super.initState();
    _model = ProfileModel();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final String? name = await AuthService.getUsername();
    if (!mounted) return;
    setState(() => _username = name);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final AppSettings settings = context.watch<AppSettings>();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      bottomNavigationBar: const CustomAppbarWidget(
        homeRoute: '/home',
        profileRoute: '/profile',
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildHeroHeader(context, l10n, isDark),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _sectionLabel(l10n.preferences, colorScheme),
                    const SizedBox(height: 10),
                    _buildPreferencesCard(context, l10n, settings),
                    const SizedBox(height: 24),
                    _sectionLabel(l10n.account, colorScheme),
                    const SizedBox(height: 10),
                    _buildAccountCard(context, l10n),
                    const SizedBox(height: 28),
                    _buildLogoutButton(context, l10n),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader(
      BuildContext context, AppLocalizations l10n, bool isDark) {
    final String displayName = _username ?? l10n.guest;
    final Color startColor =
        isDark ? AppColors.accentDeep : AppColors.primary;
    final Color endColor =
        isDark ? AppColors.primary : AppColors.tertiary;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[startColor, endColor],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: startColor.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.restaurant_menu_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.welcomeBack,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.helloUser(displayName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, ColorScheme colorScheme) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildPreferencesCard(
    BuildContext context,
    AppLocalizations l10n,
    AppSettings settings,
  ) {
    return _glassCard(
      context,
      child: Column(
        children: <Widget>[
          _preferenceRow(
            context,
            icon: Icons.palette_outlined,
            label: l10n.theme,
            child: DropdownButton<ThemeMode>(
              value: settings.themeMode,
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(12),
              icon: const Icon(Icons.expand_more_rounded),
              onChanged: (ThemeMode? mode) {
                if (mode != null) settings.setThemeMode(mode);
              },
              items: <DropdownMenuItem<ThemeMode>>[
                DropdownMenuItem<ThemeMode>(
                  value: ThemeMode.system,
                  child: Text(l10n.systemTheme),
                ),
                DropdownMenuItem<ThemeMode>(
                  value: ThemeMode.light,
                  child: Text(l10n.lightTheme),
                ),
                DropdownMenuItem<ThemeMode>(
                  value: ThemeMode.dark,
                  child: Text(l10n.darkTheme),
                ),
              ],
            ),
          ),
          _divider(context),
          _preferenceRow(
            context,
            icon: Icons.language_rounded,
            label: l10n.language,
            child: DropdownButton<Locale>(
              value: settings.locale,
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(12),
              icon: const Icon(Icons.expand_more_rounded),
              onChanged: (Locale? locale) {
                if (locale != null) settings.setLocale(locale);
              },
              items: <DropdownMenuItem<Locale>>[
                DropdownMenuItem<Locale>(
                  value: const Locale('en'),
                  child: Text(l10n.english),
                ),
                DropdownMenuItem<Locale>(
                  value: const Locale('ro'),
                  child: Text(l10n.romanian),
                ),
              ],
            ),
          ),
          _divider(context),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed('/dietary_preferences_edit')
                  .then((_) => setState(() {}));
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.psychology_rounded,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      l10n.dietaryPreferences,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _preferenceRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, AppLocalizations l10n) {
    return _glassCard(
      context,
      child: Column(
        children: <Widget>[
          _accountTile(
            context,
            icon: Icons.person_outline_rounded,
            label: l10n.editProfile,
            onTap: () => Navigator.of(context).pushNamed('/edit_profile'),
          ),
          _divider(context),
          _accountTile(
            context,
            icon: Icons.restaurant_rounded,
            label: l10n.myRecipes,
            onTap: () =>
                Navigator.of(context).pushNamed('/view_my_recipes'),
          ),
          _divider(context),
          _accountTile(
            context,
            icon: Icons.favorite_border_rounded,
            label: l10n.savedRecipes,
            onTap: () =>
                Navigator.of(context).pushNamed('/view_favorite_recipes'),
          ),
          _divider(context),
          _accountTile(
            context,
            icon: Icons.info_outline_rounded,
            label: l10n.aboutUs,
            onTap: () => Navigator.of(context).pushNamed('/about_us'),
          ),
        ],
      ),
    );
  }

  Widget _accountTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: colorScheme.onSecondaryContainer,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppLocalizations l10n) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonalIcon(
        onPressed: () {
          AuthService.logout();
          Navigator.of(context)
              .pushNamed('/signin_with_google_or_facebook');
        },
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.errorContainer.withValues(alpha: 0.7),
          foregroundColor: colorScheme.onErrorContainer,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.logout_rounded),
        label: Text(
          l10n.logout,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _glassCard(BuildContext context, {required Widget child}) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: child,
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
      ),
    );
  }
}
