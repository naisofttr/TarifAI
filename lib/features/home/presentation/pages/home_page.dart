import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarifai/core/utils/api_service.dart';

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
      setState(() {
        _ingredients.add(text);
        _ingredientController.clear();
      });
      _focusNode.requestFocus();
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
    _focusNode.requestFocus();
  }

  Future<void> _getRecipes() async {
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen en az bir malzeme ekleyin'),
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
            'tr',
          );
      setState(() {
        _recipe = response['response'] as String;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata oluştu: $e'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('TarifAI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ingredientController,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      hintText: 'Malzeme ismi girin',
                      labelText: 'Malzeme',
                    ),
                    onSubmitted: (_) => _addIngredient(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addIngredient,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_ingredients.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Eklenen Malzemeler:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: _clearAllIngredients,
                    icon: const Icon(Icons.delete_sweep),
                    tooltip: 'Tüm malzemeleri temizle',
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _ingredients
                    .asMap()
                    .entries
                    .map(
                      (entry) => Chip(
                        label: Text(entry.value),
                        onDeleted: () => _removeIngredient(entry.key),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _getRecipes,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Tarifleri Listele'),
              ),
            ],
            if (_recipe != null) ...[
              const SizedBox(height: 24),
              const Text(
                'Önerilen Tarifler:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _recipe!,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
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