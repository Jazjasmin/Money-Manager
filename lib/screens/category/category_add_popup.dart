import 'package:flutter/material.dart';
import 'package:money_management_system/db/category/category_db.dart';
import 'package:money_management_system/model/category/category_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  final _nameEditingController = TextEditingController();
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Add Category'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameEditingController,
                decoration: InputDecoration(
                    fillColor: Colors.deepPurple.shade900,
                    hintText: 'Category Name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple.shade900)
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  RadioButton(titile: 'Income', type: CategoryType.income),
                  RadioButton(titile: 'Expense', type: CategoryType.expense),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  final _name = _nameEditingController.text;
                  if(_name.isEmpty)
                  {
                    return;
                  }
                  final _type = selectedCategoryNotifier.value;
                  final _category = CategoryModel(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                   name: _name,
                   type: _type,
                  );
                  CategoryDB.instance.insertCategory(_category);
                  Navigator.of(ctx).pop();
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurple.shade900)),
                child: const Text('Add'),
              ),
            ),
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  final String titile;
  final CategoryType type;

  const RadioButton({
    Key? key,
     required this.titile,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategoryNotifier,
          builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
            return Radio<CategoryType>(
              value: type,
              groupValue: newCategory,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                selectedCategoryNotifier.value = value;
                selectedCategoryNotifier.notifyListeners();
              },
            );
          },
        ),
        Text(titile),
      ],
    );
  }
}
