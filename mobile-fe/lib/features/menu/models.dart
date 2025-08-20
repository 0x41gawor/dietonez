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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'kcal': kcal,
    'protein': protein,
    'fat': fat,
    'carbs': carbs,
    'unit': unit,
    'shopStyle': shopStyle,
    'default_amount': defaultAmount,
  };

}

class MealIngredient {
  final IngredientFull ingredient;
  final num amount;

  MealIngredient({required this.ingredient, required this.amount});

  factory MealIngredient.fromJson(Map<String, dynamic> j) => MealIngredient(
    ingredient: IngredientFull.fromJson(j['ingredient']),
    amount: j['amount'],
  );

  Map<String, dynamic> toJson() => {
    'ingredient': ingredient.toJson(),
    'amount': amount,
  };
}

class Recipe {
  final String totalTime;
  final String before;
  final String whenToStart;
  final String preparation;

  Recipe({
    required this.totalTime,
    required this.before,
    required this.whenToStart,
    required this.preparation,
  });

  factory Recipe.fromJson(Map<String, dynamic> j) => Recipe(
    totalTime: j['total_time'] ?? '',
    before: j['before'] ?? '',
    whenToStart: j['when_to_start'] ?? '',
    preparation: j['preparation'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'total_time': totalTime,
    'before': before,
    'when_to_start': whenToStart,
    'preparation': preparation,
  };
}

class DishInMenu {
  final Dish dish;
  final int slotNum;

  DishInMenu({required this.dish, required this.slotNum});

  factory DishInMenu.fromSectionJson(Map<String, dynamic>? j) {
    if (j == null) {
      return DishInMenu.empty();
    }
    return DishInMenu(
      dish: Dish.fromSectionJson(j['dish'] as Map<String, dynamic>?),
      slotNum: j['slot_num'] as int? ?? 0,
    );
  }
  factory DishInMenu.empty() => DishInMenu(dish: Dish.empty(), slotNum: 0);

  Map<String, dynamic> toJson() => {
    'dish': dish.toJson(),
    'slot_num': slotNum,
  };
}

class Dish {
  final int id;
  final String name;
  final String meal; // Breakfast/MainMeal/...
  final double kcal, protein, fat, carbs;
  final List<MealIngredient> ingredients;
  final Recipe recipe;

  Dish({
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

  factory Dish.fromSectionJson(Map<String, dynamic>? j) {
    if (j == null) {
      return Dish.empty(); // <-- defaulty
    }
    return Dish(
      id: j['id'] as int? ?? 0,
      name: j['name'] as String? ?? '',
      meal: j['meal'] as String? ?? '',
      kcal: (j['kcal'] as num?)?.toDouble() ?? 0.0,
      protein: (j['protein'] as num?)?.toDouble() ?? 0.0,
      fat: (j['fat'] as num?)?.toDouble() ?? 0.0,
      carbs: (j['carbs'] as num?)?.toDouble() ?? 0.0,
      ingredients:
          (j['ingredients'] as List<dynamic>?)
              ?.map((e) => MealIngredient.fromJson(e))
              .toList() ??
          [],
      recipe: Recipe.fromJson(j['recipe'] ?? {}),
    );
  }

  factory Dish.empty() => Dish(
    id: 0,
    name: '',
    meal: '',
    kcal: 0,
    protein: 0,
    fat: 0,
    carbs: 0,
    ingredients: [],
    recipe: Recipe.fromJson({}),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'meal': meal,
    'kcal': kcal,
    'protein': protein,
    'fat': fat,
    'carbs': carbs,
    'ingredients': ingredients.map((e) => e.toJson()).toList(),
    'recipe': recipe.toJson(),
  };
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

  Map<String, dynamic> toJson() =>
      {
        'kcal': kcal,
        'proteins': proteins,
        'fats': fats,
        'carbs': carbs,
        'kcalGoal': kcalGoal,
        'proteinPerKg': proteinPerKg,
        'fatsPerc': fatsPerc,
        'carbsPerKg': carbsPerKg,
      };
}

class MenuResponse {
  final DishInMenu breakfast, lunch, preworkout, postworkout, supper;
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
    breakfast: DishInMenu.fromSectionJson(j['breakfast']),
    lunch: DishInMenu.fromSectionJson(j['lunch']),
    preworkout: DishInMenu.fromSectionJson(j['preworkout']),
    postworkout: DishInMenu.fromSectionJson(j['postworkout']),
    supper: DishInMenu.fromSectionJson(j['supper']),
    summary: MenuSummary.fromJson(j['menu_summary']),
  );

  Map<String, dynamic> toJson() => {
    'breakfast': breakfast.toJson(),
    'lunch': lunch.toJson(),
    'preworkout': preworkout.toJson(),
    'postworkout': postworkout.toJson(),
    'supper': supper.toJson(),
    'menu_summary': summary.toJson(),
  };
}

class DishOption {
  final int id;
  final String name;

  DishOption({required this.id, required this.name});

  factory DishOption.fromJson(Map<String, dynamic> j) => DishOption(
    id: j['id'] as int,
    name: j['name'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
