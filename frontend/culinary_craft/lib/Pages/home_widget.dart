import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Components/Ingredient.dart';
import '../Components/ingredient_widget.dart';
import '../Components/appbar_widget.dart';
import '../Services/ingredient_service.dart';
import '../Services/recipe_service.dart';
import '../l10n/app_localizations.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _initialLoad = _fetchIngredients();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoading) {
        _fetchIngredients();
      }
    });
  }

  Future<void> _fetchIngredients() async {
    setState(() {
      isLoading = true;
    });

    try {
      final newIngredients = await IngredientService.getIngredients(currentPage);
      setState(() {
        ingredients.addAll(newIngredients);
        currentPage++;
      });
    } catch (e) {
      print('Failed to load ingredients: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _scanIngredient(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        print('Image selected: ${pickedFile.path}');

        File imageFile = File(pickedFile.path);
        final Ingredient? identifiedIngredient = await IngredientService.sendIngredientImage(imageFile);

        if (identifiedIngredient != null) {
          setState(() {
            if (!selectedIngredients.contains(identifiedIngredient)) {
              identifiedIngredient.selected = true;
              selectedIngredients.add(identifiedIngredient);
              if(!ingredients.contains(identifiedIngredient)){
                ingredients.add(identifiedIngredient);
              }
            }
            // Move selected ingredients to the top
            ingredients.sort((a, b) => b.selected ? 1 : -1);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ingredient added: ${identifiedIngredient.name}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No ingredient identified from the image')),
          );
        }
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking or uploading image: $e');
    }
  }

  void _showImageSourceSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Use Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _scanIngredient(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Select from Gallery'),
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
    setState(() {
      _searchQuery = value;
    });
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
    setState(() {
      _isSearching = true;
    });
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
      print('Search failed: $e');
      if (!mounted) return;
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: CustomAppbarWidget(
        homeRoute: '/home',
        profileRoute: '/profile',
      ),
      body: FutureBuilder(
        future: _initialLoad,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load ingredients'));
          } else {
            return _buildIngredientList();
          }
        },
      ),
    );
  }

  Widget _buildIngredientList() {
    ingredients.sort((a, b) => b.selected ? 1 : -1);
    final bool hasQuery = _searchQuery.trim().isNotEmpty;
    final List<Ingredient> visibleIngredients =
        hasQuery ? _searchResults : ingredients;
    final bool listLoading = hasQuery ? _isSearching : isLoading;
    final l10n = context.l10n;

    return SafeArea(
      top: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'Craft recipes',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'Select your ingredients:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
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
                        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: (visibleIngredients.isEmpty && !listLoading && hasQuery)
                  ? Center(
                      child: Text(
                        l10n.noIngredientsFound,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    )
                  : ListView.builder(
                      controller: hasQuery ? null : _scrollController,
                      itemCount: visibleIngredients.length + (listLoading ? 1 : 0),
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
                        return Column(
                          children: [
                            IngredientWidget(
                              id: ingredient.id,
                              name: ingredient.name,
                              imageURL: ingredient.imageURL,
                              selected: ingredient.selected,
                              onTap: () {
                                toggleIngredientSelection(ingredient);
                              },
                            ),
                            const SizedBox(height: 5),
                          ],
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: selectedIngredients.isNotEmpty
                          ? () async {
                              Navigator.of(context).pushNamed('/create_recipes', arguments: selectedIngredients);
                            }
                          : null,
                      icon: const Icon(Icons.auto_awesome_rounded),
                      label: const Text('Create Recipe'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: selectedIngredients.isNotEmpty
                          ? () async {
                              final recipes = await RecipeService.searchRecipes(
                                selectedIngredients.map((ing) => ing.id).toList(),
                                0,
                              );
                              if (recipes.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No recipes found.'),
                                  ),
                                );
                              } else {
                                Navigator.of(context).pushNamed('/view_recipes', arguments: selectedIngredients);
                              }
                            }
                          : null,
                      icon: const Icon(Icons.search_rounded),
                      label: const Text('Search Recipes'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: _showImageSourceSelection,
                      icon: const Icon(Icons.document_scanner_rounded),
                      label: const Text('Scan ingredient'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toggleIngredientSelection(Ingredient ingredient) {
    setState(() {
      final bool wasSelected =
          selectedIngredients.any((Ingredient i) => i.id == ingredient.id);
      if (wasSelected) {
        selectedIngredients.removeWhere((Ingredient i) => i.id == ingredient.id);
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
}
