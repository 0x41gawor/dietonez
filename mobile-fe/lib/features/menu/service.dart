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
    required int dietId,
    required int slotNum,
    required int dishId,
  }) async {
    await _api.send(
      '/diets/$dietId/slot',
      method: 'PATCH',
      body: {
        'slot_num': slotNum,
        'dish_id': dishId,
      },
    );
  }



}
