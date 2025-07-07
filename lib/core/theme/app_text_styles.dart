import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle title = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  static const TextStyle filterLabel = TextStyle(fontWeight: FontWeight.w700, fontSize: 16);
  static final TextStyle filterValue = TextStyle(color: AppColors.blueGrey, fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 0.2);
  static final TextStyle button = TextStyle(color: AppColors.white, fontWeight: FontWeight.w600);
  static final TextStyle dateButton = TextStyle(color: AppColors.white, fontWeight: FontWeight.w500);
  static final TextStyle okButton = TextStyle(color: AppColors.blueAccent, fontWeight: FontWeight.bold);
  static final TextStyle cancelButton = TextStyle(color: AppColors.white);
  static final TextStyle dropdown = TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 16);
  static final TextStyle dropdownLabel = TextStyle(color: AppColors.white70, fontWeight: FontWeight.w500, fontSize: 13);
}
