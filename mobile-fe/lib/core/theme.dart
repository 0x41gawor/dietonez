import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const base = Colors.black87;
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: base),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: base),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: base),
      titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: base),
      bodyLarge: TextStyle(fontSize: 16, color: base),
      bodyMedium: TextStyle(fontSize: 15, color: base),
    ),
    dividerColor: Colors.white,
    splashFactory: InkRipple.splashFactory,
  );
}

BoxDecoration pill({Color color = Colors.white}) => BoxDecoration(
  color: color,
  borderRadius: BorderRadius.circular(20),
  boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0,2), blurRadius: 8)],
);

BorderRadius get cardRadius => BorderRadius.circular(12);
