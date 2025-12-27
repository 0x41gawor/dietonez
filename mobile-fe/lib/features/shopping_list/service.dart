import '../../core/network.dart';
import '../../core/date_fmt.dart';
import 'models.dart';

class ShoppingListService {
  final ApiClient _api = ApiClient();

  Future<ShoppingListResponse> fetch(DateTime date) async {
    final j = await _api.getJson('/shopping-list', query: {'date': yyyyMmDd(date)});
    return ShoppingListResponse.fromJson(j);
  }

  Future<void> setStockPresence(int ingredientId, bool isPresent) async {
    await _api.send(
      method: 'PUT',
      '/ingredients/$ingredientId/stock',
      body: {
        'is_present': isPresent,
      },
    );
  }
}
