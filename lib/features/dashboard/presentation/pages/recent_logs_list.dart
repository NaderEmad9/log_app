import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../log_upload/application/log_file_provider.dart';
import '../../../log_upload/domain/log_file.dart';
import '../../../log_view/data/log_parser.dart';
import '../../../log_view/domain/log_entry.dart';

class RecentLogsList extends ConsumerWidget {
  const RecentLogsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logFiles = ref.watch(logFilesProvider);
    final List<_RecentLog> recentLogs = [];
    for (final file in logFiles) {
      final entries = LogParser.parse(file.content);
      for (final entry in entries) {
        if (entry.timestamp != null) {
          recentLogs.add(_RecentLog(file: file, entry: entry));
        }
      }
    }
    recentLogs.sort((a, b) => b.entry.timestamp!.compareTo(a.entry.timestamp!));
    final topLogs = recentLogs.take(10).toList();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recent Log Entries', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (topLogs.isEmpty)
              const Text('No recent logs.'),
            ...topLogs.map((log) => ListTile(
                  leading: Icon(Icons.bubble_chart, color: _levelColor(log.entry.level, context)),
                  title: Text(log.entry.message, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('${log.entry.timestamp} — ${log.file.name}'),
                  trailing: Text(log.entry.level.name.toUpperCase()),
                )),
          ],
        ),
      ),
    );
  }

  Color _levelColor(LogLevel level, BuildContext context) {
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
}

class _RecentLog {
  final LogFile file;
  final LogEntry entry;
  _RecentLog({required this.file, required this.entry});
}
