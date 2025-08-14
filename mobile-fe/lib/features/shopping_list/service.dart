import '../../core/network.dart';
import '../../core/date_fmt.dart';
import 'models.dart';

class ShoppingListService {
  final ApiClient _api = ApiClient();

  Future<ShoppingListResponse> fetch(DateTime date) async {
    final j = await _api.getJson('/shopping-list', query: {'date': yyyyMmDd(date)});
    return ShoppingListResponse.fromJson(j);
  }
}
