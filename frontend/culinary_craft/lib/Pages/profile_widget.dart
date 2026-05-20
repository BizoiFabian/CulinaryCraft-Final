import 'package:culinary_craft_wireframe/Services/auth_service.dart';
import 'package:culinary_craft_wireframe/l10n/app_localizations.dart';
import 'package:culinary_craft_wireframe/state/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Components/appbar_widget.dart';
import '../Models/profile_model.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;

  @override
  void initState() {
    super.initState();
    _model = ProfileModel();
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      bottomNavigationBar: const CustomAppbarWidget(
        homeRoute: '/home',
        profileRoute: '/profile',
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String?>(
                      future: AuthService.getUsername(),
                      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text(
                            l10n.loading,
                            style: Theme.of(context).textTheme.displayLarge!,
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                            style: Theme.of(context).textTheme.displayLarge!,
                          );
                        } else {
                          final username = snapshot.data ?? l10n.guest;
                          return Text(
                            l10n.helloUser(username),
                            style: Theme.of(context).textTheme.displayLarge!,
                          );
                        }
                      },
                    ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.appearance,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(l10n.theme)),
                              DropdownButton<ThemeMode>(
                                value: settings.themeMode,
                                underline: const SizedBox(),
                                onChanged: (ThemeMode? mode) {
                                  if (mode != null) {
                                    settings.setThemeMode(mode);
                                  }
                                },
                                items: [
                                  DropdownMenuItem(
                                    value: ThemeMode.system,
                                    child: Text(l10n.systemTheme),
                                  ),
                                  DropdownMenuItem(
                                    value: ThemeMode.light,
                                    child: Text(l10n.lightTheme),
                                  ),
                                  DropdownMenuItem(
                                    value: ThemeMode.dark,
                                    child: Text(l10n.darkTheme),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text(l10n.language)),
                              DropdownButton<Locale>(
                                value: settings.locale,
                                underline: const SizedBox(),
                                onChanged: (Locale? locale) {
                                  if (locale != null) {
                                    settings.setLocale(locale);
                                  }
                                },
                                items: [
                                  DropdownMenuItem(
                                    value: const Locale('en'),
                                    child: Text(l10n.english),
                                  ),
                                  DropdownMenuItem(
                                    value: const Locale('ro'),
                                    child: Text(l10n.romanian),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Theme.of(context).colorScheme.outlineVariant),
                  const SizedBox(height: 8),
                  _buildProfileButton(
                    icon: Icons.person_outline_rounded,
                    text: l10n.editProfile,
                    onTap: () {
                      Navigator.of(context).pushNamed('/edit_profile');
                    },
                  ),
                  _buildProfileButton(
                    icon: Icons.restaurant_rounded,
                    text: l10n.myRecipes,
                    onTap: () {
                      Navigator.of(context).pushNamed('/view_my_recipes');
                    },
                  ),
                  _buildProfileButton(
                    icon: Icons.favorite_border_sharp,
                    text: l10n.savedRecipes,
                    onTap: () {
                      Navigator.of(context).pushNamed('/view_favorite_recipes');
                    },
                  ),
                  _buildProfileButton(
                    icon: Icons.info_outlined,
                    text: l10n.aboutUs,
                    onTap: () {
                      Navigator.of(context).pushNamed('/about_us');
                    },
                  ),
                  _buildProfileButton(
                    icon: Icons.logout,
                    text: l10n.logout,
                    onTap: () {
                      AuthService.logout();
                      Navigator.of(context).pushNamed('/signin_with_google_or_facebook');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildProfileButton(
      {required IconData icon,
        required String text,
        required VoidCallback onTap}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge!,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
