import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';

// Kontroler jest wstrzykiwany z zewnątrz – ekran decyduje który
typedef ChangeDay = void Function(int deltaDays);
typedef PickDate = Future<void> Function(BuildContext);

class DateHeader extends StatelessWidget {
  final String dateText;
  final String weekdayText;
  final ChangeDay onChangeDay;
  final PickDate onPickDate;

  const DateHeader({
    super.key,
    required this.dateText,
    required this.weekdayText,
    required this.onChangeDay,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _roundButton(Icons.chevron_left, () => onChangeDay(-1)),
          Expanded(
            child: GestureDetector(
              onTap: () => onPickDate(context),
              child: Container(
                decoration: pill(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(dateText, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text(weekdayText.toLowerCase(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black54, letterSpacing: 0.3)),
                  ],
                ),
              ),
            ),
          ),
          _roundButton(Icons.chevron_right, () => onChangeDay(1)),
        ],
      ),
    );
  }

  Widget _roundButton(IconData icon, VoidCallback onTap) {
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
