import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:budgify/features/expense_tracker/viewmodel/riverpod/expense_tracker_notifier.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/view/widgets/date_filter.dart';
import '../../../../shared/view/widgets/reusable_app_bar.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final expenseData = ref.watch(expenseTrackerProvider);
    final currencySymbol = ref.watch(currencyProvider).symbol;
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const ReusableAppBar(text: 'Report'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            spacerH(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                      _ChartData('$currencySymbol Total Balance', expenseData.trackerCategory.totalBalance),
                      _ChartData('Income', expenseData.trackerCategory.totalIncome),
                      _ChartData('Expense', expenseData.trackerCategory.totalExpense),
                    ],
                    xValueMapper: (_ChartData data, _) => data.category,
                    yValueMapper: (_ChartData data, _) => data.amount,
                    pointColorMapper: (_ChartData data, _) {
                      if (data.category.contains('Total Balance')) return AppColors.themeDark;
                      if (data.category == 'Income') return AppColors.lightGreen;
                      if (data.category == 'Expense') return AppColors.lightRed;
                      return Colors.grey;
                    },
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 600,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(show: true),
                    gridData: FlGridData(show: true),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: expenseData.trackerCategory.totalIncome,
                            color: Colors.green,
                            width: 20,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: expenseData.trackerCategory.totalExpense,
                            color: Colors.red,
                            width: 20,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: expenseData.trackerCategory.totalBalance,
                            color: Colors.blue,
                            width: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                title: ChartTitle(text: 'Income, Expense, and Balance Over Time'),
                series: [
                  LineSeries<_ChartData, String>(
                    dataSource: [
                      _ChartData('Jan', expenseData.trackerCategory.totalIncome),
                      _ChartData('Feb', expenseData.trackerCategory.totalExpense),
                      _ChartData('Mar', expenseData.trackerCategory.totalBalance),
                    ],
                    xValueMapper: (_ChartData data, _) => data.category,
                    yValueMapper: (_ChartData data, _) => data.amount,
                    color: Colors.blue,
                    name: 'Income/Expense/Balance',
                  ),
                ],
              ),
            ),
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
