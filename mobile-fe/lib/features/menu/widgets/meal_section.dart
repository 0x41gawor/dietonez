import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../models.dart';
import 'macro_chip.dart';
import 'ingredient_row.dart';
import 'package:provider/provider.dart';
import '../controller.dart';


class MealSection extends StatefulWidget {
  final String title;
  final Color accent;
  final Dish meal;
  final VoidCallback onAdd;

  const MealSection({
    super.key,
    required this.title,
    required this.accent,
    required this.meal,
    required this.onAdd,
  });

  @override
  State<MealSection> createState() => _MealSectionState();
}

class _MealSectionState extends State<MealSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final header = Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: cardRadius,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: Theme.of(context).textTheme.titleSmall!.copyWith(color: widget.accent, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final c = context.read<MenuViewController>();
                    final options = await c.getDishOptions(widget.meal.meal);

                    if (options.isEmpty) {
                      _toast(context, 'Brak dostępnych dań');
                      return;
                    }

                    final selected = await showDialog<Dish>(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text("Wybierz danie"),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (ctx, i) {
                                final d = options[i];
                                return ListTile(
                                  title: Text(d.name),
                                  onTap: () => Navigator.of(ctx).pop(d),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );

                    if (selected != null) {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Potwierdź zmianę"),
                          content: Text("Czy chcesz podmienić na '${selected.name}'?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text("Anuluj"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        debugPrint("✅ TODO: Wywołaj endpoint podmiany dania na id=${selected.id}");
                      }
                    }
                  },
                  child: Text(widget.meal.name, style: Theme.of(context).textTheme.titleLarge),
                ),
              ),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 180),
                child: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black45),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Spacer(),
              MacroChip(type: Macro.kcal, text: widget.meal.kcal.round().toString()),
              const SizedBox(width: 8),
              MacroChip(type: Macro.protein, text: widget.meal.protein.round().toString()),
              const SizedBox(width: 8),
              MacroChip(type: Macro.fat, text: widget.meal.fat.round().toString()),
              const SizedBox(width: 8),
              MacroChip(type: Macro.carbs, text: widget.meal.carbs.round().toString()),
            ],
          ),
        ],
      ),
    );

    final body = !_expanded
        ? const SizedBox.shrink()
        : Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: cardRadius,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          for (final it in widget.meal.ingredients)
            IngredientRow(
              mi: it,
              onDelete: () => _toast(context, 'Not implemented yet'),
            ),
          const SizedBox(height: 2),
          Center(
            child: FloatingActionButton.small(
              onPressed: () => _toast(context, 'Not implemented yet'),
              backgroundColor: const Color(0xFF2E7D32),
              child: const Icon(Icons.add_circle_outline, color: Colors.white),
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          InkWell(
            borderRadius: cardRadius,
            onTap: () => setState(() => _expanded = !_expanded),
            child: header,
          ),
          body,
        ],
      ),
    );
  }

  void _toast(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
  }
}
