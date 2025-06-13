import 'package:budgify/shared/view/widgets/currency_picker.dart';
import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:budgify/features/expense_tracker/viewmodel/riverpod/expense_tracker_notifier.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../shared/view/widgets/buttons/reusable_icon_button.dart';
import '../../../../shared/view/widgets/date_filter.dart';
import '../../../../shared/view/widgets/reusable_app_bar.dart';
import '../../../expense_tracker/view/widgets/more_apps_carousel.dart';
import '../../../expense_tracker/viewmodel/riverpod/currency_provider.dart';
import '../widgets/play_store_rating.dart';
import 'dart:math';

class InsightsPage extends ConsumerStatefulWidget {
  const InsightsPage({super.key});

  @override
  ConsumerState<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends ConsumerState<InsightsPage> {
  @override
  Widget build(BuildContext context) {
    final expenseData = ref.watch(expenseTrackerProvider);
    var totalBalance = (expenseData.trackerCategory.totalIncome -
            expenseData.trackerCategory.totalExpense) -
        expenseData.trackerCategory.tax +
        expenseData.trackerCategory.investment;

    final totalIncome = expenseData.trackerCategory.totalIncome;

    totalBalance = totalBalance < 0 ? 0 : totalBalance;
    final totalInvestment = expenseData.trackerCategory.investment < 0
        ? expenseData.trackerCategory.investment * -1
        : expenseData.trackerCategory.investment;

    final totalExpense = expenseData.trackerCategory.totalExpense < 0
        ? expenseData.trackerCategory.totalExpense * -1
        : expenseData.trackerCategory.totalExpense;

    final totalTax = expenseData.trackerCategory.tax < 0
        ? expenseData.trackerCategory.tax * -1
        : expenseData.trackerCategory.tax;

    final currencySymbol = ref.watch(currencyProvider).symbol;
    final theme = Theme.of(context).colorScheme;
    final double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const ReusableAppBar(text: 'Insights'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            spacerH(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: CurrencyPicker(),
            ),
            spacerH(),
            if (expenseData.trackerCategory.investment != 0 ||
                expenseData.trackerCategory.tax != 0 ||
                expenseData.trackerCategory.totalIncome != 0 ||
                expenseData.trackerCategory.totalExpense != 0)
              reportSection(
                w: w,
                context: context,
                currencySymbol: currencySymbol,
                totalBalance: totalBalance,
                totalIncome: totalIncome,
                totalInvestment: totalInvestment,
                totalExpense: totalExpense,
                totalTax: totalTax,
                theme: theme,
              ),
            moreAppsCarousel(w: w, context: context, theme: theme),
            spacerH(30),
            playStoreRating(w, theme),
            spacerH(30),
            socialMediaConnections(w, theme),
            spacerH(80)
          ],
        ),
      ),
    );
  }

  Widget reportSection(
      {required double w,
      required BuildContext context,
      required String currencySymbol,
      required double totalBalance,
      required double totalIncome,
      required double totalInvestment,
      required double totalExpense,
      required double totalTax,
      required ColorScheme theme}) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: DateFilter(),
        ),
        spacerH(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SfCircularChart(
                // borderColor: theme.primary,
                backgroundColor: theme.onSecondary,
                borderWidth: 1,
                title: ChartTitle(
                    text: 'Expense Summary',
                    textStyle: AppStyles.headingPrimary(
                        context: context, fontSize: 16,)),
                legend: Legend(isVisible: true),
                series: <CircularSeries>[
                  PieSeries<_ChartData, String>(
                    dataSource: [
                      _ChartData('$currencySymbol Total Bal', totalBalance),
                      _ChartData('Invest', totalInvestment),
                      _ChartData('Tax', totalTax),
                      _ChartData('Income', totalIncome),
                      _ChartData('Expense', totalExpense),
                    ],
                    xValueMapper: (_ChartData data, _) => data.category,
                    yValueMapper: (_ChartData data, _) => data.amount,
                    pointColorMapper: (_ChartData data, _) {
                      if (data.category.contains('Total Bal')) {
                        return AppColors.themeLight;
                      } else if (data.category == 'Income') {
                        return AppColors.lightGreen;
                      } else if (data.category == 'Expense') {
                        return AppColors.lightRed;
                      } else if (data.category == 'Invest') {
                        return AppColors.darkGreen;
                      } else if (data.category == 'Tax') {
                        return Colors.orange.withValues(alpha: 0.5);
                      }
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: w,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.onSecondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(),
                    title: ChartTitle(
                      text: 'Income, Investment, Expense, Tax & Total Balance',
                      textStyle: AppStyles.headingPrimary(
                        context: context,
                        fontSize: 16,
                      ),
                    ),
                    series: [
                      SplineSeries<_ChartData, String>(
                        // LineSeries<_ChartData, String>(
                        dataSource: [
                          _ChartData('Income', totalIncome),
                          _ChartData('Invest', totalInvestment),
                          _ChartData('Expense', totalExpense),
                          _ChartData('Tax', totalTax),
                          _ChartData('Total Bal', totalBalance),
                        ],
                        xValueMapper: (_ChartData data, _) => data.category,
                        yValueMapper: (_ChartData data, _) => data.amount,
                        color: Colors.blue,
                        name: 'Income/Expense/Investment/Tax/Balance',
                      ),
                    ],
                  ),
                  spacerH(),
                  SizedBox(
                    height: 550,
                    width: w,
                    child: BarChart(
                      BarChartData(
                        maxY: [
                              totalTax,
                              totalIncome,
                              totalInvestment,
                              totalExpense,
                              totalBalance
                            ].map((e) => e < 0 ? -e : e).reduce(max) +
                            500,
                        titlesData: FlTitlesData(show: true),
                        borderData: FlBorderData(show: true),
                        gridData: FlGridData(show: true),
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: totalIncome,
                                color: Colors.greenAccent,
                                width: 20,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: totalInvestment,
                                color: Colors.green,
                                width: 20,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                toY: totalExpense,
                                color: Colors.red,
                                width: 20,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 3,
                            barRods: [
                              BarChartRodData(
                                toY: totalTax,
                                color: Colors.orange,
                                width: 20,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 4,
                            barRods: [
                              BarChartRodData(
                                toY: totalBalance,
                                color: Colors.blue,
                                width: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  spacerH(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Wrap(
                      runSpacing: 10,
                      spacing: 15,
                      children: chartInfo.map((e) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: e.color,
                              ),
                            ),
                            spacerW(5),
                            Text(
                              e.title,
                              style: AppStyles.descriptionPrimary(
                                context: context,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  spacerH(),
                ],
              ),
            ),
          ),
        ),
        spacerH(30),
      ],
    );
  }

  ///More Apps Carousel
  Widget moreAppsCarousel(
      {required double w, required BuildContext context, required theme}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30.0),
          child: Text(
            "More Apps",
            style: AppStyles.headingPrimary(
              context: context,
            ),
          ),
        ),
        spacerH(),
        ReusableMoreAppsCarousel(
          w: w,
        ),
      ],
    );
  }

  ///PlayStore rating widget
  Widget playStoreRating([final w, final theme]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
            width: w,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: theme.onSecondary,
              borderRadius: BorderRadius.circular(15),
              // border: Border.all(
              //   color: theme.primary,
              //   width: 2,
              // ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Enjoy BudgetFlow?",
                  style: AppStyles.headingPrimary(
                    context: context,
                    fontSize: 26,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                spacerH(15),
                Text(
                  "Take a minute to provide your review and rating on the Play Store.",
                  style: AppStyles.descriptionPrimary(
                      context: context, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                spacerH(15),
                PlatyStoreRating(
                  url: Constants.budgetFlowUrl,
                ),
                spacerH(15),
                InkWell(
                  onTap: () {
                    // setState(() {
                    //   isAlreadyRated = true;
                    // });
                    //
                    // prefsHelper.setBoolValue(PrefsKeys.alreadyRated, true);
                  },
                  child: Text(
                    "I have already rated",
                    style: AppStyles.descriptionPrimary(
                      context: context,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  ///Social media Connection
  Widget socialMediaConnections([final w, final theme]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
            width: w,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: theme.onSecondary,
              borderRadius: BorderRadius.circular(15),
              // border: Border.all(
              //   color: theme.primary,
              //   width: 2,
              // ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "We're on Social Media",
                  style: AppStyles.headingPrimary(
                    context: context,
                  ),
                ),
                spacerH(10),
                Text(
                  "Follow us on social media to get the latest updates and offers",
                  style: AppStyles.descriptionPrimary(context: context),
                ),
                spacerH(15),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ReusableIconButton(
                            title: 'Youtube',
                            icon: FontAwesomeIcons.youtube,
                            colors: AppGradients.youtubeGradient,
                            url: Constants.youtubeLink,
                            spacerWidth: 15,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: ReusableIconButton(
                            title: 'Instagram',
                            icon: FontAwesomeIcons.instagram,
                            colors: AppGradients.instagramGradient,
                            url: Constants.instagramLink,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ReusableIconButton(
                            title: 'Facebook',
                            icon: FontAwesomeIcons.facebook,
                            colors: AppGradients.facebookGradient,
                            url: Constants.facebookLink,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: ReusableIconButton(
                            title: 'WhatsApp',
                            icon: FontAwesomeIcons.whatsapp,
                            colors: AppGradients.greenGradient,
                            url: Constants.whatsAppChannelLink,
                            socialIconSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.category, this.amount);

  final String category;
  final double amount;
}

class CharInfo {
  final String title;
  final Color color;

  CharInfo({
    required this.title,
    required this.color,
  });
}

List<CharInfo> chartInfo = [
  CharInfo(title: "Income", color: Colors.greenAccent),
  CharInfo(title: "Investment", color: Colors.green),
  CharInfo(title: "Expense", color: Colors.red),
  CharInfo(title: "Tax", color: Colors.orange),
  CharInfo(title: "Total Balance", color: Colors.blue),
];
