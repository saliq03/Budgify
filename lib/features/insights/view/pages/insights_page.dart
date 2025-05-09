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

class InsightsPage extends ConsumerStatefulWidget {
  const InsightsPage({super.key});

  @override
  ConsumerState<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends ConsumerState<InsightsPage> {
  @override
  Widget build(BuildContext context) {
    final expenseData = ref.watch(expenseTrackerProvider);
    final totalBalance = expenseData.trackerCategory.totalIncome -
        expenseData.trackerCategory.totalExpense;
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
                      _ChartData('$currencySymbol Total Balance', totalBalance),
                      _ChartData(
                          'Income', expenseData.trackerCategory.totalIncome),
                      _ChartData(
                          'Expense', expenseData.trackerCategory.totalExpense),
                    ],
                    xValueMapper: (_ChartData data, _) => data.category,
                    yValueMapper: (_ChartData data, _) => data.amount,
                    pointColorMapper: (_ChartData data, _) {
                      if (data.category.contains('Total Balance')) {
                        return AppColors.themeDark;
                      }
                      if (data.category == 'Income') {
                        return AppColors.lightGreen;
                      }
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
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                title:
                    ChartTitle(text: 'Income, Expense, and Balance Over Time'),
                series: [
                  LineSeries<_ChartData, String>(
                    dataSource: [
                      _ChartData(
                          'Jan', expenseData.trackerCategory.totalIncome),
                      _ChartData(
                          'Feb', expenseData.trackerCategory.totalExpense),
                      _ChartData('Mar', totalBalance),
                    ],
                    xValueMapper: (_ChartData data, _) => data.category,
                    yValueMapper: (_ChartData data, _) => data.amount,
                    color: Colors.blue,
                    name: 'Income/Expense/Balance',
                  ),
                ],
              ),
            ),
            spacerH(30),
            moreAppsCarousel(w: w, context: context, theme: theme),
            spacerH(30),
            playStoreRating(w,theme),
            spacerH(30),
            socialMediaConnections(w,theme),
            spacerH(80)
          ],
        ),
      ),
    );
  }


  ///More Apps Carousel
  Widget moreAppsCarousel(
      {required double w, required BuildContext context, required theme})
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30.0),
          child: Text(
            "More Apps",
            style: AppStyles.headingPrimary(
                context: context,),
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
                      context: context,),
                ),
                spacerH(10),
                Text(
                  "Follow us on social media to get the latest updates and offers",
                  style: AppStyles.descriptionPrimary(
                      context: context),
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
                            url:Constants.whatsAppChannelLink,
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
