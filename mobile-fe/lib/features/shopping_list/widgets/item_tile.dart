import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../models.dart';

class ItemTile extends StatelessWidget {
  final ShoppingListItem item;

  // dla ShoppingAmountItem
  final bool? checked;
  final VoidCallback? onCheckTap;

  // dla ShoppingStockItem
  final ValueChanged<bool>? onToggleStock;

  const ItemTile({
    super.key,
    required this.item,
    this.checked,
    this.onCheckTap,
    this.onToggleStock,
  });


  @override
  Widget build(BuildContext context) {
    final text = Text(
      item.ingredient.name,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        decoration: checked == true
            ? TextDecoration.lineThrough
            : TextDecoration.none,
        color: checked == true ? Colors.black38 : null,
      ),
    );

    final trailing = switch (item) {
      ShoppingAmountItem it => Text(
        '${it.amount} ${it.ingredient.unit}',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: checked == true ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),

      ShoppingStockItem it => Switch(
        value: it.isPresent,
        onChanged: onToggleStock, // 👈 miejsce na API
        activeColor: Colors.white,
        activeTrackColor: Colors.black,
        inactiveThumbColor: Colors.black,
        inactiveTrackColor: Colors.white,
      ),
    };

    return InkWell(
      onTap: onCheckTap, // 👈 tylko dla amount
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
            trailing,
          ],
        ),
      ),
    );
  }

}
