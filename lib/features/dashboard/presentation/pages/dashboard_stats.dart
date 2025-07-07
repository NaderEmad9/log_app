import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../log_upload/application/log_file_provider.dart';
import '../../../log_view/data/log_parser.dart';
import '../../../log_view/domain/log_entry.dart';

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
            child: _StatCard(
              color: cardColor,
              child: _TotalFilesTile(
                fileCount: totalFiles,
                timestampCount: total,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              color: cardColor,
              child: _ErrorStatTile(
                count: errorCount,
                fileCount: errorFiles,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              color: cardColor,
              child: _StatTile(
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
            child: _StatCard(
              color: cardColor,
              child: _StatTile(
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

class _ErrorStatTile extends StatelessWidget {
  final int count;
  final int fileCount;
  const _ErrorStatTile({required this.count, required this.fileCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ERROR', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
        const SizedBox(height: 2),
        Text('includes CRITICAL, FATAL', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
        const SizedBox(height: 2),
        Text('$count', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.redAccent)),
        const SizedBox(height: 2),
        Text('$fileCount files', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final String? subtitle;
  final int? fileCount;
  const _StatTile({required this.label, required this.count, required this.color, this.subtitle, this.fileCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: TextStyle(color: Colors.grey[400], fontSize: 14)),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
        ],
        const SizedBox(height: 2),
        Text('$count', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
        if (fileCount != null) ...[
          const SizedBox(height: 2),
          Text('$fileCount files', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
        ],
      ],
    );
  }
}

class _TotalFilesTile extends StatelessWidget {
  final int fileCount;
  final int timestampCount;
  const _TotalFilesTile({required this.fileCount, required this.timestampCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TOTAL FILES', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
        const SizedBox(height: 2),
        Text('All imported log files', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
        const SizedBox(height: 2),
        Text('$fileCount', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 2),
        Text('$timestampCount timestamps', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final Widget child;
  final Color color;
  const _StatCard({required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Align(
          alignment: Alignment.centerLeft,
          child: child,
        ),
      ),
    );
  }
}
