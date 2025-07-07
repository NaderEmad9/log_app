import '../domain/log_file.dart';

abstract class LogFileRepository {
  Future<List<LogFile>> pickAndReadLogFiles();
}
