import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../models.dart';
import 'macro_chip.dart';

class SummaryBar extends StatelessWidget {
  final MenuSummary s;
  const SummaryBar({super.key, required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 18),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: cardRadius,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0,2))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _cell('Kalorie', Macro.kcal, s.kcal.round().toString(), sub: '/${s.kcalGoal.round()}'),
              _cell('Białko', Macro.protein, s.proteins.toStringAsFixed(1), sub: '${s.proteinPerKg.toStringAsFixed(2)} [g/kg]'),
              _cell('Tłuszcz', Macro.fat, s.fats.toStringAsFixed(1), sub: '${s.fatsPerc.round()}%'),
              _cell('Węglow.', Macro.carbs, s.carbs.toStringAsFixed(1), sub: '${s.carbsPerKg.toStringAsFixed(1)} [g/kg]'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cell(String title, Macro m, String value, {String? sub}) {
    return Expanded(
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 6),
          MacroChip(type: m, text: value),
          const SizedBox(height: 6),
          if (sub != null) Text(sub, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
