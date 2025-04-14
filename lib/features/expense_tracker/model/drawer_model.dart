import 'package:flutter/material.dart';

class DrawerModel {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  DrawerModel(
      {required this.title, required this.icon, required this.onTap});
}
