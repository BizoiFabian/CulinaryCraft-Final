import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../Components/Ingredient.dart';
import '../Components/Recipe.dart';
import '../Components/recipe_widget.dart';
import '../Services/recipe_service.dart';
import '../Components/recipes_page_header.dart';
import '../l10n/app_localizations.dart';
import 'view_recipes_widget.dart' show RecipeDetailsScreen, RecipeDetailsMode;

class ViewMyRecipesWidget extends StatefulWidget {
  ViewMyRecipesWidget();

  @override
  _ViewMyRecipesWidgetState createState() => _ViewMyRecipesWidgetState();
}

class _ViewMyRecipesWidgetState extends State<ViewMyRecipesWidget> {
  List<Recipe> recipes = [];
  int currentPage = 0;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchRecipes();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoading) {
        _searchRecipes();
      }
    });
  }

  Future<void> _searchRecipes() async {
    setState(() {
      isLoading = true;
    });

    try {
      final List<Recipe> searchedRecipes = await RecipeService.getAllRecipesByUserPagination(currentPage);
      setState(() {
        recipes.addAll(searchedRecipes);
        currentPage++;
      });
    } catch (e) {
      print('Error searching recipes: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _onRecipeDeleted(Recipe deletedRecipe) async {
    setState(() {
      recipes.removeWhere((recipe) => recipe.id == deletedRecipe.id);
    });
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
            title: l10n.myRecipes,
            onBack: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: recipes.isEmpty && !isLoading
                ? Center(
                    child: Text(
                      l10n.noRecipesFound,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurfaceVariant,
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
                        onTap: () async {
                          final dynamic result = await Navigator.push(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) =>
                                  RecipeDetailsScreen(
                                recipe: recipe,
                                mode: RecipeDetailsMode.myRecipe,
                              ),
                            ),
                          );
                          if (result == true) {
                            await _onRecipeDeleted(recipe);
                          }
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
