import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_api_service.dart';
import '../widgets/meal_grid_item.dart';
import 'meal_detail_screen.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String categoryName;

  const MealsByCategoryScreen({super.key, required this.categoryName});

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  final MealApiService api = MealApiService();
  List<MealSummary> meals = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  Future<void> loadMeals() async {
    final data = await api.fetchMealsByCategory(widget.categoryName);
    setState(() {
      meals = data;
      loading = false;
    });
  }

  Future<void> searchMeals(String query) async {
    if (query.isEmpty) {
      loadMeals();
      return;
    }
    final results =
        await api.searchMealsInCategory(widget.categoryName, query);
    setState(() {
      meals = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: searchMeals,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: "Search meals",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: meals.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (_, i) => MealGridItem(
                      meal: meals[i],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MealDetailScreen(mealId: meals[i].id),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
