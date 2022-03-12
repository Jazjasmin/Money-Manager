import 'package:flutter/material.dart';
import 'package:money_management_system/db/category/category_db.dart';
import 'package:money_management_system/model/category/category_model.dart';
import 'package:money_management_system/screens/category/category_add_popup.dart';
import 'package:money_management_system/screens/category/screen_category.dart';
import 'package:money_management_system/screens/home/widgets/bottom_navigation.dart';
import 'package:money_management_system/screens/transaction/screen_add_transaction.dart';
import 'package:money_management_system/screens/transaction/screen_transaction.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedItemNotifier = ValueNotifier(0);

  final _Pages = const [
    ScreenTransaction(),
    ScreenCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
            title: const Text('Money Manager'),
            centerTitle: true,
            backgroundColor: Colors.deepPurple[900]),
        bottomNavigationBar: const MoneyManagementBottomNavigationBar(),
        body: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: selectedItemNotifier,
            builder: (BuildContext context, int updatedIndex, _) {
              return _Pages[updatedIndex];
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.teal[200],
            onPressed: () {
              if (selectedItemNotifier.value == 0) {
               // print('Add Transactions');
                Navigator.of(context).pushNamed(ScreenAddTransactions.routeName);
              } else {
               // print('Add Category');

                showCategoryAddPopup(context);
                
              // final _sample = CategoryModel(
              // id: DateTime.now().microsecondsSinceEpoch.toString() ,
              // name: 'Travel', 
              // type: CategoryType.income );
              // CategoryDB().insertCategory(_sample);
              }
            },
            child: Icon(
              Icons.add,
            )));
  }
}
