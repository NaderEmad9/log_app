import 'dart:io';
import '../domain/log_file.dart';

Future<List<LogFile>> droppedFilesToLogFiles(List<Uri> uris) async {
  final logFiles = <LogFile>[];
  for (final uri in uris) {
    try {
      final file = File(uri.toFilePath());
      if (file.existsSync() && (file.path.endsWith('.log') || file.path.endsWith('.txt'))) {
        final content = await file.readAsString();
        logFiles.add(LogFile(
          name: file.uri.pathSegments.last,
          path: file.path,
          content: content,
        ));
      }
    } catch (_) {}
  }
  return logFiles;
}
