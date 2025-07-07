import 'package:flutter/material.dart';
import '../../../log_view/domain/log_entry.dart';

Color recentLogLevelColor(LogLevel level, BuildContext context) {
  switch (level) {
    case LogLevel.error:
      return Colors.redAccent;
    case LogLevel.warning:
      return Colors.orangeAccent;
    case LogLevel.success:
      return Colors.blueAccent;
    default:
      return Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
  }
}
