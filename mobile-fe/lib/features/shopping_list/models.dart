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

enum ShoppingSection {
  fresh,
  lidl,
  stock,
  live,
  gs,
}


sealed class ShoppingListItem {
  Ingredient get ingredient;
  String key();
}

class ShoppingAmountItem implements ShoppingListItem {
  @override
  final Ingredient ingredient;
  final num amount;

  ShoppingAmountItem({
    required this.ingredient,
    required this.amount,
  });

  factory ShoppingAmountItem.fromJson(Map<String, dynamic> j) =>
      ShoppingAmountItem(
        ingredient: Ingredient.fromJson(j['ingredient']),
        amount: j['amount'],
      );

  @override
  String key() => '${ingredient.id}:$amount:${ingredient.unit}';
}

class ShoppingStockItem implements ShoppingListItem {
  @override
  final Ingredient ingredient;
  bool isPresent;

  ShoppingStockItem({
    required this.ingredient,
    required this.isPresent,
  });

  factory ShoppingStockItem.fromJson(Map<String, dynamic> j) => ShoppingStockItem(
    ingredient: Ingredient.fromJson(j['ingredient']),
    isPresent: j['is_present'] as bool,
  );

  @override
  String key() => '${ingredient.id}';
}


class ShoppingListResponse {
  final List<ShoppingAmountItem>? fresh;
  final List<ShoppingAmountItem>? lidl;
  final List<ShoppingStockItem>? stock;
  final List<ShoppingAmountItem>? live;
  final List<ShoppingAmountItem>? gs;

  ShoppingListResponse({this.fresh, this.lidl, this.stock, this.live, this.gs});

  factory ShoppingListResponse.fromJson(Map<String, dynamic> j) {
    List<T>? mapList<T>(
        dynamic v,
        T Function(Map<String, dynamic>) fromJson,
        ) {
      if (v == null) return null;
      return (v as List)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return ShoppingListResponse(
      fresh: mapList(j['fresh'], ShoppingAmountItem.fromJson),
      lidl: mapList(j['lidl'], ShoppingAmountItem.fromJson),
      stock: mapList(j['stock'], ShoppingStockItem.fromJson),
      live: mapList(j['live'], ShoppingAmountItem.fromJson),
      gs: mapList(j['gs'], ShoppingAmountItem.fromJson),
    );
  }

  List<ShoppingListItem> listFor(ShoppingSection section) {
    switch (section) {
      case ShoppingSection.lidl: return lidl ?? const [];
      case ShoppingSection.fresh: return fresh ?? const [];
      case ShoppingSection.stock: return stock ?? const [];
      case ShoppingSection.live: return live ?? const [];
      case ShoppingSection.gs: return gs ?? const [];
    }
  }

}
