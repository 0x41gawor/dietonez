import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/date_header.dart';
import 'widgets/meal_section.dart';
import 'widgets/summary_bar.dart';
import 'controller.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MenuViewController>().initIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<MenuViewController>();
    final data = c.data;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => c.fetch(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: DateHeader(
                dateText: c.dateText(),
                weekdayText: c.weekdayText(),
                onChangeDay: c.changeDay,
                onPickDate: c.pickDate,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: c.loading ? const LinearProgressIndicator(minHeight: 2) : const SizedBox(height: 2),
              ),
            ),
            if (c.error != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: ${c.error}', style: const TextStyle(color: Colors.red)),
                ),
              ),
            if (data != null) ...[
              SliverToBoxAdapter(
                child: MealSection(
                  title: 'Breakfast',
                  accent: const Color(0xFFCC9933),
                  meal: data.breakfast.dish,
                  onAdd: () {},
                ),
              ),
              SliverToBoxAdapter(
                child: MealSection(
                  title: 'Lunch',
                  accent: const Color(0xFFE57390),
                  meal: data.lunch.dish,
                  onAdd: () {},
                ),
              ),
              SliverToBoxAdapter(
                child: MealSection(
                  title: 'Pre-Workout',
                  accent: const Color(0xFF42A5F5),
                  meal: data.preworkout.dish,
                  onAdd: () {},
                ),
              ),
              SliverToBoxAdapter(
                child: MealSection(
                  title: 'Post-Workout',
                  accent: const Color(0xFFE57390),
                  meal: data.postworkout.dish,
                  onAdd: () {},
                ),
              ),
              SliverToBoxAdapter(
                child: MealSection(
                  title: 'Supper',
                  accent: const Color(0xFF66BB6A),
                  meal: data.supper.dish,
                  onAdd: () {},
                ),
              ),
              SliverToBoxAdapter(child: SummaryBar(s: data.summary)),
              const SliverPadding(padding: EdgeInsets.only(bottom: 0)),
            ],
          ],
        ),
      ),
    );
  }
}
