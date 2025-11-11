import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'features/menu/controller.dart';

import 'core/theme.dart';
import 'app_shell.dart';
import 'features/shopping_list/controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Inicjalizuj dane lokalizacyjne dla PL
  await initializeDateFormatting('pl_PL', null);
  Intl.defaultLocale = 'pl_PL'; // ułatwia DateFormat bez podawania parametru

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuViewController()),
        ChangeNotifierProvider(create: (_) => ShoppingListController()),
      ],
      child: const DietonezApp(),
    ),
  );
}

class DietonezApp extends StatelessWidget {
  const DietonezApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dietonez',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),

      // 2) Delegaty i obsługiwane locale
      locale: const Locale('pl', 'PL'),
      supportedLocales: const [
        Locale('pl', 'PL'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      home: const AppShell(),
    );
  }
}
