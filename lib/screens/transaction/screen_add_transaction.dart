import 'package:flutter/material.dart';
import 'package:money_management_system/db/category/category_db.dart';
import 'package:money_management_system/db/transactions/transactions_db.dart';
import 'package:money_management_system/model/category/category_model.dart';
import 'package:money_management_system/model/transaction/transaction_model.dart';

class ScreenAddTransactions extends StatefulWidget {
  static const routeName = 'Add-transaction';
  const ScreenAddTransactions({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransactions> createState() => _ScreenAddTransactionsState();
}

class _ScreenAddTransactionsState extends State<ScreenAddTransactions> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  String? _categoryID;

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20.0, left: 20, bottom: 20, top: 50),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            //calender
            TextButton.icon(
              onPressed: () async {
                final selectedDateTemp = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate:
                      DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now(),
                );
                if (selectedDateTemp == null) {
                  return;
                } else {
                  //print(selectedDateTemp.toString());
                  setState(() {
                    _selectedDate = selectedDateTemp;
                  });
                }
              },
              icon: const Icon(
                Icons.calendar_today,
                color: Colors.blue,
              ),
              label: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : _selectedDate!.toString(),
                style: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            TextFormField(
              controller: _purposeTextEditingController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  hintText: 'Purpose',
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFEF9A9A))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)))),
            ),
            const SizedBox(
              height: 8,
            ),
            //amount
            TextFormField(
              controller: _amountTextEditingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'Amount',
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFEF9A9A))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)))),
            ),
            const SizedBox(height: 8,),
            //radio button-categorytype
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue),
                      //focusColor: Colors.teal,
                      //hoverColor: Colors.green,
                      value: CategoryType.income,
                      groupValue: _selectedCategoryType,
                      onChanged: (newvalue) {
                        setState(() {
                          _selectedCategoryType = CategoryType.income;
                          _categoryID = null;
                        });
                      },
                    ),
                    const Text('Income'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue),
                      value: CategoryType.expense,
                      groupValue: _selectedCategoryType,
                      onChanged: (newvalue) {
                        setState(() {
                          _selectedCategoryType = CategoryType.expense;
                          _categoryID = null;
                        });
                      },
                    ),
                    const Text('Expense'),
                  ],
                )
              ],
            ),
             DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: _categoryID,
                    hint: const Text(
                      'Select Category',
                      style: TextStyle(color: Colors.black),
                    ),
                    items: (_selectedCategoryType == CategoryType.income
                            ? CategoryDB().incomeCategoryListListener
                            : CategoryDB().expenseCategoryListListener)
                        .value
                        .map((e) {
                      return DropdownMenuItem(
                        value: e.id,
                        child: Text(e.name),
                        onTap: () {
                          _selectedCategoryModel = e;
                        },
                      );
                    }).toList(),
                    onChanged: (selectedValue) {
                      //print(selectedValue);
                      setState(() {
                        _categoryID = selectedValue.toString();
                      });
                    },
                    onTap: () {},
                  ),
                ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    addTransaction();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue[600]),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;

    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    //if(_categoryID == null){
    // return;
    //}
    if (_selectedDate == null) {
      return;
    }
    if (_selectedCategoryModel == null) {
      return;
    }
    final parsedAmount = double.tryParse(_amountText);
    if (parsedAmount == null) {
      return;
    }

    final model = TransactionModel(
        purpose: _purposeText,
        amount: parsedAmount,
        date: _selectedDate!,
        type: _selectedCategoryType!,
        category: _selectedCategoryModel!);

    await TransactionDB.instance.addTransaction(model);
    Navigator.of(context).pop();
    TransactionDB.instance.refreshUI();
  }
}
