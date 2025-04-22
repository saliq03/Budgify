enum ExpenseType {
  income,
  expense,
  investment,
  tax;
  // savings,
  // loan,
  // insurance,
  // donation,
  // subscription,
  // entertainment,
  // groceries,
  // travel,
  String get value{
    switch(this){
      case ExpenseType.income:
        return 'Income';
      case ExpenseType.expense:
        return 'Expense';
      case ExpenseType.investment:
        return 'Investment';
      case ExpenseType.tax:
        return 'Tax';
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
    }

}
}