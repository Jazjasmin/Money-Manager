import 'package:flutter/material.dart';
import 'package:money_management_system/screens/home/screen_home.dart';

class  MoneyManagementBottomNavigationBar extends StatelessWidget {
  const MoneyManagementBottomNavigationBar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomeScreen.selectedItemNotifier,
     builder: (BuildContext ctx, int updatedIndex, Widget? _){
        return BottomNavigationBar(
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          currentIndex: updatedIndex,
          onTap: (newIndex){
            HomeScreen.selectedItemNotifier.value = newIndex;            
          },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home),
        label: 'Transaction'),
        BottomNavigationBarItem(icon: Icon(Icons.category),
        label: 'Categories'),
      ],
      
    );
     });
   
  }
}