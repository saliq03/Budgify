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
