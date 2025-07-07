import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../log_upload/application/log_file_provider.dart';
import '../../../log_view/data/log_parser.dart';
import '../../../log_view/domain/log_entry.dart';
import '../widgets/error_stat_tile.dart';
import '../widgets/stat_card.dart';
import '../widgets/stat_tile.dart';
import '../widgets/total_files_tile.dart';

class DashboardStats extends ConsumerWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logFiles = ref.watch(logFilesProvider);
    int errorCount = 0, warningCount = 0, infoCount = 0, total = 0;
    int errorFiles = 0, warningFiles = 0, infoFiles = 0;
    for (final file in logFiles) {
      final entries = LogParser.parse(file.content);
      bool hasError = false, hasWarning = false, hasInfo = false;
      for (final entry in entries) {
        switch (entry.level) {
          case LogLevel.error:
            errorCount++;
            hasError = true;
            break;
          case LogLevel.warning:
            warningCount++;
            hasWarning = true;
            break;
          case LogLevel.success:
            infoCount++;
            hasInfo = true;
            break;
          default:
            break;
        }
        total++;
      }
      if (hasError) errorFiles++;
      if (hasWarning) warningFiles++;
      if (hasInfo) infoFiles++;
    }
    final totalFiles = logFiles.length;
    final cardColor = const Color(0xFF0A1931); // very dark blue
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: StatCard(
              color: cardColor,
              child: TotalFilesTile(
                fileCount: totalFiles,
                timestampCount: total,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              color: cardColor,
              child: ErrorStatTile(
                count: errorCount,
                fileCount: errorFiles,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              color: cardColor,
              child: StatTile(
                label: 'Warnings',
                count: warningCount,
                color: Colors.orangeAccent,
                subtitle: 'includes WARN',
                fileCount: warningFiles,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              color: cardColor,
              child: StatTile(
                label: 'Success',
                count: infoCount,
                color: Colors.green,
                subtitle: 'includes INFO, OK, DEBUG',
                fileCount: infoFiles,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
