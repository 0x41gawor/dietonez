class IngredientPost {
  final String name;
  final String unit;
  final String shopStyle;
  final num defaultAmount;
  final double kcal;
  final double protein;
  final double fat;
  final double carbs;
  final List<String>? labels;

  IngredientPost({
    required this.name,
    required this.unit,
    required this.shopStyle,
    required this.defaultAmount,
    required this.kcal,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.labels,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'unit': unit,
    'shopStyle': shopStyle,
    'default_amount': defaultAmount,
    'kcal': kcal,
    'protein': protein,
    'fat': fat,
    'carbs': carbs,
    'labels': labels,
  };
}
