import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Components/auth_scaffold.dart';
import '../Services/auth_service.dart';
import '../Services/dietary_preference_service.dart';
import '../l10n/app_localizations.dart';

class DietaryPreferencesWidget extends StatefulWidget {
  const DietaryPreferencesWidget({super.key, this.isEditMode = false});

  final bool isEditMode;

  @override
  State<DietaryPreferencesWidget> createState() =>
      _DietaryPreferencesWidgetState();
}

class _DietaryPreferencesWidgetState extends State<DietaryPreferencesWidget> {
  final Set<String> _selected = <String>{};
  final TextEditingController _freeTextController = TextEditingController();
  bool _loading = true;
  bool _saving = false;

  @override
  void dispose() {
    _freeTextController.dispose();
    super.dispose();
  }

  static const List<_RestrictionOption> _options = <_RestrictionOption>[
    _RestrictionOption('vegetarian', Icons.eco_rounded),
    _RestrictionOption('vegan', Icons.spa_rounded),
    _RestrictionOption('no_meat', Icons.set_meal_rounded),
    _RestrictionOption('no_fish_seafood', Icons.set_meal_outlined),
    _RestrictionOption('no_dairy', Icons.icecream_rounded),
    _RestrictionOption('no_eggs', Icons.egg_alt_rounded),
    _RestrictionOption('no_gluten', Icons.bakery_dining_rounded),
    _RestrictionOption('no_nuts', Icons.ac_unit_rounded),
    _RestrictionOption('no_pork', Icons.block_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final int? userId = await AuthService.getId();
    if (userId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final DietaryPreferencesData data =
          await DietaryPreferenceService.getPreferences(userId);
      setState(() {
        _selected.addAll(data.restrictions);
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    final int? userId = await AuthService.getId();
    if (userId == null) return;

    setState(() => _saving = true);
    HapticFeedback.lightImpact();

    try {
      final DietaryPreferencesData result =
          await DietaryPreferenceService.savePreferences(
        userId,
        _selected.toList(),
        freeText: _freeTextController.text.trim(),
      );

      if (!mounted) return;

      final String message = result.aiPowered &&
              result.aiSummary != null &&
              result.aiSummary!.isNotEmpty
          ? result.aiSummary!
          : context.l10n.dietaryPreferencesSaved(result.excludedCount);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      if (widget.isEditMode) {
        Navigator.of(context).pop(true);
      } else {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.dietaryPreferencesSaveFailed)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _skip() async {
    if (widget.isEditMode) {
      Navigator.of(context).pop();
      return;
    }
    final int? userId = await AuthService.getId();
    if (userId != null) {
      try {
        await DietaryPreferenceService.savePreferences(userId, <String>[]);
      } catch (_) {}
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  String _labelFor(String key, AppLocalizations l10n) {
    switch (key) {
      case 'vegetarian':
        return l10n.dietaryVegetarian;
      case 'vegan':
        return l10n.dietaryVegan;
      case 'no_meat':
        return l10n.dietaryNoMeat;
      case 'no_fish_seafood':
        return l10n.dietaryNoFish;
      case 'no_dairy':
        return l10n.dietaryNoDairy;
      case 'no_eggs':
        return l10n.dietaryNoEggs;
      case 'no_gluten':
        return l10n.dietaryNoGluten;
      case 'no_nuts':
        return l10n.dietaryNoNuts;
      case 'no_pork':
        return l10n.dietaryNoPork;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AuthScaffold(
      showBackButton: widget.isEditMode,
      title: l10n.dietaryPreferencesTitle,
      subtitle: l10n.dietaryPreferencesSubtitle,
      heroIcon: Icons.psychology_rounded,
      child: _loading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: colorScheme.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.dietaryAiHint,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurface,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _options.map((_RestrictionOption option) {
                    final bool selected = _selected.contains(option.key);
                    return FilterChip(
                      label: Text(_labelFor(option.key, l10n)),
                      avatar: Icon(
                        option.icon,
                        size: 18,
                        color: selected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                      ),
                      selected: selected,
                      onSelected: (bool value) {
                        setState(() {
                          if (value) {
                            _selected.add(option.key);
                          } else {
                            _selected.remove(option.key);
                          }
                        });
                      },
                      selectedColor: colorScheme.primaryContainer,
                      checkmarkColor: colorScheme.primary,
                      labelStyle: TextStyle(
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.dietaryFreeTextLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _freeTextController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: l10n.dietaryFreeTextHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 22),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.dietaryAiAnalyzeAndSave),
                ),
                if (!widget.isEditMode) ...<Widget>[
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _saving ? null : () => _skip(),
                    child: Text(l10n.dietarySkipForNow),
                  ),
                ],
              ],
            ),
    );
  }
}

class _RestrictionOption {
  const _RestrictionOption(this.key, this.icon);
  final String key;
  final IconData icon;
}
