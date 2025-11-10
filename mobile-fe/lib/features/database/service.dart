import '../../core/network.dart';
import 'models.dart';

class DatabaseService {
  final ApiClient _api = ApiClient();

  Future<void> createIngredient(IngredientPost ingredient) async {
    await _api.send(
      '/ingredients',
      method: 'POST',
      body: ingredient.toJson(),
    );
  }
}
