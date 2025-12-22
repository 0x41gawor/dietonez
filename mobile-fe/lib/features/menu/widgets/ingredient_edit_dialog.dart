import 'dart:async';
import 'package:flutter/material.dart';
import '../models.dart';
import '../service.dart';

class IngredientEditDialog extends StatefulWidget {
  final IngredientMinUnit? initialIngredient; // null → tryb Add
  final num? initialAmount;
  final String meal;
  final DateTime day;

  const IngredientEditDialog({
    super.key,
    this.initialIngredient,
    this.initialAmount,
    required this.meal,
    required this.day,
  });

  @override
  State<IngredientEditDialog> createState() => _IngredientEditDialogState();
}

class _IngredientEditDialogState extends State<IngredientEditDialog> {
  final _service = MenuService();
  final _queryCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  List<IngredientMinUnit> _results = [];
  Timer? _debounce;
  IngredientMinUnit? _selected;
  bool _clearedOnce = false;


  @override
  void initState() {
    super.initState();
    if (widget.initialIngredient != null) {
      _selected = widget.initialIngredient;
      _queryCtrl.text = widget.initialIngredient!.name;
    }
    if (widget.initialAmount != null) {
      _amountCtrl.text = widget.initialAmount!.toString();
    }
  }

  void _onQueryChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (q.isEmpty) {
        setState(() => _results = []);
        return;
      }
      final res = await _service.searchIngredients(query: q);
      setState(() => _results = res);
    });
  }

  void _submit() {
    final amount = double.tryParse(_amountCtrl.text);
    if (_selected == null || amount == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Wybierz składnik i ilość')));
      return;
    }
    Navigator.pop(context, {'ingredient': _selected, 'amount': amount});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialIngredient == null ? 'Dodaj składnik' : 'Edytuj składnik'),
      content: SizedBox(
        width: double.maxFinite, // zapobiega mierzeniu intrinsic width
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _queryCtrl,
                decoration: const InputDecoration(labelText: 'Nazwa'),
                onChanged: _onQueryChanged,
                onTap: () {
                  if (!_clearedOnce && widget.initialIngredient != null) {
                    _queryCtrl.clear();
                    setState(() {
                      _selected = null;
                      _clearedOnce = true;
                    });
                  }
                },
              ),
              const SizedBox(height: 8),

              // Lista wyników — opakowana w ograniczony box
              if (_results.isNotEmpty)
                SizedBox(
                  height: 150, // albo MediaQuery.of(context).size.height * 0.3
                  child: ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (ctx, i) {
                      final ing = _results[i];
                      return ListTile(
                        dense: true,
                        title: Text(ing.name),
                        onTap: () {
                          setState(() {
                            _selected = ing;
                            _queryCtrl.text = ing.name;
                            _results.clear();
                          });
                        },
                        selected: _selected?.id == ing.id,
                      );
                    },
                  ),
                ),
              const SizedBox(height: 8),

              TextField(
                controller: _amountCtrl,
                decoration: InputDecoration(
                  labelText: (_selected?.unit == null)
                      ? 'Ilość'
                      : 'Ilość [${_selected!.unit}]',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),

      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Anuluj')),
        ElevatedButton(onPressed: _submit, child: const Text('Zapisz')),
      ],
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _queryCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }
}
