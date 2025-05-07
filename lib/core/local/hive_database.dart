import 'package:hive/hive.dart';

class HiveDatabase {
  HiveDatabase._privateConstructor();
  static final HiveDatabase _instance = HiveDatabase._privateConstructor();

  factory HiveDatabase() {
    return _instance;
  }

  static const String _boxName = 'app_data';
  static const String allTransactionFilterBox = 'all_transaction_box';
  static const String startDateBox = 'start_date_box';
  static const String currentCurrencyBox = 'current_currency_box';
  static const String investmentFilterBox = 'investment_filter_box';
  static const String taxFilterBox = 'tax_filter_box';

  Box<dynamic>? _box;

  // /// get the box
  // Box<dynamic>? get box => _box;


  /// Initialize the box
  Future<Box<dynamic>> init() async {
    _box ??= await Hive.openBox(_boxName);
    return _box!;
  }

  /// Put data into the box
  Future<void> put(String key, dynamic value) async {
    Box<dynamic> box = await init();
    box.put(key, value);
  }

  /// Get data from the box
  Future<void> getValue(String key) async {
    Box<dynamic> box = await init();
    return box.get(key);
  }


  /// Delete all the key-value pairs in the box
  Future<void> clear() async {
    await _box?.clear();
  }


  ///  Closes the box and removes it from memory.
  Future<void> close() async {
    await _box?.close();
    _box = null;
  }
}
