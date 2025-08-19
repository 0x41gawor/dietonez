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
}
