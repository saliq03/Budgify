enum InvestmentType {
  investmentLatestFirst,
  investmentOldestFirst,
  investmentHighToLow,
  investmentLowToHigh;

  String get value {
    switch (this) {
      case InvestmentType.investmentLatestFirst:
        return 'Investment: Latest First';
      case InvestmentType.investmentOldestFirst:
        return 'Investment: Oldest First';
      case InvestmentType.investmentHighToLow:
        return 'Investment: High to Low';
      case InvestmentType.investmentLowToHigh:
        return 'Investment: Low to High';
    }
  }
}
