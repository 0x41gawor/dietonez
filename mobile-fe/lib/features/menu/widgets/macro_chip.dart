import 'package:flutter/material.dart';

enum Macro { kcal, protein, fat, carbs }

Color macroColor(Macro m) {
  switch (m) {
    case Macro.kcal: return const Color(0xFFFFA000); // pomarańcz
    case Macro.protein: return const Color(0xFF1976D2); // niebieski
    case Macro.fat: return const Color(0xFFE57373); // czerwony
    case Macro.carbs: return const Color(0xFF757575); // szary
  }
}

class MacroChip extends StatelessWidget {
  final Macro type;
  final String text;
  final EdgeInsets padding;
  const MacroChip({super.key, required this.type, required this.text, this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5)});

  @override
  Widget build(BuildContext context) {
    final c = macroColor(type);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c, width: 1),
      ),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87)),
    );
  }
}
