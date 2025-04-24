enum TransactionType {
  allTransactions,
  excludingInvestmentAndTax,
  transactionsNewestToOldest,
  transactionsOldestToNewest,
  mostExpensive,
  leastExpensive,
  mostIncome,
  leastIncome;

  String get value {
    switch (this) {
      case TransactionType.allTransactions:
        return 'All Transactions';
      case TransactionType.excludingInvestmentAndTax:
        return 'Excluding Investment & Tax';
      case TransactionType.transactionsNewestToOldest:
        return 'Transactions: Latest First';
      case TransactionType.transactionsOldestToNewest:
        return 'Transactions: Oldest First';
      case TransactionType.mostExpensive:
        return 'Expenses: High to Low';
      case TransactionType.leastExpensive:
        return 'Expense: Low to High';
      case TransactionType.mostIncome:
        return 'Income: High to Low';
      case TransactionType.leastIncome:
        return 'Income: Low to High';
    }
  }
}
