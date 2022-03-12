import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management_system/model/transaction/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

abstract class TransactionDBFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getTransaction();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDBFunctions{

  TransactionDB._internal();
  static TransactionDB instance = TransactionDB._internal();
  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier = 
    ValueNotifier([]);

  @override 
  Future<void> addTransaction(TransactionModel obj) async {
    final _transactionDb = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    _transactionDb.put(obj.id, obj);
  }

  @override
  Future<List<TransactionModel>> getTransaction() async {
    final _transactionDb = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return _transactionDb.values.toList();
  }

  Future<void> refreshUI() async {
    final _allTransaction = await getTransaction();
    _allTransaction.sort((first,second) => second.date.compareTo(first.date));
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_allTransaction);
    transactionListNotifier.notifyListeners();    
  }

  @override
  Future<void> deleteTransaction(String id) async {
   final _transactionDb = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
   await _transactionDb.delete(id);
   refreshUI();
  }
}