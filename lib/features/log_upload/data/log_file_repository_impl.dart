import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../domain/log_file.dart';
import '../domain/log_file_repository.dart';

class LogFileRepositoryImpl implements LogFileRepository {
  @override
  Future<List<LogFile>> pickAndReadLogFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['log', 'txt'],
    );
    if (result == null) return [];
    final files = result.paths.whereType<String>().toList();
    return Future.wait(files.map((path) async {
      final file = File(path);
      final content = await file.readAsString();
      return LogFile(name: file.uri.pathSegments.last, path: path, content: content);
    }));
  }
}
