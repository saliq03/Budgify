import 'package:budgify/features/expense_tracker/view/pages/expense_tracker_page.dart';
import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:budgify/features/expense_tracker/viewmodel/riverpod/expense_tracker_notifier.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/view/widgets/reusable_app_bar.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final wProvider = ref.watch(expenseTrackerProvider.notifier);

    // Getting the required values from the provider's state
    final totalExpense = wProvider.totalExpense;
    final totalIncome = wProvider.totalIncome;
    final totalBalance = wProvider.totalBalance;
    final currency = ref.watch(currencyProvider).symbol;
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: ReusableAppBar(
        text: 'Report',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            spacerH(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: DateFilter(),
            ),
            spacerH(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SfCircularChart(
                borderColor: theme.onSurface,
                backgroundColor: theme.secondary,
                borderWidth: 1,
                title: ChartTitle(text: 'Expense Summary'),
                legend: Legend(isVisible: true),
                series: <CircularSeries>[
                  PieSeries<_ChartData, String>(
                    dataSource: [
                      _ChartData('$currency Total Balance', totalBalance),
                      _ChartData('Income', totalIncome),
                      _ChartData('Expense', totalExpense),
                    ],
                    xValueMapper: (_ChartData data, _) => data.category,
                    yValueMapper: (_ChartData data, _) => data.amount,

                    pointColorMapper: (_ChartData data, _) {
                      if (data.category.contains('Total Balance')) return AppColors.themeDark;
                      if (data.category == 'Income') return AppColors.lightGreen;
                      if (data.category == 'Expense') return AppColors.lightRed;
                      return Colors.grey;
                    },
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(
                        color: Colors.black, // <-- this changes text color to white
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bar Chart for Total Income, Expense, and Balance using `fl_chart`
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: BarChart(
            //     BarChartData(
            //       titlesData: FlTitlesData(show: true),
            //       borderData: FlBorderData(show: true),
            //       gridData: FlGridData(show: true),
            //       barGroups: [
            //         BarChartGroupData(x: 0, barRods: [
            //           BarChartRodData(
            //               y: totalIncome,
            //               colors: [Colors.green],
            //               width: 20),
            //         ]),
            //         BarChartGroupData(x: 1, barRods: [
            //           BarChartRodData(
            //               y: totalExpense,
            //               colors: [Colors.red],
            //               width: 20),
            //         ]),
            //         BarChartGroupData(x: 2, barRods: [
            //           BarChartRodData(
            //               y: totalBalance,
            //               colors: [Colors.blue],
            //               width: 20),
            //         ]),
            //       ],
            //     ),
            //   ),
            // ),


            // Pie Chart for Expense vs Income using `syncfusion_flutter_charts`


            // Line Chart for Income, Expense, and Balance over Time (static example)
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: SfCartesianChart(
            //     primaryXAxis: CategoryAxis(),
            //     primaryYAxis: NumericAxis(),
            //     title: ChartTitle(text: 'Income, Expense, and Balance Over Time'),
            //     series: <ChartSeries<_ChartData, String>>[
            //       LineSeries<_ChartData, String>(
            //         dataSource: [
            //           _ChartData('Jan', totalIncome),
            //           _ChartData('Feb', totalExpense),
            //           _ChartData('Mar', totalBalance),
            //         ],
            //         xValueMapper: (_ChartData data, _) => data.category,
            //         yValueMapper: (_ChartData data, _) => data.amount,
            //         color: Colors.blue,
            //         name: 'Income/Expense/Balance',
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.category, this.amount);
  final String category;
  final double amount;
}
