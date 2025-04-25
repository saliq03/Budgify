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
              TaxFilter(),
              spacerH(10),
              ReusableCardWidget(
                icon: FontAwesomeIcons.sackDollar,
                section1: CardModel(name: "Net Amount\n(After Tax)", value: taxModel.netAmountAfterTax ),
                section2: CardModel(name: "Total Tax", value: taxModel.totalTax),
                section3: CardModel(name: "Taxable Amount", value: taxModel.taxableAmount),
                section4: CardModel(name: "Tax %", value: taxModel.taxPercentage),
              ),
              spacerH(10),
              DateFilter(),
              spacerH(),
              taxHistory(context),
              spacerH(10),
              ReusableInfo(isTaxPage: true,
                isScrollable: false,)
            ],
          ),
        ),
      ),
    );
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
          Navigator.pushNamed(context, Paths.allTransactionPage);
        })
      ],
    );
  }
}
