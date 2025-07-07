enum LogLevel { error, warning, success, unknown }

class LogEntry {
  final DateTime? timestamp;
  final LogLevel level;
  final String host;
  final String message;

  LogEntry({this.timestamp, required this.level, required this.host, required this.message});
}
