import 'package:flutter/material.dart';

const mealOptions = [
  "Breakfast",
  "Lunch",
  "Pre-Workout",
  "Post-Workout",
  "Supper",
];


class CopyDishDialogResult {
  final DateTime toDay;
  final String toMeal;

  CopyDishDialogResult({
    required this.toDay,
    required this.toMeal,
  });
}

class CopyDishDialog extends StatefulWidget {
  final DateTime fromDay;
  final String fromMeal;

  const CopyDishDialog({
    super.key,
    required this.fromDay,
    required this.fromMeal,
  });

  @override
  State<CopyDishDialog> createState() => _CopyDishDialogState();
}

class _CopyDishDialogState extends State<CopyDishDialog> {
  late DateTime _selectedDay;
  String _selectedMeal = "Breakfast";

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.fromDay;
    _selectedMeal = widget.fromMeal;
  }



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Kopiuj danie"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Z: ${widget.fromDay.toString().split(' ').first} – ${widget.fromMeal}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),

          // DATE PICKER
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today),
            title: Text(
              _selectedDay.toString().split(' ').first,
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDay,
                firstDate: DateTime(2023),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => _selectedDay = picked);
              }
            },
          ),

          const SizedBox(height: 8),

          // MEAL DROPDOWN
          DropdownButtonFormField<String>(
            value: _selectedMeal,
            decoration: const InputDecoration(
              labelText: "Posiłek docelowy",
            ),
            items: mealOptions
                .map(
                  (m) => DropdownMenuItem(
                value: m,
                child: Text(m),
              ),
            )
                .toList(),
            onChanged: (v) {
              if (v != null) {
                setState(() => _selectedMeal = v);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Anuluj"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              CopyDishDialogResult(
                toDay: _selectedDay,
                toMeal: _selectedMeal,
              ),
            );
          },
          child: const Text("Kopiuj"),
        ),
      ],
    );
  }
}
