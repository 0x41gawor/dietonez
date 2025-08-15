import 'package:flutter/material.dart';

enum Macro { kcal, protein, fat, carbs }

Color macroColor(Macro m) {
  switch (m) {
    case Macro.kcal:   return const Color(0xFFFFA000); // orange
    case Macro.protein:return const Color(0xFF1976D2); // blue
    case Macro.fat:    return const Color(0xFFE57373); // red
    case Macro.carbs:  return const Color(0xFF757575); // gray
  }
}

int _defaultSlots(Macro m) => m == Macro.kcal ? 3 : 2;
double _defaultBorderThickness(Macro m) => m == Macro.kcal ? 2.0 : 1.0;

class MacroChip extends StatelessWidget {
  final Macro type;
  final String text;
  final EdgeInsets padding;

  /// Optional override: number of character "slots" (2 or 3).
  /// If null, uses type-based default (kcal=3, others=2).
  final int? slots;

  /// Optional override: border thickness in px.
  /// If null, uses type-based default (kcal=2.0, others=1.0).
  final double? borderThickness;

  const MacroChip({
    super.key,
    required this.type,
    required this.text,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    this.slots,
    this.borderThickness,
  });

  @override
  Widget build(BuildContext context) {
    final color = macroColor(type);
    final effSlots = slots ?? _defaultSlots(type);
    final effBorder = borderThickness ?? _defaultBorderThickness(type);

    assert(effSlots >= 2 || effSlots <= 4, 'slots must be 2,3 or 4');
    assert(effBorder > 0, 'borderThickness must be > 0');

    final textStyle =
    const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87);

    // Fixed size based on slots (never grows).
    final sample = '8' * effSlots;
    final tp = TextPainter(
      text: TextSpan(text: sample, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final fixedW = tp.width + padding.horizontal;
    final fixedH = tp.height + padding.vertical;

    return SizedBox(
      width: fixedW,
      height: fixedH,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: effBorder),
        ),
        child: Center(
          // If the value is longer than the slots, it scales down to fit.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: padding,
              child: Text(text, style: textStyle, textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}
