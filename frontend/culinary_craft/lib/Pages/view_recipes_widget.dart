import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../Components/Ingredient.dart';
import '../Components/Recipe.dart';
import '../Components/recipe_widget.dart';
import '../Services/recipe_service.dart';
import '../Services/auth_service.dart';
import '../l10n/app_localizations.dart';
import '../Components/recipes_page_header.dart';
import '../Components/recipe_image_view.dart';
import '../theme/app_colors.dart';

class ViewRecipesWidget extends StatefulWidget {
  const ViewRecipesWidget({
    super.key,
    required this.selectedIngredients,
    this.imageData,
  });

  final List<Ingredient> selectedIngredients;
  final Uint8List? imageData;

  @override
  State<ViewRecipesWidget> createState() => _ViewRecipesWidgetState();
}

class _ViewRecipesWidgetState extends State<ViewRecipesWidget> {
  List<Recipe> recipes = [];
  int currentPage = 0;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchRecipes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading) {
        _searchRecipes();
      }
    });
  }

  Future<void> _searchRecipes() async {
    setState(() => isLoading = true);
    try {
      final List<int> ingredientsIds =
          widget.selectedIngredients.map((Ingredient i) => i.id).toList();
      final List<Recipe> searchedRecipes =
          await RecipeService.searchRecipes(ingredientsIds, currentPage);
      if (!mounted) return;
      setState(() {
        recipes.addAll(searchedRecipes);
        currentPage++;
      });
    } catch (e) {
      debugPrint('Error searching recipes: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: <Widget>[
          RecipesPageHeader(
            title: l10n.recipes,
            subtitle: recipes.isNotEmpty ? '${recipes.length}' : null,
            onBack: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: recipes.isEmpty && !isLoading
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.menu_book_outlined,
                            size: 56,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noRecipesFound,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    itemCount: recipes.length + (isLoading ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == recipes.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final Recipe recipe = recipes[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  RecipeDetailsScreen(recipe: recipe),
                            ),
                          );
                        },
                        child: RecipeCard(recipe: recipe),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

enum RecipeDetailsMode { search, myRecipe, favorite }

class RecipeDetailsScreen extends StatefulWidget {
  const RecipeDetailsScreen({
    super.key,
    required this.recipe,
    this.mode = RecipeDetailsMode.search,
  });

  final Recipe recipe;
  final RecipeDetailsMode mode;

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final int? userId = await AuthService.getId();
    if (userId != null && mounted) {
      setState(() {
        isFavorite = widget.recipe.likes.any((like) => like.id == userId);
      });
    }
  }

  Future<void> _deleteRecipe() async {
    try {
      final bool success = await RecipeService.deleteRecipe(widget.recipe.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.recipeDeleted)),
        );
        Navigator.of(context).pop(true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.recipeDeleteFailed)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.connectionError)),
        );
      }
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    final AppLocalizations l10n = context.l10n;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.confirmDeleteRecipe),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.close),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) await _deleteRecipe();
  }

  Future<void> _toggleFavorite() async {
    try {
      final bool success = isFavorite
          ? await RecipeService.removeRecipeFromFavourites(widget.recipe.id)
          : await RecipeService.addRecipeToFavourites(widget.recipe.id);

      if (success && mounted) {
        setState(() => isFavorite = !isFavorite);
        if (widget.mode == RecipeDetailsMode.favorite && !isFavorite) {
          Navigator.of(context).pop(true);
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.favoriteUpdateFailed)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.connectionError)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: isDark ? AppColors.accentDeep : AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.recipe.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: _buildHeroImage(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.description,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.recipe.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                          height: 1.45,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.ingredients,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.recipe.ingredients
                        .map(
                          (ingredient) => Chip(
                            label: Text(ingredient.name),
                            backgroundColor: colorScheme.primaryContainer,
                            labelStyle: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                            side: BorderSide.none,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.mode == RecipeDetailsMode.myRecipe
          ? FloatingActionButton.extended(
              onPressed: _showDeleteConfirmationDialog,
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              icon: const Icon(Icons.delete_outline_rounded),
              label: Text(l10n.delete),
            )
          : FloatingActionButton.extended(
              onPressed: _toggleFavorite,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              icon: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
              ),
              label: Text(
                isFavorite ? l10n.savedRecipes : l10n.addToFavorites,
              ),
            ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return RecipeImageView(
      imageUrl: widget.recipe.imageURL,
      imageData: widget.recipe.imageData,
      aspectRatio: 1.2,
      fit: BoxFit.cover,
    );
  }
}
