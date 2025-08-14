class Ingredient {
  final int id;
  final String name;
  final String unit;
  Ingredient({required this.id, required this.name, required this.unit});

  factory Ingredient.fromJson(Map<String, dynamic> j) => Ingredient(
    id: j['id'] as int,
    name: j['name'] as String,
    unit: j['unit'] as String,
  );
}

class ShoppingListItem {
  final Ingredient ingredient;
  final num amount;
  ShoppingListItem({required this.ingredient, required this.amount});

  factory ShoppingListItem.fromJson(Map<String, dynamic> j) => ShoppingListItem(
    ingredient: Ingredient.fromJson(j['ingredient']),
    amount: j['amount'],
  );

  // unique key for local check state
  String key() => '${ingredient.id}:${amount}:${ingredient.unit}';
}

class ShoppingListResponse {
  final List<ShoppingListItem>? fresh;
  final List<ShoppingListItem>? lidl;
  final List<ShoppingListItem>? stock;
  final List<ShoppingListItem>? live;
  final List<ShoppingListItem>? gs;

  ShoppingListResponse({this.fresh, this.lidl, this.stock, this.live, this.gs});

  factory ShoppingListResponse.fromJson(Map<String, dynamic> j) {
    List<ShoppingListItem>? mapList(dynamic v) {
      if (v == null) return null;
      final list = v as List<dynamic>;
      return list.map((e) => ShoppingListItem.fromJson(e)).toList();
    }

    return ShoppingListResponse(
      fresh: mapList(j['fresh']),
      lidl: mapList(j['lidl']),
      stock: mapList(j['stock']),
      live: mapList(j['live']),
      gs: mapList(j['gs']),
    );
  }

  List<ShoppingListItem> listFor(String key) {
    switch (key) {
      case 'lidl': return lidl ?? [];
      case 'fresh': return fresh ?? [];
      case 'stock': return stock ?? [];
      case 'live': return live ?? [];
      case 'gs': return gs ?? [];
      default: return const [];
    }
  }
}
