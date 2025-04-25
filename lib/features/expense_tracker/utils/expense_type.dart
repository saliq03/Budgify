enum ExpenseType {
  income,
  expense,
  investment,
  tax;

  String get value {
    switch (this) {
      case ExpenseType.income:
        return 'Income';
      case ExpenseType.expense:
        return 'Expense';
      case ExpenseType.investment:
        return 'Investment';
      case ExpenseType.tax:
        return 'Tax';
    }
  }

  int get intValue {
    switch (this) {
      case ExpenseType.income:
        return 0;
      case ExpenseType.expense:
        return 1;
      case ExpenseType.investment:
        return 2;
      case ExpenseType.tax:
        return 3;
    }
  }
}

// savings,
// loan,
// insurance,
// donation,
// subscription,
// entertainment,
// groceries,
// travel,

// case ExpenseType.savings:
//   return 'Savings';
// case ExpenseType.loan:
//   return 'Loan';
// case ExpenseType.insurance:
//   return 'Insurance';
// case ExpenseType.donation:
//   return 'Donation';
// case ExpenseType.subscription:
//   return 'Subscription';
// case ExpenseType.entertainment:
//   return 'Entertainment';
// case ExpenseType.groceries:
//   return 'Groceries';
// case ExpenseType.travel:
//   return 'Travel';


//enum InvestAndTaxType {
//   investmentAndTax,
//   onlyInvestment,
//   onlyTax,
//   allTransactions;
//
//   String get value {
//     switch (this) {
//       case InvestAndTaxType.investmentAndTax:
//         return 'Investment and Tax';
//       case InvestAndTaxType.onlyInvestment:
//         return 'Only Investment';
//       case InvestAndTaxType.onlyTax:
//         return 'Only Tax';
//       case allTransactions:
//         return 'All Transactions';
//     }
//   }
// }