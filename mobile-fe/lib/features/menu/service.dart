import '../../core/network.dart';
import '../../core/date_fmt.dart';
import 'models.dart';

class MenuService {
  final ApiClient _api = ApiClient();

  Future<MenuResponse> fetch(DateTime date) async {
    final j = await _api.getJson('/menu', query: {'date': yyyyMmDd(date)});
    return MenuResponse.fromJson(j);
  }
}
