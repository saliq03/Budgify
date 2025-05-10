part of 'expense_tracker_home_page.dart';

class ExpenseTrackerPage extends ConsumerStatefulWidget {
  const ExpenseTrackerPage({super.key});

  @override
  ConsumerState<ExpenseTrackerPage> createState() => _ExpenseTrackerPageState();
}

class _ExpenseTrackerPageState extends ConsumerState<ExpenseTrackerPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(expenseTrackerProviderOriginal.notifier).init();
    });
    //   Future.microtask(() {
    //     ref.read(expenseTrackerProvider.notifier).init();
    //   });
  }

  double getDoubleValue(String value) {
    return double.tryParse(value) ?? 0.0;
  }

  void showCurrencyPickerDialog() {
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      onSelect: (Currency currency) {
        ref.read(currencyProvider.notifier).state =
            CurrencyModel.fromJson(currency);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    final currency = ref.watch(currencyProvider).symbol;
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spacerH(),
                TransactionFilter(),
                spacerH(10),
                // CurrencyPicker(),
                // spacerH(10),
                cardSection(w, context, currency),
                spacerH(10),
                DateFilter(),
                spacerH(),
                transactionSection(),
                spacerH(10),
                TransactionInfo(),
              ],
            ),
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReusableFloatingActionButton(
              iconSize: 30,
                onTap: () {
                  Navigator.pushNamed(context, Paths.expenseManagementPage,
                      arguments: TrackerModel(
                          title: '',
                          date: '',
                          amount: null,
                          trackerCategory: ExpenseType.expense.intValue,
                          percentage: 0));
                },
                icon: Icons.arrow_circle_down_outlined,
                colors: AppGradients.youtubeGradient),
            spacerW(10),
            ReusableFloatingActionButton(
                iconSize: 30,
                onTap: () {
                  Navigator.pushNamed(context, Paths.expenseManagementPage,
                      arguments: TrackerModel(
                          title: '',
                          date: '',
                          amount: null,
                          trackerCategory: ExpenseType.income.intValue,
                          percentage: 0));
                },
                icon: Icons.arrow_circle_up_outlined,
                colors: AppGradients.greenGradient),
          ],
        )
    );
  }

  Widget cardSection(
      final double w, final BuildContext context, final currency) {
    final transactionInfo =
        ref.watch(filteredTransactionProvider).transactionModel;
    double totalBalance = getDoubleValue(transactionInfo.totalBalance),
        totalIncome = getDoubleValue(transactionInfo.income),
        totalExpense = getDoubleValue(transactionInfo.expense);

    final zeroBalance = totalIncome == 0 && totalExpense == 0;
    final zeroIncome = totalIncome == 0;
    final zeroExpense = totalExpense == 0;
    final positiveBalance = totalBalance >= 0;
    final totalBalanceColor = zeroBalance
        ? Colors.white
        : positiveBalance
            ? AppColors.themeLight
            : AppColors.youtubeRed;;
    final incomeColor = zeroIncome ? Colors.white : AppColors.themeLight;
    final expenseColor = zeroExpense ? Colors.white : AppColors.youtubeRed;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: w,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
            // gradient: LinearGradient(
            //     colors: AppGradients.greenGradient,
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Balance",
              style: AppStyles.descriptionPrimary(
                  context: context, color: totalBalanceColor),
            ),
            spacerH(5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!zeroBalance)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Icon(
                      positiveBalance ? Icons.add : Icons.remove,
                      color: totalBalanceColor,
                      size: 20,
                    ),
                  ),
                spacerW(2),
                Flexible(
                    child: InkWell(
                  onTap: showCurrencyPickerDialog,
                  child: Text(
                    "$currency${totalBalance.abs()}",
                    style: AppStyles.headingPrimary(
                        context: context,
                        fontSize: 30,
                        color: totalBalanceColor),
                  ),
                )),
              ],
            ),
            spacerH(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ReusableCardDetails(
                    color: incomeColor,
                    text: "Income",
                    icon: Icons.arrow_circle_up_outlined,
                    amount: "$currency$totalIncome",
                    isShow: !zeroIncome,
                    onTap: showCurrencyPickerDialog,
                  ),
                ),
                spacerW(),
                Expanded(
                  child: ReusableCardDetails(
                    color: expenseColor,
                    text: "Expense",
                    icon: Icons.arrow_circle_down_outlined,
                    amount: "$currency${totalExpense.abs()}",
                    isShow: !zeroExpense,
                    isExpense: true,
                    onTap: showCurrencyPickerDialog,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget transactionSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            "Recent Transactions",
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