import 'package:flutter/material.dart';
import '../../core/date_fmt.dart';
import 'models.dart';
import 'service.dart';

class ShoppingListController extends ChangeNotifier {
  final ShoppingListService _service = ShoppingListService();

  DateTime selectedDate = DateTime.now();
  ShoppingListResponse? data;
  bool loading = false;
  String? error;

  // checked state per category -> set of item keys
  final Map<ShoppingSection, Set<String>> _checked = {
    ShoppingSection.lidl: <String>{},
    ShoppingSection.fresh: <String>{},
    ShoppingSection.stock: <String>{},
    ShoppingSection.live: <String>{},
    ShoppingSection.gs: <String>{},
  };


  Future<void> initIfNeeded() async {
    if (data == null && !loading) {
      await fetch();
    }
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
      notifyListeners();
    }
  }

  void changeDay(int deltaDays) {
    selectedDate = selectedDate.add(Duration(days: deltaDays));
    fetch();
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: selectedDate,
      helpText: 'Wybierz datę listy zakupów',
      locale: const Locale('pl', 'PL'),
    );
    if (picked != null) {
      selectedDate = picked;
      fetch();
    }
  }

  bool isChecked(ShoppingSection section, ShoppingListItem it) =>
      _checked[section]!.contains(it.key());

  void toggle(ShoppingSection section, ShoppingListItem it) {
    final set = _checked[section]!;
    final k = it.key();
    set.contains(k) ? set.remove(k) : set.add(k);
    notifyListeners();
  }

  Future<void> toggleStock(ShoppingStockItem it, bool value) async {
    final prev = it.isPresent;
    it.isPresent = value;
    notifyListeners();

    try {
      await _service.setStockPresence(it.ingredient.id, value);
    } catch (e) {
      // rollback
      it.isPresent = prev;
      notifyListeners();
    }
  }




  String dateText() => yyyyMmDd(selectedDate);
  String weekdayText() => weekdayPl(selectedDate);
}
