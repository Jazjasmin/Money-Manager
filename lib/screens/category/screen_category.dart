import 'package:flutter/material.dart';
import 'package:money_management_system/db/category/category_db.dart';
import 'package:money_management_system/screens/category/expense_category.dart';
import 'package:money_management_system/screens/category/income_category.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({Key? key}) : super(key: key);

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    //  CategoryDB().getCategories().then((value) {
    //    print('Category get');
    //    print(value.toString());
    //  });
    CategoryDB().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.purple[900],
            labelStyle: const TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
            ),
            tabs: const [
              
              Tab(
                text: 'Income',
              ),
              Tab(
                text: 'Expense',
              ),
            ]),
        Expanded(
          child: TabBarView(controller: _tabController, children: [
            IncomeCategoryList(),
            ExpenseCategoryList(),
          ]),
        ),
      ],
    );
  }
}
