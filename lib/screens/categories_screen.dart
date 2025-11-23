import 'package:flutter/material.dart';

import '../models/category.dart';
import '../services/meal_api_service.dart';
import '../widgets/category_card.dart';
import 'meals_by_category_screen.dart';
import 'meal_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final MealApiService api = MealApiService();
  List<Category> categories = [];
  List<Category> filtered = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await api.fetchCategories();
    setState(() {
      categories = data;
      filtered = data;
      loading = false;
    });
  }

  void search(String q) {
    q = q.toLowerCase();
    setState(() {
      filtered = categories
          .where((c) => c.name.toLowerCase().contains(q))
          .toList();
    });
  }

  Future<void> openRandom() async {
    final meal = await api.fetchRandomMeal();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealDetailScreen(mealId: meal.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Categories"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: openRandom,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    onChanged: search,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      labelText: "Search categories",
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => CategoryCard(
                      category: filtered[i],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MealsByCategoryScreen(
                              categoryName: filtered[i].name,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
