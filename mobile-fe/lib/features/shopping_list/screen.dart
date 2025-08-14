import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller.dart';
import 'widgets/date_header.dart';
import 'widgets/category_section.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  @override
  void initState() {
    super.initState();
    // initial load
    final c = context.read<ShoppingListController>();
    c.initIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ShoppingListController>();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => c.fetch(),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: DateHeader()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: c.loading
                    ? const LinearProgressIndicator(minHeight: 2)
                    : const SizedBox(height: 2),
              ),
            ),
            if (c.error != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: ${c.error}', style: const TextStyle(color: Colors.red)),
                ),
              ),
            const SliverToBoxAdapter(
              child: CategorySection(categoryKey: 'lidl', title: 'Lidl'),
            ),
            const SliverToBoxAdapter(
              child: CategorySection(categoryKey: 'fresh', title: 'Świeże'),
            ),
            const SliverToBoxAdapter(
              child: CategorySection(categoryKey: 'stock', title: 'Zapasy'),
            ),
            const SliverToBoxAdapter(
              child: CategorySection(categoryKey: 'live', title: 'Na żywo'),
            ),
            const SliverToBoxAdapter(
              child: CategorySection(categoryKey: 'gs', title: 'G.S.'),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
          ],
        ),
      ),
    );
  }
}
