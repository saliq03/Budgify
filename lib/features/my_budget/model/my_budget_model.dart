import 'package:flutter/material.dart';
import '../../../core/local/db_helper.dart';
import '../../../core/theme/app_colors.dart';

class MyBudgetModel {
  final int? id;
  final String title;
  final String date;
  final String description;
  final Color color;

  MyBudgetModel({
    this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.color,
  });

  factory MyBudgetModel.fromMap(Map<String, dynamic> map) {
    int intColor = map[DBHelper.columnMyBudgetColor];
    Color color = Colors.transparent;

    if (intColor == 0) {
      color = AppColors.lightGreen;
    } else if (intColor == 1) {
      color = AppColors.redPink;
    } else if (intColor == 2) {
      color = AppColors.lightPurple;
    } else if (intColor == 3) {
      color = AppColors.redOrange;
    } else if (intColor == 4) {
      color = AppColors.violet;
    } else if(intColor == 5) {
      color = AppColors.lightGreen2;
    } else { // intColor == 6
      color = AppColors.lightBlue;
    }

    return MyBudgetModel(
      id: map[DBHelper.columnMyBudgetId],
      title: map[DBHelper.columnMyBudgetTitle],
      date: map[DBHelper.columnMyBudgetDate],
      description: map[DBHelper.columnMyBudgetDescription],
      color: color,
    );
  }

  Map<String, dynamic> toMap() {
    int intColor = 0;
    if (color == AppColors.lightGreen) {
      intColor = 0;
    } else if (color == AppColors.redPink) {
      intColor = 1;
    } else if (color == AppColors.lightPurple) {
      intColor = 2;
    } else if (color == AppColors.redOrange) {
      intColor = 3;
    } else if (color == AppColors.violet) {
      intColor = 4;
    } else if (color == AppColors.lightGreen2) {
      intColor = 5;
    } else {
      intColor = 6;
    }

    return {
      DBHelper.columnMyBudgetTitle: title,
      DBHelper.columnMyBudgetDate: date,
      DBHelper.columnMyBudgetDescription: description,
      DBHelper.columnMyBudgetColor: intColor,
    };
  }
}
