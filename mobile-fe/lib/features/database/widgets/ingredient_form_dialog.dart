import 'package:flutter/material.dart';
import '../models.dart';

class IngredientFormDialog extends StatefulWidget {
  const IngredientFormDialog({super.key});

  @override
  State<IngredientFormDialog> createState() => _IngredientFormDialogState();
}

class _IngredientFormDialogState extends State<IngredientFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final kcalCtrl = TextEditingController();
  final proteinCtrl = TextEditingController();
  final fatCtrl = TextEditingController();
  final carbsCtrl = TextEditingController();

  String unit = 'g';
  String shop = 'Lidl';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Dodaj składnik",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                _field("Nazwa", nameCtrl),
                _field("Domyślna ilość", amountCtrl, keyboard: TextInputType.number),

                Row(
                  children: [
                    Expanded(child: _dropdown("jednostka", unit, ["g", "porcja", "sztuka", "kromka", "łyżeczka", "łyżka", "opakowanie", "szczypta"], (v) => setState(() => unit = v))),
                    const SizedBox(width: 12),
                    Expanded(child: _dropdown("zakupy", shop, ["Lidl", "Świeże", "Zapasy", "Na żywo", "G.S."], (v) => setState(() => shop = v))),
                  ],
                ),

                _macroField("Kalorie", kcalCtrl, Colors.orange),
                _macroField("Białko", proteinCtrl, Colors.blue),
                _macroField("Tłuszcz", fatCtrl, Colors.red),
                _macroField("Węglowodany", carbsCtrl, Colors.grey),

                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Anuluj"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(
                              context,
                              IngredientPost(
                                name: nameCtrl.text,
                                unit: unit,
                                shopStyle: shop,
                                defaultAmount: num.parse(amountCtrl.text),
                                kcal: double.parse(kcalCtrl.text),
                                protein: double.parse(proteinCtrl.text),
                                fat: double.parse(fatCtrl.text),
                                carbs: double.parse(carbsCtrl.text),
                                labels: null,
                              ),
                            );
                          }
                        },
                        child: const Text("Dodaj"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c, {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(labelText: label),
        keyboardType: keyboard,
        validator: (v) => v == null || v.isEmpty ? "Wymagane" : null,
      ),
    );
  }

  Widget _macroField(String label, TextEditingController c, Color borderColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: borderColor),
          ),
        ),
        validator: (v) => v == null || v.isEmpty ? "Wymagane" : null,
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField(
        value: value,
        decoration: InputDecoration(labelText: label),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => onChanged(v as String),
      ),
    );
  }
}
