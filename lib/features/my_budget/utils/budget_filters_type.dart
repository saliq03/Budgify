enum Filter1Type {
  title,
  date;

  String get value {
    switch (this) {
      case Filter1Type.title:
        return 'Title';
      case Filter1Type.date:
        return 'Date';
    }
  }
}

enum Filter2Type {
  ascending,
  descending;

  String get value {
    switch (this) {
      case Filter2Type.ascending:
        return 'Ascending';
      case Filter2Type.descending:
        return 'Descending';
    }
  }
}
