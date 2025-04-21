enum TransactionType {
  allTransactions,
  transactionsNewestToOldest,
  transactionsOldestToNewest,
  mostExpensive,
  leastExpensive,
  // onlyIncome,
  // onlyExpense,
  mostIncome,
  leastIncome;

  String get value {
    switch (this) {
      case TransactionType.allTransactions:
        return 'All Transactions';
      case TransactionType.transactionsNewestToOldest:
        return 'Transactions: Latest First';
      case TransactionType.transactionsOldestToNewest:
        return 'Transactions: Oldest First';
      case TransactionType.mostExpensive:
        return 'Most Expensive First';
      case TransactionType.mostIncome:
        return 'Highest Income First';
      case TransactionType.leastExpensive:
        return 'Least Expensive First';
      case TransactionType.leastIncome:
        return 'Lowest Income First';
    // case TransactionType.mostExpensive:
    //   return 'Most to Least Expensive';
    // case TransactionType.mostIncome:
    //   return 'Most to Least Income';
    // case TransactionType.leastExpensive:
    //   return 'Least to Most Expensive';
    // case TransactionType.leastIncome:
    //   return 'Least to Most Income';
    // case TransactionType.onlyIncome:
    //   return 'Only Income';
    // case TransactionType.onlyExpense:
    //   return 'Only Expense';
    }
  }
}
