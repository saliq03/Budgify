import 'dart:io';
import 'package:budgify/features/expense_tracker/model/tracker_model.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String trackerTableName = "tracker";
  static const String columnTrackerId = "t_id";
  static const String columnTrackerTitle = "t_title";
  static const String columnTrackerDate = "t_date";
  static const String columnTrackerAmount = "t_amount";
  static const String columnIsExpense = "is_expense";

  // Private constructor
  DBHelper._private();

  // Singleton instance
  static final DBHelper _instance = DBHelper._private();

  // Factory constructor
  factory DBHelper() => _instance;

  Database? _myDB;

  Future<Database> getDB() async {
    return _myDB ??= await openDB();
  }

  Future<Database> openDB() async {
    Directory myDir = await getApplicationDocumentsDirectory();
    String dbPath = join(myDir.path, "expenseT.db");

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $trackerTableName (
            $columnTrackerId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTrackerTitle TEXT,
            $columnTrackerDate TEXT,
            $columnTrackerAmount REAL,
            $columnIsExpense INTEGER
          )
        ''');

        await db.insert(trackerTableName, {
          columnTrackerTitle: "Sample Income",
          columnTrackerDate: DateTime.now().toString().split(" ")[0],
          columnTrackerAmount: 2334.0,
          columnIsExpense: 0
        });

        await db.insert(trackerTableName, {
          columnTrackerTitle: "Sample Expense",
          columnTrackerDate: DateTime.now().toString().split(" ")[0],
          columnTrackerAmount: 23232.0,
          columnIsExpense: 1
        });
      },
    );
  }

  Future<bool> addTrackerData(TrackerModel tracker) async {
    try {
      Database mDB = await getDB();
      int rowsEffected = await mDB.insert(trackerTableName, tracker.toMap());
      return rowsEffected > 0;
    } catch (e) {
      if (kDebugMode) {
        print("Error in adding data: $e");
      }
      return false;
    }
  }

  Future<List<TrackerModel>> fetchTrackerData() async {
    try {
      Database mDB = await getDB();
      List<Map<String, dynamic>> trackerData =
          await mDB.query(trackerTableName);
      return trackerData.map((e) => TrackerModel.fromMap(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error in fetching data: $e");
      }
      return [];
    }
  }

  Future<bool> updateTrackerData(TrackerModel tracker) async {
    try {
      Database mDB = await getDB();
      int rowsEffected = await mDB.update(trackerTableName, tracker.toMap(),
          where: "$columnTrackerId = ?", whereArgs: [tracker.id]);
      return rowsEffected > 0;
    } catch (e) {
      if (kDebugMode) {
        print("Error in updating data: $e");
      }
      return false;
    }
  }

  Future<bool> deleteTrackerData(int id) async {
    try {
      Database mDB = await getDB();
      int rowsEffected = await mDB.delete(trackerTableName,
          where: "$columnTrackerId = ?", whereArgs: [id]);
      return rowsEffected > 0;
    } catch (e) {
      if (kDebugMode) {
        print("Error in deleting data: $e");
      }
      return false;
    }
  }
}
