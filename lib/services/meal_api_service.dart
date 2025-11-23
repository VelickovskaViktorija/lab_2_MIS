import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/meal.dart';

class MealApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/categories.php'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final list = data['categories'] as List;
      return list.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/filter.php?c=$category'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List meals = data['meals'];
      return meals
          .map((e) => MealSummary(
                id: e['idMeal'],
                name: e['strMeal'],
                thumb: e['strMealThumb'],
                category: category,
              ))
          .toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<List<MealSummary>> searchMealsInCategory(
      String category, String query) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/search.php?s=$query'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['meals'] == null) return [];

      final List meals = data['meals'];

      return meals
          .map((e) => MealSummary.fromJson(e))
          .where((m) => m.category == category)
          .toList();
    } else {
      throw Exception('Failed to search meals');
    }
  }

  Future<MealDetail> fetchMealDetail(String id) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/lookup.php?i=$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MealDetail.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load meal detail');
    }
  }

  Future<MealDetail> fetchRandomMeal() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/random.php'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MealDetail.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load random meal');
    }
  }
}
