import '../../core/network.dart';
import '../../core/date_fmt.dart';
import 'models.dart';

class MenuService {
  final ApiClient _api = ApiClient();

  Future<MenuResponse> fetch(DateTime date) async {
    final j = await _api.getJson<Map<String, dynamic>>('/menu', query: {'date': yyyyMmDd(date)});
    return MenuResponse.fromJson(j);
  }

  Future<List<DishOption>> fetchDishOptions(String meal) async {
    final j = await _api.getJson<List<dynamic>>('/dishes', query: {
      'meal': meal,
      'min': 'false',
    });

    return j.map((e) => DishOption.fromJson(e)).toList();
  }

  Future<void> replaceDishInSlot({
    required DateTime day,
    required String meal,
    required int dishId,
    required String name,
  }) async {
    await _api.send(
      '/menu/slot',
      method: 'PUT',
      body: {
        'day': yyyyMmDd(day),
        'meal': meal,
        'name': name,
        'dishId': dishId,
      },
    );
  }

  Future<void> clearDishInSlot({
    required DateTime day,
    required String meal,
  }) async {
    await _api.send(
      '/menu/slot',
      method: 'DELETE',
      body: {
        'day': yyyyMmDd(day),
        'meal': meal,
      },
    );
  }

  Future<void> deleteIngredient({
    required DateTime day,
    required int ingredientId,
    required String meal,
  }) async {
    await _api.send(
      '/menu',
      method: 'DELETE',
      body: {
        'day': day.toIso8601String(),
        'ingredient_id': ingredientId,
        'meal': meal,
      },
    );
  }

  Future<void> upsertIngredient({
    required DateTime day,
    required int ingredientId,
    int? oldIngredientId, // 🔹 nowy parametr opcjonalny
    required String meal,
    required num amount,
  }) async {
    await _api.send(
      '/menu',
      method: 'PUT',
      body: {
        'day': day.toIso8601String(),
        'ingredient_id': ingredientId,
        if (oldIngredientId != null) 'ingredient_id_old': oldIngredientId, // 👈 tylko gdy istnieje
        'meal': meal,
        'amount': amount,
      },
    );
  }


  Future<List<IngredientMinUnit>> searchIngredients({
    required String query,
    int reslen = 10,
    bool short = true,
  }) async {
    final data = await _api.getJson<Map<String, dynamic>>(
      '/ingredients/search',
      query: {
        'query': query,
        'reslen': reslen.toString(),
        'short': short.toString(),
      },
    );

    final list = data['ingredients'] as List<dynamic>;
    return list.map((e) => IngredientMinUnit.fromJson(e)).toList();
  }



}
