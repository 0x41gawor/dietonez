import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../models.dart';
import 'macro_chip.dart';

class IngredientRow extends StatelessWidget {
  final MealIngredient mi;
  final VoidCallback onDelete;
  const IngredientRow({super.key, required this.mi, required this.onDelete});

  // prosta estymacja makr dla amount – skaluje po defaultAmount
  Map<Macro, double> _calc() {
    final f = mi.amount / mi.ingredient.defaultAmount;
    return {
      Macro.kcal: mi.ingredient.kcal * f,
      Macro.protein: mi.ingredient.protein * f,
      Macro.fat: mi.ingredient.fat * f,
      Macro.carbs: mi.ingredient.carbs * f,
    };
  }

  @override
  Widget build(BuildContext context) {
    final m = _calc();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: cardRadius,
        border: Border.all(color: const Color(0xFFDBDBDB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(mi.ingredient.name, style: Theme.of(context).textTheme.bodyLarge)),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete',
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('${mi.amount} ${mi.ingredient.unit}', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              MacroChip(type: Macro.kcal, text: m[Macro.kcal]!.round().toString(), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
              const SizedBox(width: 8),
              MacroChip(type: Macro.protein, text: m[Macro.protein]!.round().toString(), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
              const SizedBox(width: 8),
              MacroChip(type: Macro.fat, text: m[Macro.fat]!.round().toString(), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
              const SizedBox(width: 8),
              MacroChip(type: Macro.carbs, text: m[Macro.carbs]!.round().toString(), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
            ],
          ),
        ],
      ),
    );
  }
}
