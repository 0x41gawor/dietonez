import 'package:flutter/material.dart';

class CountBadge extends StatelessWidget {
  final int count;
  const CountBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return count == 0
        ? const SizedBox.shrink()
        : Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
