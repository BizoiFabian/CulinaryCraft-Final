import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AuthScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData heroIcon;
  final Widget child;
  final bool showBackButton;

  const AuthScaffold({
    super.key,
    required this.title,
    this.subtitle,
    this.heroIcon = Icons.restaurant_menu_rounded,
    required this.child,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color startColor =
        isDark ? AppColors.accentDeep : AppColors.primary;
    final Color endColor =
        isDark ? AppColors.primary : AppColors.tertiary;
    final double mediaWidth = MediaQuery.of(context).size.width;
    final double horizontalPad = mediaWidth > 480 ? 36 : 22;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _HeroHeader(
                title: title,
                subtitle: subtitle,
                heroIcon: heroIcon,
                startColor: startColor,
                endColor: endColor,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: horizontalPad,
                    right: horizontalPad,
                    top: 24,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 28,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
          if (showBackButton)
            Positioned(
              top: MediaQuery.of(context).padding.top + 6,
              left: 8,
              child: Material(
                color: Colors.white.withValues(alpha: 0.25),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData heroIcon;
  final Color startColor;
  final Color endColor;

  const _HeroHeader({
    required this.title,
    required this.subtitle,
    required this.heroIcon,
    required this.startColor,
    required this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            color: startColor.withValues(alpha: 0.32),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        MediaQuery.of(context).padding.top + 28,
        24,
        32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            child: Icon(
              heroIcon,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.15,
            ),
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
