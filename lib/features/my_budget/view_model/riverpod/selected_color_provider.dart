import 'dart:ui';
import 'package:budgify/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var selectedColorProvider = StateProvider<Color>((ref) => AppColors.lightGreen);

