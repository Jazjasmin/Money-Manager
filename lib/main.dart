import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management_system/db/category/category_db.dart';
import 'package:money_management_system/model/category/category_model.dart';
import 'package:money_management_system/model/transaction/transaction_model.dart';
import 'package:money_management_system/screens/home/logo_page.dart';
import 'package:money_management_system/screens/home/screen_home.dart';
import 'package:money_management_system/screens/transaction/screen_add_transaction.dart';

Future<void> main() async {
  final obj1 = CategoryDB();
  final obj2 = CategoryDB();


  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if(!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)){
    Hive.registerAdapter(CategoryModelAdapter());
  }
  if(!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)){
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  if(!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)){
    Hive.registerAdapter(TransactionModelAdapter());
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashLogo(),
      routes: {
        ScreenAddTransactions.routeName:(ctx) => const ScreenAddTransactions(),
      },
    );
  }
}

