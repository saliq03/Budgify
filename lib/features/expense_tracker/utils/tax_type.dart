enum TaxType {
  taxLatestFirst,
  taxOldestFirst,
  taxHighToLow,
  taxLowToHigh;

  String get value {
    switch (this) {
      case TaxType.taxLatestFirst:
        return 'Tax: Latest First';
      case TaxType.taxOldestFirst:
        return 'Tax: Oldest First';
      case TaxType.taxHighToLow:
        return 'Tax: High to Low';
      case TaxType.taxLowToHigh:
        return 'Tax: Low to High';
    }
  }
}
