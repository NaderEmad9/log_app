import '../domain/log_entry.dart';

class LogParser {
  // Support both: 13 Jun 04:49:17 ... and Jun 13 04:49:17 ...
  static final RegExp _logRegExpDayFirst = RegExp(r"^(\d{1,2}) ([A-Za-z]{3}) (\d{2}:\d{2}:\d{2}) ([\w\-]+) ([A-Z]+): (.*)");
  static final RegExp _logRegExpMonthFirst = RegExp(r"^([A-Za-z]{3}) (\d{1,2}) (\d{2}:\d{2}:\d{2}) ([\w\-]+) ([A-Z]+): (.*)");

  static List<LogEntry> parse(String content) {
    final lines = content.split('\n');
    return lines.where((line) => line.trim().isNotEmpty).map((line) {
      final trimmed = line.trim();
      RegExpMatch? match = _logRegExpDayFirst.firstMatch(trimmed);
      int? day;
      String? monthStr;
      String? timeStr;
      String host = '';
      String levelStr = '';
      String message = trimmed;
      DateTime? timestamp;
      if (match != null) {
        day = int.tryParse(match.group(1) ?? '');
        monthStr = match.group(2);
        timeStr = match.group(3);
        host = match.group(4) ?? '';
        levelStr = match.group(5) ?? '';
        message = match.group(6) ?? '';
      } else {
        match = _logRegExpMonthFirst.firstMatch(trimmed);
        if (match != null) {
          monthStr = match.group(1);
          day = int.tryParse(match.group(2) ?? '');
          timeStr = match.group(3);
          host = match.group(4) ?? '';
          levelStr = match.group(5) ?? '';
          message = match.group(6) ?? '';
        }
      }
      if (day != null && monthStr != null && timeStr != null) {
        final month = _monthFromShort(monthStr);
        final now = DateTime.now();
        timestamp = DateTime(now.year, month, day,
            int.parse(timeStr.split(':')[0]),
            int.parse(timeStr.split(':')[1]),
            int.parse(timeStr.split(':')[2]));
      }
      final level = _parseLevel(levelStr, message, trimmed);
      return LogEntry(timestamp: timestamp, level: level, host: host, message: message);
    }).toList();
  }

  static int _monthFromShort(String short) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months.indexOf(short) + 1;
  }

  static LogLevel _parseLevel(String? level, String message, String fullLine) {
    final text = ((level ?? '') + ' ' + message + ' ' + fullLine).toLowerCase();
    if (RegExp(r'\berror\b|\bcritical\b|\bfail\b').hasMatch(text)) {
      return LogLevel.error;
    } else if (RegExp(r'\bwarn\b|\bwarning\b').hasMatch(text)) {
      return LogLevel.warning;
    } else if (RegExp(r'\bsuccess\b|\binfo\b|\bok\b|\bcompleted\b|\bdebug\b').hasMatch(text)) {
      return LogLevel.success;
    } else {
      return LogLevel.unknown;
    }
  }
}
