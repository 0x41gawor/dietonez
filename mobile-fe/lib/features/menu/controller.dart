import 'package:flutter/material.dart';
import '../../core/date_fmt.dart';
import 'models.dart';
import 'service.dart';
import 'dart:convert';

class MenuViewController extends ChangeNotifier {
  final MenuService _service = MenuService();

  DateTime selectedDate = DateTime.now();
  MenuResponse? data;
  bool loading = false;
  String? error;

  Map<String, List<DishOption>> _dishOptionsCache = {};

  Future<void> initIfNeeded() async {
    if (data == null && !loading) await fetch();
  }

  Future<void> fetch() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      data = await _service.fetch(selectedDate);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      debugPrint("🔥 DUPA >>> ${const JsonEncoder.withIndent('  ').convert(data?.toJson())}");
      notifyListeners();
    }
  }

  void changeDay(int d) {
    selectedDate = selectedDate.add(Duration(days: d));
    fetch();
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: selectedDate,
      helpText: 'Wybierz datę menu',
      locale: const Locale('pl', 'PL'),
    );
    if (picked != null) {
      selectedDate = picked;
      fetch();
    }
  }

  String dateText() => yyyyMmDd(selectedDate);
  String weekdayText() => weekdayPl(selectedDate);

  Future<List<DishOption>> getDishOptions(String meal) async {
    if (_dishOptionsCache.containsKey(meal)) {
      return _dishOptionsCache[meal]!;
    }
    try {
      final opts = await _service.fetchDishOptions(meal);
      _dishOptionsCache[meal] = opts;
      return opts;
    } catch (e) {
      debugPrint("❌ Błąd pobierania opcji dla $meal: $e");
      return [];
    }
  }

  Future<void> replaceDish({required DateTime day, required String meal, required int? dishId, required String name}) async {
    try {
      await _service.replaceDishInSlot(
        day: day,
        meal: meal,
        dishId: dishId,
        name: name,
      );
      // po udanej podmianie możesz odświeżyć menu
      await fetch();
    } catch (e) {
      debugPrint("❌ Błąd podmiany dania: $e");
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> clearDish({required DateTime day, required String meal}) async {
    try {
      await _service.clearDishInSlot(day: day, meal: meal);
      await fetch();
    } catch (e) {
      debugPrint("❌ Błąd wyczyszczenia dania: $e");
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteIngredientFromMenu({
    required DateTime day,
    required int ingredientId,
    required String meal,
  }) async {
    try {
      await _service.deleteIngredient(
        day: day,
        ingredientId: ingredientId,
        meal: meal,
      );
      // Po usunięciu odśwież dane, żeby UI się zaktualizował
      await fetch();
    } catch (e) {
      debugPrint("❌ Błąd usuwania składnika: $e");
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> upsertIngredientInMenu({
    required DateTime day,
    required int ingredientId,
    int? oldIngredientId,
    required String meal,
    required num amount,
  }) async {
    try {
      await _service.upsertIngredient(
        day: day,
        ingredientId: ingredientId,
        oldIngredientId: oldIngredientId,
        meal: meal,
        amount: amount,
      );
      await fetch(); // odśwież menu
    } catch (e) {
      debugPrint('❌ Błąd upsertIngredientInMenu: $e');
      error = e.toString();
      notifyListeners();
    }
  }



}
