import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/routes/paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../shared/view/widgets/date_filter.dart';
import '../../../../shared/view/widgets/global_widgets.dart';
import '../../../../shared/view/widgets/reusable_app_bar.dart';
import '../../model/currency_model.dart';
import '../../utils/transaction_type.dart';
import '../../viewmodel/riverpod/expense_tracker_notifier.dart';
import '../widgets/buttons/reusable_outlined_button.dart';
import '../widgets/drawer/custom_drawer.dart';
import '../widgets/reusable_card_details.dart';
import '../widgets/transaction_filter/transaction_filter1.dart';
import '../widgets/transaction_filter/transaction_filter2.dart';
import '../widgets/transaction_info.dart';
part 'expense_tracker_page.dart';
part 'investment_and_tax_page.dart';

class ExpenseTrackerHomePage extends ConsumerStatefulWidget {
  const ExpenseTrackerHomePage({super.key});

  @override
  ConsumerState<ExpenseTrackerHomePage> createState() => _ExpenseTrackerHomePageState();
}

class _ExpenseTrackerHomePageState extends ConsumerState<ExpenseTrackerHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scaffoldKey.currentState?.closeEndDrawer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: CustomDrawer(h: h, w: w * 0.7),
      appBar: ReusableAppBar(
        text: 'Expense Tracker',
        // text: 'Profile',
        isCenterText: false,
        isMenu: true,
        onPressed: () {
          _scaffoldKey.currentState!.openEndDrawer();
        },
      ),
      body: Column(
        children: [
          // spacerH(),
          // Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
          //     child: DateFilter()),
          // spacerH(10),
          // CurrencyPicker(),
          // spacerH(10),

          TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: theme.primary,
              labelStyle: AppStyles.headingPrimary(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  context: context,
                  color: theme.primary),
              tabs: [
                Tab(text: 'All Transactions'),
                Tab(text: 'Investment & Tax'),
              ]),

          Expanded(child: TabBarView(
              controller: _tabController,
              children: [
                ExpenseTrackerPage(),
                InvestmentAndTaxPage(),
              ]))

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Paths.expenseManagementPage);
        },
        backgroundColor: theme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
