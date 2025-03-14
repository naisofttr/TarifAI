import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarifai/core/utils/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final apiServiceProvider = Provider((ref) => ApiService());

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late TextEditingController _ingredientController;
  final FocusNode _focusNode = FocusNode();
  final List<String> _ingredients = [];
  String? _recipe;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _ingredientController = TextEditingController();
    // Sayfa yüklendiğinde TextField'a focus ver
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addIngredient() {
    final text = _ingredientController.text.trim();
    if (text.isNotEmpty) {
      // Malzemenin listede olup olmadığını kontrol et
      if (_ingredients.contains(text)) {
        // Malzeme zaten listede varsa
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.ingredientAlreadyExists),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        _ingredientController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _focusNode.requestFocus();
        });
        return;
      }

      setState(() {
        _ingredients.add(text);
        _ingredientController.clear();
      });
      
      // setState'ten sonra focus'u tetikle
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  void _clearAllIngredients() {
    setState(() {
      _ingredients.clear();
      _recipe = null;
    });
    // setState'in tamamlanmasını bekleyip focus'u tetikle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<void> _getRecipes() async {
    final l10n = AppLocalizations.of(context)!;
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseAddIngredient),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _recipe = null;
    });

    try {
      final response = await ref.read(apiServiceProvider).getRecipes(
            _ingredients.join(', '),
            Localizations.localeOf(context).languageCode,
          );
      setState(() {
        _recipe = response['response'] as String;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.error(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.restaurant_menu,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.appTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            if (_ingredients.isEmpty && _recipe == null) ...[
              Text(
                l10n.welcomeTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.welcomeDescription,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            // Ingredient input section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _ingredientController,
                              focusNode: _focusNode,
                              decoration: InputDecoration(
                                hintText: l10n.ingredientHint,
                                labelText: l10n.ingredientLabel,
                                helperText: l10n.ingredientInputHelper,
                                border: const OutlineInputBorder(),
                              ),
                              onSubmitted: (_) => _addIngredient(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 22), // Helper text'in yüksekliğini dengelemek için
                            child: Tooltip(
                              message: l10n.addIngredientButtonTooltip,
                              child: IconButton(
                                onPressed: _addIngredient,
                                icon: const Icon(Icons.add),
                                style: IconButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Ingredients list section
            if (_ingredients.isEmpty && _recipe == null) ...[
              Center(
                child: Text(
                  l10n.noIngredientsMessage,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            ],
            
            if (_ingredients.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.addedIngredients,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: _clearAllIngredients,
                    icon: const Icon(Icons.delete_sweep),
                    tooltip: l10n.clearAllIngredients,
                    color: theme.colorScheme.error,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _ingredients
                        .asMap()
                        .entries
                        .map(
                          (entry) => Chip(
                            label: Text(
                              entry.value,
                              style: TextStyle(
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                            onDeleted: () => _removeIngredient(entry.key),
                            backgroundColor: theme.colorScheme.secondaryContainer,
                            side: BorderSide.none,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _getRecipes,
                  icon: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.onPrimary,
                          ),
                        )
                      : const Icon(Icons.search),
                  label: Text(l10n.listRecipes),
                ),
              ),
            ],

            // Recipe results section
            if (_recipe != null) ...[
              const SizedBox(height: 24),
              Text(
                l10n.suggestedRecipes,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Text(
                        _recipe!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 