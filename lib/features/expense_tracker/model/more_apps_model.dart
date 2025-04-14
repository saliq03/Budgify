import 'package:flutter/material.dart';

class MoreAppsModel {
  final String title;
  final String image;
  final String description;
  final List<Color> colors;
  final String url;

  const MoreAppsModel(
      {required this.title,
      required this.image,
      required this.description,
      required this.colors,
      required this.url});
}
