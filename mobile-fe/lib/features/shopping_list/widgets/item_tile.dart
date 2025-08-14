import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../models.dart';

class ItemTile extends StatelessWidget {
  final ShoppingListItem item;
  final bool checked;
  final VoidCallback onTap;

  const ItemTile({
    super.key,
    required this.item,
    required this.checked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      item.ingredient.name,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        decoration: checked ? TextDecoration.lineThrough : TextDecoration.none,
        color: checked ? Colors.black38 : null,
      ),
    );

    final amount = Text(
      '${item.amount} x ${item.ingredient.unit}',
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: checked ? Colors.black38 : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: cardRadius,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: cardRadius,
          border: Border.all(color: const Color(0xFFDBDBDB)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(child: text),
            const SizedBox(width: 12),
            amount,
          ],
        ),
      ),
    );
  }
}
