import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppShadows {
  static const List<BoxShadow> accentGlow = [
    BoxShadow(
      color: AppColors.accentBorder,      // accent 30 %
      blurRadius: 40,
      spreadRadius: 5,
    ),
  ];

  static const List<BoxShadow> accentSubtle = [
    BoxShadow(
      color: AppColors.accentBorderLight, // accent 20 %
      blurRadius: 30,
      spreadRadius: 5,
    ),
  ];

  static const List<BoxShadow> bottomSheet = [
    BoxShadow(
      color: Color(0x339E9E9E),           // grey 20 %
      spreadRadius: 1,
      blurRadius: 10,
      offset: Offset(0, -3),
    ),
  ];
}
