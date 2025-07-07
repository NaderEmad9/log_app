import '../../../log_upload/domain/log_file.dart';
import '../../../log_view/domain/log_entry.dart';

class RecentLog {
  final LogFile file;
  final LogEntry entry;
  RecentLog({required this.file, required this.entry});
}
