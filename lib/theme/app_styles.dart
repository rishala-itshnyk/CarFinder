import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  static const title = TextStyle(
    fontFamily: 'CarFinderFont',
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const subtitle = TextStyle(
    fontFamily: 'CarFinderFont',
    fontSize: 15,
    color: AppColors.grey,
  );

  static const body = TextStyle(
    fontFamily: 'CarFinderFont',
    fontSize: 14,
  );

  static const button = TextStyle(
    fontFamily: 'CarFinderFont',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
