import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../controller.dart';
import '../models.dart';
import 'count_badge.dart';
import 'item_tile.dart';

class CategorySection extends StatefulWidget {
  final String categoryKey; // lidl | fresh | stock | live | gs
  final String title;
  const CategorySection({super.key, required this.categoryKey, required this.title});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ShoppingListController>();
    final List<ShoppingListItem> items = c.data?.listFor(widget.categoryKey) ?? [];
    final count = items.length;

    final header = Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: cardRadius,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
          ),
          if (count > 0) ...[
            CountBadge(count: count),
            const SizedBox(width: 12),
          ],
          AnimatedRotation(
            turns: _expanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 180),
            child: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black45),
          ),
        ],
      ),
    );

    final body = !_expanded
        ? const SizedBox.shrink()
        : Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: cardRadius,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          for (final it in items)
            ItemTile(
              item: it,
              checked: c.isChecked(widget.categoryKey, it),
              onTap: () => c.toggle(widget.categoryKey, it),
            ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
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
}
