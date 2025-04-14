import 'package:budgify/features/expense_tracker/view/pages/expense_tracker_page.dart';
import 'package:budgify/features/profile/view/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../../features/my_budget/view/pages/my_budget_page.dart';

class BottomNavBar extends StatefulWidget {

  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  String bottomNavFontFamily = 'Poppins';
  int currentPage = 0;
  List<Widget> bottomBarPages = [];

  @override
  void initState() {
    super.initState();
    bottomBarPages = [
      ExpenseTrackerPage(),
      MyBudgetPage(),
      ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          IndexedStack(
            index: currentPage,
            children: bottomBarPages,
          ),

        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        items: bottomNavBarItems(context),
        currentIndex: currentPage,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }

  List<SalomonBottomBarItem> bottomNavBarItems(BuildContext context) => [
    SalomonBottomBarItem(
      selectedColor: Theme.of(context).colorScheme.primary,
      icon: const Icon(
        Icons.monetization_on_outlined,
      ),
      title: Text(
        'Expense Tracker',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: bottomNavFontFamily,
        ),
      ),
    ),
    SalomonBottomBarItem(
      selectedColor: Theme.of(context).colorScheme.primary,
      icon: const Icon(
        Icons.account_balance_wallet_outlined,
      ),
      title: Text(
        'My Budget',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: bottomNavFontFamily,
        ),
      ),
    ),
    SalomonBottomBarItem(
      selectedColor: Theme.of(context).colorScheme.primary,
      icon: const Icon(
        Icons.bar_chart,
      ),
      title: Text(
        'Report',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: bottomNavFontFamily,
        ),
      ),
    ),
  ];
}
