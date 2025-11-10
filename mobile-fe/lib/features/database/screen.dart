import 'package:flutter/material.dart';
import 'widgets/ingredient_form_dialog.dart'; // dialog
import 'service.dart';      // API service
import 'models.dart';       // model

class DbScreen extends StatelessWidget {
  const DbScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Database')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await showDialog<IngredientPost>(
            context: context,
            builder: (_) => const IngredientFormDialog(),
          );

          if (result != null) {
            final db = DatabaseService();
            await db.createIngredient(result);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ Składnik dodany')),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
