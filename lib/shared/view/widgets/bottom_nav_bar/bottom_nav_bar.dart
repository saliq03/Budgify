import 'package:budgify/features/expense_tracker/view/widgets/dialog/reusable_dialog_class.dart';
import 'package:budgify/features/insights/view/pages/insights_page.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../../../features/emi_and_loan/view/pages/emi_and_loan.dart';
import '../../../../features/expense_tracker/view/pages/expense_tracker_home_page.dart';
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
      ExpenseTrackerHomePage(),
      // EmiAndLoan(),
      MyBudgetPage(),
      // BudgetManagementPage(),
      InsightsPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return WillPopScope(
    //   onWillPop: () => ReusableDialogClass.showYesNoDialog(context),
    return PopScope(
      canPop: false, // Important: block auto pop
      onPopInvokedWithResult: (value, _) => ReusableDialogClass.showYesNoDialog(context),
      child: Scaffold(
        // extendBody: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            IndexedStack(
              index: currentPage,
              children: bottomBarPages,
            ),
          ],
        ),

        // body: bottomBarPages[currentPage],
        bottomNavigationBar: SalomonBottomBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          items: bottomNavBarItems(context),
          currentIndex: currentPage,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          onTap: _onItemTapped,
        ),
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
    // SalomonBottomBarItem(
    //   selectedColor: Theme.of(context).colorScheme.primary,
    //   icon: const Icon(
    //     Icons.account_balance,
    //   ),
    //   title: Text(
    //     'EMI & Loan',
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //       fontFamily: bottomNavFontFamily,
    //     ),
    //   ),
    // ),


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
            'Insights',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: bottomNavFontFamily,
            ),
          ),
        ),
      ];
}
