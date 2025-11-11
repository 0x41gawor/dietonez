import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../models.dart';
import 'macro_chip.dart';
import 'ingredient_row.dart';
import 'ingredient_edit_dialog.dart';
import 'package:provider/provider.dart';
import '../controller.dart';


class MealSection extends StatefulWidget {
  final String title;
  final Color accent;
  final DishInMenu meal;
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
                    final options = await c.getDishOptions(widget.meal.dish.meal);
                    if (!mounted) return;
                    if (options.isEmpty) {
                      _toast(context, 'Brak dostępnych dań');
                      return;
                    }

                    final selected = await showDialog<DishOption>(
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
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Anuluj")),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("OK")),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        final c = context.read<MenuViewController>();
                        await c.replaceDish(widget.meal.slotNum, selected.id);
                      }
                    }
                  },
                  child: Text(widget.meal.dish.name, style: Theme.of(context).textTheme.titleLarge),
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
              if (widget.meal.dish.name != "")
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        final recipe = widget.meal.dish.recipe;
                        return AlertDialog(
                          title: Text('Przepis: ${widget.meal.dish.name}'),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // totalTime
                                TextField(
                                  controller: TextEditingController(text: recipe.totalTime ?? ''),
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Total time',
                                    alignLabelWithHint: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // before
                                TextField(
                                  controller: TextEditingController(text: recipe.before ?? ''),
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Before',
                                    alignLabelWithHint: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // whenToStart
                                TextField(
                                  controller: TextEditingController(text: recipe.whenToStart ?? ''),
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText: 'When to start',
                                    alignLabelWithHint: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // preparation (textarea)
                                TextField(
                                  controller: TextEditingController(text: recipe.preparation ?? ''),
                                  readOnly: true,
                                  maxLines: 6,
                                  decoration: const InputDecoration(
                                    labelText: 'Preparation',
                                    alignLabelWithHint: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(0),
                    child: Icon(Icons.menu_book_outlined, size: 18),
                  ),
                ),
              Spacer(),
              MacroChip(type: Macro.kcal, text: widget.meal.dish.kcal.round().toString()),
              const SizedBox(width: 8),
              MacroChip(type: Macro.protein, text: widget.meal.dish.protein.round().toString()),
              const SizedBox(width: 8),
              MacroChip(type: Macro.fat, text: widget.meal.dish.fat.round().toString()),
              const SizedBox(width: 8),
              MacroChip(type: Macro.carbs, text: widget.meal.dish.carbs.round().toString()),
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
          for (final it in widget.meal.dish.ingredients)
            IngredientRow(
              mi: it,
              onDelete: () async {
                final c = context.read<MenuViewController>();
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Usuń składnik"),
                    content: Text("Czy na pewno chcesz usunąć '${it.ingredient.name}'?"),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Anuluj")),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Usuń")),
                    ],
                  ),
                );

                if (confirm == true) {
                  await c.deleteIngredientFromMenu(
                    day: c.selectedDate,
                    ingredientId: it.ingredient.id,
                    meal: widget.title,
                  );
                  _toast(context, "Składnik usunięty");
                }
              },
              onEdit: () async {
                final result = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (ctx) => IngredientEditDialog(
                    meal: widget.title,
                    day: context.read<MenuViewController>().selectedDate,
                    initialIngredient: IngredientMin(id: it.ingredient.id, name: it.ingredient.name),
                    initialAmount: it.amount,
                  ),
                );
                if (result != null) {
                  final c = context.read<MenuViewController>();
                  await c.upsertIngredientInMenu(
                    day: c.selectedDate,
                    ingredientId: result['ingredient'].id,
                    oldIngredientId: it.ingredient.id,
                    meal: widget.title,
                    amount: result['amount'],
                  );
                  _toast(context, 'Składnik zaktualizowany');
                }
              },

            ),

          const SizedBox(height: 2),
          Center(
            child: FloatingActionButton.small(
              onPressed: () async {
                final result = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (ctx) => IngredientEditDialog(
                    meal: widget.title,
                    day: context.read<MenuViewController>().selectedDate,
                  ),
                );
                if (result != null) {
                  final c = context.read<MenuViewController>();
                  await c.upsertIngredientInMenu(
                    day: c.selectedDate,
                    ingredientId: result['ingredient'].id,
                    meal: widget.title,
                    amount: result['amount'],
                  );
                  _toast(context, 'Składnik dodany');
                }
              },
              backgroundColor: Colors.black,
              child: const Icon(Icons.add_outlined, color: Colors.white),
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
