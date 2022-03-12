import 'package:flutter/material.dart';
import 'package:money_management_system/db/category/category_db.dart';
import 'package:money_management_system/db/transactions/transactions_db.dart';
import 'package:money_management_system/model/category/category_model.dart';
import 'package:money_management_system/model/transaction/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refreshUI();
    CategoryDB.instance.refreshUI();
    return ValueListenableBuilder(
        valueListenable: TransactionDB.instance.transactionListNotifier,
        builder: (BuildContext ctx, List<TransactionModel> newlist, Widget? _) {
          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemBuilder: (ctx, index) {
              final _value = newlist[index];
              return Slidable(
                key: Key(_value.id!),
                startActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(onPressed: (ctx){
                      TransactionDB.instance.deleteTransaction(_value.id!);
                    },
                    icon: Icons.delete,
                    backgroundColor:Colors.red,
                    label: 'Delete',
                    ),
                  ],),
                child: Card(
                  elevation: 0,
                  child: ListTile(
                    leading: CircleAvatar(
                      //backgroundColor: Color(0xFF9575CD),
                      radius: 60,
                      child: Text(
                        parseDate(_value.date),
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: _value.type == CategoryType.income
                          ? Colors.green[200]
                          : Colors.red[200],
                          
                    ),
                    
                    title: Text('Rs ${_value.amount}'),
                    subtitle: Text(_value.category.name,),
                    isThreeLine: true, 
                    trailing: Text(_value.purpose,
                    style: TextStyle(color: Colors.grey,
                    fontSize: 12) ,),                   
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return SizedBox(
                height: 10,
              );
            },
            itemCount: newlist.length,
          );
        },
        );
  }

  String parseDate(DateTime date) {
    //var DateFormat;
    final _date = DateFormat.MMMd().format(date);
    final _splitDate = _date.split(' ');
    return '${_splitDate.last}\n ${_splitDate.first}';
    //return '${date.day}\n${date.month}';
  }
}
