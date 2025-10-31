import 'package:flutter/material.dart';
import 'features/placeholders/home_screen.dart';
import 'features/placeholders/db_screen.dart';
import 'features/placeholders/profile_screen.dart';
import 'features/shopping_list/screen.dart';
import 'features/menu/screen.dart';
import 'features/menu/screen.dart';


class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 2; // start on shopping list, like mock

  Widget _tab(int i) {
    switch (i) {
      case 0: return const HomeScreen();
      case 1: return const DbScreen();
      case 2: return const MenuScreen();
      case 3: return const ShoppingListScreen();
      case 4: return const ProfileScreen();
      default: return const ShoppingListScreen();
    }
  }

  Widget _navIcon(String name, {bool active = false}) {
    final imgPath = 'assets/icons/$name-${active ? 'full' : 'empty'}.png';

    return Container(
      width: 48,                 // stały rozmiar = brak skoków
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF4CAF50) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.asset(imgPath, width: 28, height: 28),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tab(_index),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => setState(() => _index = 0),
                icon: _navIcon('home', active: _index == 0),
                padding: EdgeInsets.zero,                              // <-- ważne
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                splashRadius: 28,
              ),
              IconButton(
                onPressed: () => setState(() => _index = 1),
                icon: _navIcon('database', active: _index == 1),
                padding: EdgeInsets.zero,                              // <-- ważne
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                splashRadius: 28,
              ),
              IconButton(
                onPressed: () => setState(() => _index = 2),
                icon: _navIcon('menu', active: _index == 2),
                padding: EdgeInsets.zero,                              // <-- ważne
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                splashRadius: 28,
              ),
              IconButton(
                onPressed: () => setState(() => _index = 3),
                icon: _navIcon('shop-list', active: _index == 3),
                padding: EdgeInsets.zero,                              // <-- ważne
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                splashRadius: 28,
              ),
              IconButton(
                onPressed: () => setState(() => _index = 4),
                icon: _navIcon('user', active: _index == 4),
                padding: EdgeInsets.zero,                              // <-- ważne
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                splashRadius: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
