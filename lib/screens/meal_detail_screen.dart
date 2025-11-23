import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/meal.dart';
import '../services/meal_api_service.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final MealApiService api = MealApiService();
  MealDetail? meal;

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  Future<void> loadDetail() async {
    final data = await api.fetchMealDetail(widget.mealId);
    setState(() {
      meal = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meal Detail")),
      body: meal == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(meal!.thumb),
                  const SizedBox(height: 10),
                  Text(
                    meal!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Ingredients:",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ...meal!.ingredients.map(
                    (i) => Text("${i.name} - ${i.measure}"),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Instructions:",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(meal!.instructions),
                  const SizedBox(height: 15),
                  if (meal!.youtubeUrl.isNotEmpty)
                    Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Open YouTube"),
                        onPressed: () {
                          launchUrl(Uri.parse(meal!.youtubeUrl),
                              mode: LaunchMode.externalApplication);
                        },
                      ),
                    )
                ],
              ),
            ),
    );
  }
}
