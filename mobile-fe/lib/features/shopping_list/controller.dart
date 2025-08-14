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
  final Map<String, Set<String>> _checked = {
    'lidl': <String>{},
    'fresh': <String>{},
    'stock': <String>{},
    'live': <String>{},
    'gs': <String>{},
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

  bool isChecked(String category, ShoppingListItem it) =>
      _checked[category]!.contains(it.key());

  void toggle(String category, ShoppingListItem it) {
    final set = _checked[category]!;
    final k = it.key();
    if (set.contains(k)) {
      set.remove(k);
    } else {
      set.add(k);
    }
    notifyListeners();
  }

  String dateText() => yyyyMmDd(selectedDate);
  String weekdayText() => weekdayPl(selectedDate);
}
