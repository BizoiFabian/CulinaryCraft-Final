import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Components/Ingredient.dart';
import '../Components/Recipe.dart';
import '../Components/ingredient_widget.dart';
import '../Components/appbar_widget.dart';
import '../Services/auth_service.dart';
import '../Services/ingredient_service.dart';
import '../Services/recipe_service.dart';
import '../l10n/app_localizations.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<Ingredient> ingredients = [];
  List<Ingredient> selectedIngredients = [];
  int currentPage = 0;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  late Future<void> _initialLoad;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _searchDebounce;
  List<Ingredient> _searchResults = [];
  bool _isSearching = false;
  String? _username;

  @override
  void initState() {
    super.initState();
    _initialLoad = _fetchIngredients();
    _loadUsername();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading) {
        _fetchIngredients();
      }
    });
  }

  Future<void> _loadUsername() async {
    final String? username = await AuthService.getUsername();
    if (!mounted) return;
    setState(() => _username = username);
  }

  Future<void> _fetchIngredients() async {
    setState(() => isLoading = true);
    try {
      final newIngredients =
          await IngredientService.getIngredients(currentPage);
      if (!mounted) return;
      setState(() {
        ingredients.addAll(newIngredients);
        currentPage++;
      });
    } catch (e) {
      debugPrint('Failed to load ingredients: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _scanIngredient(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return;

      File imageFile = File(pickedFile.path);
      final Ingredient? identifiedIngredient =
          await IngredientService.sendIngredientImage(imageFile);

      if (!mounted) return;
      final l10n = context.l10n;
      if (identifiedIngredient != null) {
        setState(() {
          if (!selectedIngredients
              .any((i) => i.id == identifiedIngredient.id)) {
            identifiedIngredient.selected = true;
            selectedIngredients.add(identifiedIngredient);
            if (!ingredients.any((i) => i.id == identifiedIngredient.id)) {
              ingredients.add(identifiedIngredient);
            }
          }
          ingredients.sort((a, b) => b.selected ? 1 : -1);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.ingredientAdded(identifiedIngredient.name)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noIngredientIdentified)),
        );
      }
    } catch (e) {
      debugPrint('Error picking or uploading image: $e');
    }
  }

  void _showImageSourceSelection() {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: Text(l10n.useCamera),
                onTap: () {
                  Navigator.pop(context);
                  _scanIngredient(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: Text(l10n.selectFromGallery),
                onTap: () {
                  Navigator.pop(context);
                  _scanIngredient(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
    _searchDebounce?.cancel();
    if (value.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _runSearch(value.trim());
    });
  }

  Future<void> _runSearch(String query) async {
    if (query.isEmpty || query != _searchQuery.trim()) return;
    setState(() => _isSearching = true);
    try {
      final List<Ingredient> results =
          await IngredientService.searchIngredients(query, 0);
      if (!mounted || query != _searchQuery.trim()) return;
      final Set<int> selectedIds =
          selectedIngredients.map((Ingredient i) => i.id).toSet();
      for (final Ingredient r in results) {
        r.selected = selectedIds.contains(r.id);
      }
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      debugPrint('Search failed: $e');
      if (!mounted) return;
      setState(() => _isSearching = false);
    }
  }

  void _clearSelection() {
    setState(() {
      for (final Ingredient i in selectedIngredients) {
        i.selected = false;
      }
      for (final Ingredient i in ingredients) {
        i.selected = false;
      }
      for (final Ingredient i in _searchResults) {
        i.selected = false;
      }
      selectedIngredients.clear();
      ingredients.sort((a, b) => b.selected ? 1 : -1);
    });
  }

  void toggleIngredientSelection(Ingredient ingredient) {
    setState(() {
      final bool wasSelected =
          selectedIngredients.any((Ingredient i) => i.id == ingredient.id);
      if (wasSelected) {
        selectedIngredients
            .removeWhere((Ingredient i) => i.id == ingredient.id);
      } else {
        selectedIngredients.add(ingredient);
      }
      final bool newSelected = !wasSelected;
      ingredient.selected = newSelected;
      for (final Ingredient i in ingredients) {
        if (i.id == ingredient.id) i.selected = newSelected;
      }
      for (final Ingredient i in _searchResults) {
        if (i.id == ingredient.id) i.selected = newSelected;
      }
      ingredients.sort((a, b) => b.selected ? 1 : -1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: const CustomAppbarWidget(
        homeRoute: '/home',
        profileRoute: '/profile',
      ),
      body: FutureBuilder(
        future: _initialLoad,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(context.l10n.failedToLoadIngredients));
          } else {
            return _buildBody();
          }
        },
      ),
    );
  }

  Widget _buildBody() {
    ingredients.sort((a, b) => b.selected ? 1 : -1);
    final bool hasQuery = _searchQuery.trim().isNotEmpty;
    final List<Ingredient> visibleIngredients =
        hasQuery ? _searchResults : ingredients;
    final bool listLoading = hasQuery ? _isSearching : isLoading;
    final l10n = context.l10n;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _buildHeader(l10n, colorScheme, textTheme),
            const SizedBox(height: 18),
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: l10n.searchIngredients,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: hasQuery
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded),
                        tooltip: MaterialLocalizations.of(context)
                            .closeButtonTooltip,
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                isDense: true,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: selectedIngredients.isEmpty
                  ? const SizedBox(height: 12)
                  : Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              l10n.selectedCount(selectedIngredients.length),
                              style: TextStyle(
                                color: colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _clearSelection,
                            icon:
                                const Icon(Icons.clear_all_rounded, size: 18),
                            label: Text(l10n.clearAll),
                            style: TextButton.styleFrom(
                              foregroundColor: colorScheme.onSurfaceVariant,
                              minimumSize: const Size(0, 36),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: (visibleIngredients.isEmpty && !listLoading && hasQuery)
                  ? Center(
                      child: Text(
                        l10n.noIngredientsFound,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.separated(
                      controller: hasQuery ? null : _scrollController,
                      itemCount:
                          visibleIngredients.length + (listLoading ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == visibleIngredients.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final ingredient = visibleIngredients[index];
                        return IngredientWidget(
                          id: ingredient.id,
                          name: ingredient.name,
                          imageURL: ingredient.imageURL,
                          selected: ingredient.selected,
                          onTap: () => toggleIngredientSelection(ingredient),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            _buildActionCard(l10n, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      AppLocalizations l10n, ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.primaryContainer,
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.restaurant_menu_rounded,
            size: 28,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (_username != null && _username!.isNotEmpty)
                    ? l10n.helloUser(_username!)
                    : l10n.helloChef,
                style: textTheme.headlineSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                l10n.selectIngredientsTagline,
                style: textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(AppLocalizations l10n, ColorScheme colorScheme) {
    final bool hasSelection = selectedIngredients.isNotEmpty;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: hasSelection
                  ? () {
                      Navigator.of(context).pushNamed(
                        '/create_recipes',
                        arguments: selectedIngredients,
                      );
                    }
                  : null,
              icon: const Icon(Icons.auto_awesome_rounded),
              label: Text(l10n.createRecipe),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: hasSelection
                  ? () async {
                      final List<int> ids = selectedIngredients
                          .map((Ingredient ing) => ing.id)
                          .toList();
                      try {
                        final List<Recipe> recipes =
                            await RecipeService.searchRecipes(ids, 0);
                        if (!mounted) return;
                        if (recipes.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.noRecipesFound)),
                          );
                        } else {
                          Navigator.of(context).pushNamed(
                            '/view_recipes',
                            arguments: selectedIngredients,
                          );
                        }
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.noRecipesFound)),
                        );
                      }
                    }
                  : null,
              icon: const Icon(Icons.search_rounded),
              label: Text(l10n.searchRecipes),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondaryContainer,
                foregroundColor: colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _showImageSourceSelection,
              icon: const Icon(Icons.document_scanner_rounded),
              label: Text(l10n.scanIngredient),
            ),
          ],
        ),
      ),
    );
  }
}
