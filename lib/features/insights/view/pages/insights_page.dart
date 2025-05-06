import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:budgify/features/expense_tracker/viewmodel/riverpod/expense_tracker_notifier.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../shared/view/widgets/date_filter.dart';
import '../../../../shared/view/widgets/reusable_app_bar.dart';
import '../../../expense_tracker/viewmodel/riverpod/currency_provider.dart';

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
                      if (data.category.contains('Total Balance'))
                        return AppColors.themeDark;
                      if (data.category == 'Income')
                        return AppColors.lightGreen;
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
            spacerH(),
            playStoreRating(w),
            spacerH(),
            socialMediaConnections(w),
            spacerH(80)
          ],
        ),
      ),
    );
  }

  ///PlayStore rating widget
  Widget playStoreRating([final w,])
  {
    return Container(
        width: w,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Enjoy BudgetFlow?",
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              width: w * 0.75,
              child: const Text(
                "Take a minute to provide your review and rating on the Play Store.",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            PlayStoreRatingOrExerciseLevels(
              url: Constants.budgetFlowUrl,
            ),
            const SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: (){

              },
              child: const Text(
                "I have already rated",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ));
  }

  ///Social media Connection
  Widget socialMediaConnections([final w,])
  {
    return Container(
        width: w,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "We're on Social Media",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Follow us on social media to get the latest updates and offers",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SocialMediaIcons(
                        title: 'Youtube',
                        icon: FontAwesomeIcons.youtube,
                        colors:  AppGradients.youtubeGradient,
                        url: Constants.youtubeLink,
                        spacerWidth: 15,
                      ),
                    ),

                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: SocialMediaIcons(
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
                      child: SocialMediaIcons(
                        title: 'Facebook',
                        icon: FontAwesomeIcons.facebook,
                        colors: AppGradients.facebookGradient,
                        url:
                        "https://www.facebook.com/gravityclassesfoundation",
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: SocialMediaIcons(
                        title: 'WhatsApp',
                        icon: FontAwesomeIcons.whatsapp,
                        colors: AppGradients.greenGradient,
                        url:
                        "https://www.linkedin.com/company/gravity-classes/",
                        socialIconSize: 28,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}

class _ChartData {
  _ChartData(this.category, this.amount);

  final String category;
  final double amount;
}

class SocialMediaIcons extends StatelessWidget {
  final String title;
  final IconData icon;
  final String url;
  final double spacerWidth;
  final double socialMediaIconFontSize;
  final double socialIconSize;
  final List<Color> colors;

  const SocialMediaIcons(
      {super.key,
      required this.title,
      required this.icon,
      required this.colors,
      required this.url,
      this.spacerWidth = 10,
      this.socialMediaIconFontSize = 16,
      this.socialIconSize = 25});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4), // changes position of shadow
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            openUrl(url: url, context: context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: socialIconSize,
                ),
                SizedBox(
                  width: spacerWidth,
                ),
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlayStoreRatingOrExerciseLevels extends StatelessWidget {
  final String url;
  final int count;
  final double initialRating;
  final IconData icon;
  final double itemSize;
  final Color color;
  final bool ignoreGesture;

  const PlayStoreRatingOrExerciseLevels(
      {super.key,
      required this.url,
      this.count = 5,
      this.initialRating = 0,
      this.icon = Icons.star_border,
      this.color = Colors.amber,
      this.itemSize = 40,
      this.ignoreGesture = false});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RatingBar.builder(
      ignoreGestures: ignoreGesture,
      initialRating: initialRating,
      itemSize: itemSize,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: count,
      itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
      itemBuilder: (context, index) {
        return Icon(
          icon,
          color: color,
        );
      },
      onRatingUpdate: (rating) {
        if (rating < 5) {
          IconSnackBar.show(context,
              duration: const Duration(seconds: 2),
              label: "Thank you for your feedback",
              snackBarType: SnackBarType.success);
        } else {
          openUrl(url: url, context: context);
          IconSnackBar.show(context,
              duration: const Duration(seconds: 2),
              label: "Thank you for your feedback",
              snackBarType: SnackBarType.success);
        }
      },
    );
  }
}
