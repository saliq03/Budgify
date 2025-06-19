enum FilterType{
  dateWise,
  categoryWise;

  String get stringValue {
    switch (this) {
      case FilterType.dateWise:
        return 'Date Wise';
      case FilterType.categoryWise:
        return 'Category Wise';
    }
  }

  int get intValue {
    switch (this) {
      case FilterType.dateWise:
        return 0;
      case FilterType.categoryWise:
        return 1;
    }
  }
}