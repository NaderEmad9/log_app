import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../log_upload/application/log_file_provider.dart';
import '../../../log_view/data/log_parser.dart';
import 'recent_log.dart';
import 'recent_log_level_color.dart';

class RecentLogsList extends ConsumerWidget {
  const RecentLogsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logFiles = ref.watch(logFilesProvider);
    final List<RecentLog> recentLogs = [];
    for (final file in logFiles) {
      final entries = LogParser.parse(file.content);
      for (final entry in entries) {
        if (entry.timestamp != null) {
          recentLogs.add(RecentLog(file: file, entry: entry));
        }
      }
    }
    recentLogs.sort((a, b) => b.entry.timestamp!.compareTo(a.entry.timestamp!));
    final topLogs = recentLogs.take(10).toList();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 120), // Ensures bottom gap
          children: [
            const Text('Recent Log Entries', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (topLogs.isEmpty)
              const Text('No recent logs.'),
            ...topLogs.map((log) => ListTile(
                  leading: Icon(Icons.bubble_chart, color: recentLogLevelColor(log.entry.level, context)),
                  title: Text(log.entry.message, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('${log.entry.timestamp} — ${log.file.name}'),
                  trailing: Text(log.entry.level.name.toUpperCase()),
                )),
          ],
        ),
      ),
    );
  }
}
