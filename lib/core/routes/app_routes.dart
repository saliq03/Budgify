import 'package:budgify/core/routes/paths.dart';
import 'package:budgify/features/expense_tracker/view/pages/expense_management_page.dart';
import 'package:flutter/material.dart';
import '../../features/expense_tracker/view/pages/more_apps_page.dart';
import '../../features/profile/view/pages/profile_page.dart';
import '../../shared/view/widgets/bottom_nav_bar/bottom_nav_bar.dart';

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Paths.initial:
        return MaterialPageRoute(builder: (context) => BottomNavBar());

      case Paths.moreAppsPage:
        return MaterialPageRoute(builder: (context) => MoreAppsPage());

      case Paths.expenseManagementPage:
        return MaterialPageRoute(
            builder: (context) => const ExpenseManagementPage());

       default:
        return MaterialPageRoute(builder: (context) => const ProfilePage());

    // case Paths.bottomNavBar:
    //   return MaterialPageRoute(builder: (context) => BottomNavBar());
    }
  }
}
