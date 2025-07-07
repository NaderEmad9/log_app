import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/log_file_repository_impl.dart';
import '../domain/log_file.dart';
import '../domain/log_file_repository.dart';
import 'desktop_drop_utils.dart';

final logFileRepositoryProvider = Provider<LogFileRepository>((ref) => LogFileRepositoryImpl());

final logFilesProvider = StateNotifierProvider<LogFilesNotifier, List<LogFile>>((ref) {
  final repo = ref.watch(logFileRepositoryProvider);
  return LogFilesNotifier(repo);
});

class LogFilesNotifier extends StateNotifier<List<LogFile>> {
  final LogFileRepository _repo;
  LogFilesNotifier(this._repo) : super([]);

  /// Returns a list of duplicate file names if any, otherwise adds and returns null
  Future<List<String>?> pickAndAddFilesWithCheck() async {
    final files = await _repo.pickAndReadLogFiles();
    final existingPaths = state.map((f) => f.path).toSet();
    final duplicates = files.where((f) => existingPaths.contains(f.path)).map((f) => f.name).toList();
    final newFiles = files.where((f) => !existingPaths.contains(f.path)).toList();
    if (newFiles.isNotEmpty) state = [...newFiles, ...state];
    if (duplicates.isNotEmpty) return duplicates;
    return null;
  }

  void removeFile(LogFile file) {
    state = state.where((f) => f.path != file.path).toList();
  }

  void clear() => state = [];

  /// Returns a list of duplicate file names if any, otherwise adds and returns null
  Future<List<String>?> addDroppedFilesWithCheck(List droppedFiles) async {
    final uris = droppedFiles.map((f) => f is Uri ? f : Uri.file(f.path)).toList();
    final logFiles = await droppedFilesToLogFiles(uris);
    final existingPaths = state.map((f) => f.path).toSet();
    final duplicates = logFiles.where((f) => existingPaths.contains(f.path)).map((f) => f.name).toList();
    final newFiles = logFiles.where((f) => !existingPaths.contains(f.path)).toList();
    if (newFiles.isNotEmpty) state = [...newFiles, ...state];
    if (duplicates.isNotEmpty) return duplicates;
    return null;
  }
}
