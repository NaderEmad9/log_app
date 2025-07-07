import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../log_upload/domain/log_file.dart';
import '../data/log_parser.dart';
import '../domain/log_entry.dart';

final logEntriesProvider = Provider.family<List<LogEntry>, LogFile>((ref, logFile) {
  return LogParser.parse(logFile.content);
});
