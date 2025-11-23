class MealSummary {
  final String id;
  final String name;
  final String thumb;
  final String category;

  MealSummary({
    required this.id,
    required this.name,
    required this.thumb,
    required this.category,
  });

  factory MealSummary.fromJson(Map<String, dynamic> json) {
    return MealSummary(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumb: json['strMealThumb'] ?? '',
      category: json['strCategory'] ?? '',
    );
  }
}

class Ingredient {
  final String name;
  final String measure;
  Ingredient({required this.name, required this.measure});
}

class MealDetail {
  final String id;
  final String name;
  final String thumb;
  final String instructions;
  final String youtubeUrl;
  final List<Ingredient> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    required this.thumb,
    required this.instructions,
    required this.youtubeUrl,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    List<Ingredient> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ing = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ing != null &&
          ing.toString().isNotEmpty &&
          measure != null &&
          measure.toString().isNotEmpty) {
        ingredients.add(Ingredient(
          name: ing,
          measure: measure,
        ));
      }
    }

    return MealDetail(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumb: json['strMealThumb'] ?? '',
      instructions: json['strInstructions'] ?? '',
      youtubeUrl: json['strYoutube'] ?? '',
      ingredients: ingredients,
    );
  }
}
