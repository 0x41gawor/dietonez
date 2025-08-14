import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../controller.dart';
import 'package:provider/provider.dart';

class DateHeader extends StatelessWidget {
  const DateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ShoppingListController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _roundButton(
            context,
            icon: Icons.chevron_left,
            onTap: () => c.changeDay(-1),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => c.pickDate(context),
              child: Container(
                decoration: pill(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(c.dateText(), style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text(c.weekdayText().toLowerCase(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black54, letterSpacing: 0.3)),
                  ],
                ),
              ),
            ),
          ),
          _roundButton(
            context,
            icon: Icons.chevron_right,
            onTap: () => c.changeDay(1),
          ),
        ],
      ),
    );
  }

  Widget _roundButton(BuildContext ctx, {required IconData icon, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: pill(color: const Color(0xFFEDEDED)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, size: 28),
        ),
      ),
    );
  }
}
