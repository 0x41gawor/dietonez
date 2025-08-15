class IngredientFull {
  final int id;
  final String name;
  final double kcal;
  final double protein;
  final double fat;
  final double carbs;
  final String unit;
  final String shopStyle;
  final num defaultAmount;

  IngredientFull({
    required this.id,
    required this.name,
    required this.kcal,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.unit,
    required this.shopStyle,
    required this.defaultAmount,
  });

  factory IngredientFull.fromJson(Map<String, dynamic> j) => IngredientFull(
    id: j['id'] as int,
    name: j['name'] as String,
    kcal: (j['kcal'] as num).toDouble(),
    protein: (j['protein'] as num).toDouble(),
    fat: (j['fat'] as num).toDouble(),
    carbs: (j['carbs'] as num).toDouble(),
    unit: j['unit'] as String,
    shopStyle: j['shopStyle'] as String,
    defaultAmount: j['default_amount'] as num,
  );
}

class MealIngredient {
  final IngredientFull ingredient;
  final num amount;
  MealIngredient({required this.ingredient, required this.amount});

  factory MealIngredient.fromJson(Map<String, dynamic> j) => MealIngredient(
    ingredient: IngredientFull.fromJson(j['ingredient']),
    amount: j['amount'],
  );
}

class Recipe {
  final String totalTime;
  final String before;
  final String whenToStart;
  final String preparation;

  Recipe({required this.totalTime, required this.before, required this.whenToStart, required this.preparation});

  factory Recipe.fromJson(Map<String, dynamic> j) => Recipe(
    totalTime: j['total_time'] ?? '',
    before: j['before'] ?? '',
    whenToStart: j['when_to_start'] ?? '',
    preparation: j['preparation'] ?? '',
  );
}

class Meal {
  final int id;
  final String name;
  final String meal; // Breakfast/MainMeal/...
  final double kcal, protein, fat, carbs;
  final List<MealIngredient> ingredients;
  final Recipe recipe;

  Meal({
    required this.id,
    required this.name,
    required this.meal,
    required this.kcal,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.ingredients,
    required this.recipe,
  });

  factory Meal.fromSectionJson(Map<String, dynamic> j) => Meal(
    id: j['id'] as int,
    name: j['name'] as String,
    meal: j['meal'] as String,
    kcal: (j['kcal'] as num).toDouble(),
    protein: (j['protein'] as num).toDouble(),
    fat: (j['fat'] as num).toDouble(),
    carbs: (j['carbs'] as num).toDouble(),
    ingredients: (j['ingredients'] as List<dynamic>)
        .map((e) => MealIngredient.fromJson(e))
        .toList(),
    recipe: Recipe.fromJson(j['recipe'] ?? {}),
  );
}

class MenuSummary {
  final double kcal, proteins, fats, carbs;
  final double kcalGoal, proteinPerKg, fatsPerc, carbsPerKg;

  MenuSummary({
    required this.kcal,
    required this.proteins,
    required this.fats,
    required this.carbs,
    required this.kcalGoal,
    required this.proteinPerKg,
    required this.fatsPerc,
    required this.carbsPerKg,
  });

  factory MenuSummary.fromJson(Map<String, dynamic> j) => MenuSummary(
    kcal: (j['kcal'] as num).toDouble(),
    proteins: (j['proteins'] as num).toDouble(),
    fats: (j['fats'] as num).toDouble(),
    carbs: (j['carbs'] as num).toDouble(),
    kcalGoal: (j['kcal_goal'] as num).toDouble(),
    proteinPerKg: (j['protein_per_kg'] as num).toDouble(),
    fatsPerc: (j['fats_perc'] as num).toDouble(),
    carbsPerKg: (j['carbs_per_kg'] as num).toDouble(),
  );
}

class MenuResponse {
  final Meal breakfast, lunch, preworkout, postworkout, supper;
  final MenuSummary summary;

  MenuResponse({
    required this.breakfast,
    required this.lunch,
    required this.preworkout,
    required this.postworkout,
    required this.supper,
    required this.summary,
  });

  factory MenuResponse.fromJson(Map<String, dynamic> j) => MenuResponse(
    breakfast: Meal.fromSectionJson(j['breakfast']),
    lunch: Meal.fromSectionJson(j['lunch']),
    preworkout: Meal.fromSectionJson(j['preworkout']),
    postworkout: Meal.fromSectionJson(j['postworkout']),
    supper: Meal.fromSectionJson(j['supper']),
    summary: MenuSummary.fromJson(j['menu_summary']),
  );
}
