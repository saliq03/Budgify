part of 'expense_tracker_home_page.dart';

class TaxPage extends ConsumerWidget {
  const TaxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taxModel = ref.watch(filteredTaxProvider).taxModel;
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                spacerH(),
                Row(
                  children: [
                    Expanded(flex: 3, child: TaxFilter()),
                    spacerW(10),
                    Expanded(child: FilterButton())
                  ],
                ),
                spacerH(10),
                ReusableCardWidget(
                  icon: Icons.receipt_long,
                  section1: CardModel(
                      name: "After Tax", value: taxModel.netAmountAfterTax),
                  section2: CardModel(
                      name: "Before Tax", value: taxModel.taxableAmount),
                  section3:
                      CardModel(name: "Total Tax", value: taxModel.totalTax),
                  section4:
                      CardModel(name: "Tax %", value: taxModel.taxPercentage),
                ),
                spacerH(10),
                DateFilter(),
                spacerH(),
                taxHistory(context),
                spacerH(10),
                ReusableInfo(
                  isTaxPage: true,
                  isScrollable: false,
                )
              ],
            ),
          ),
        ),
        floatingActionButton: ReusableFloatingActionButton(
            onTap: () {
              Navigator.pushNamed(context, Paths.expenseManagementPage,
                  arguments: TrackerModel(
                      title: '',
                      date: '',
                      amount: null,
                      chooseCategory: 15,
                      trackerCategory: ExpenseType.tax.intValue,
                      percentage: 0));
            },
            icon: Icons.receipt_long,
            colors: AppGradients.youtubeGradient));
  }

  Widget taxHistory(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            "Tax History",
            style: AppStyles.headingPrimary(context: context, fontSize: 19),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        spacerW(),
        ReusableOutlinedButton(onPressed: () {
          Navigator.pushNamed(context, Paths.investmentTaxHistoryPage,
              arguments: true);
        })
      ],
    );
  }
}
