import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../models.dart';
import 'macro_chip.dart';

class IngredientRow extends StatelessWidget {
  final MealIngredient mi;
  final VoidCallback onDelete;

  const IngredientRow({super.key, required this.mi, required this.onDelete});

  Map<Macro, double> _calc() {
    return {
      Macro.kcal: mi.ingredient.kcal,
      Macro.protein: mi.ingredient.protein,
      Macro.fat: mi.ingredient.fat,
      Macro.carbs: mi.ingredient.carbs,
    };
  }

  @override
  Widget build(BuildContext context) {
    final m = _calc();

    // Styl cyfr: tabular figures = każda cyfra ma tę samą szerokość
    final numStyle = TextStyle(
      fontWeight: FontWeight.w300,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    final numStyleBold = TextStyle(
      fontWeight: FontWeight.w400,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    // Obliczamy szerokości „slotów” dla 2 i 3 cyfr, by były stałe na każdej linii
    double slotWidth(int slots) {
      final tp = TextPainter(
        text: TextSpan(text: '8' * slots, style: numStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      return tp.width + 6; // mały margines
    }

    final w3 = slotWidth(3); // kcal
    final w2 = slotWidth(2); // protein/fat/carbs

    return Container(
      margin: const EdgeInsets.only(top: 3, bottom: 3),
      padding: const EdgeInsets.only(left: 5, top: 1, right: 1, bottom: 1),
      // padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
              Expanded(
                child: Text(
                  mi.ingredient.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete',
              ),
            ],
          ),
          const SizedBox(height: 0),
          Row(
            children: [
              Text(
                '${mi.amount} ${mi.ingredient.unit}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              // Text(m[Macro.kcal]!.round().toString()),
              _metricCell(
                m[Macro.kcal]!.round(),
                width: w3,
                style: numStyleBold,
              ),
              const SizedBox(width: 30),
              _metricCell(
                m[Macro.protein]!.round(),
                width: w3,
                style: numStyle,
              ),
              // Text(m[Macro.protein]!.round().toString()),
              const SizedBox(width: 22),
              _metricCell(m[Macro.fat]!.round(), width: w3, style: numStyle),
              // Text(m[Macro.fat]!.round().toString()),
              const SizedBox(width: 22),
              _metricCell(m[Macro.carbs]!.round(), width: w3, style: numStyle),
              // Text(m[Macro.carbs]!.round().toString()),
              const SizedBox(width: 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricCell(
    num value, {
    required double width,
    required TextStyle style,
  }) {
    return SizedBox(
      width: width,
      child: Text(value.toString(), textAlign: TextAlign.center, style: style),
    );
  }
}
