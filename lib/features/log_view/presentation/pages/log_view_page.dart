import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../log_upload/domain/log_file.dart';
import '../../application/log_entries_provider.dart';
import '../../domain/log_entry.dart';
import '../widgets/log_level_filter_bar.dart';
import '../widgets/log_search_bar.dart';

class LogViewPage extends ConsumerStatefulWidget {
  final LogFile logFile;
  const LogViewPage({super.key, required this.logFile});

  @override
  ConsumerState<LogViewPage> createState() => _LogViewPageState();
}

class _LogViewPageState extends ConsumerState<LogViewPage> {
  String _search = '';
  LogLevel? _level;

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(logEntriesProvider(widget.logFile));
    final filtered = entries.where((e) {
      final matchesSearch = _search.isEmpty || e.message.toLowerCase().contains(_search.toLowerCase());
      final matchesLevel = _level == null || e.level == _level;
      return matchesSearch && matchesLevel;
    }).toList();
    return Scaffold(
      appBar: AppBar(title: Text(widget.logFile.name)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: LogSearchBar(
                    value: _search,
                    onChanged: (v) => setState(() => _search = v),
                  ),
                ),
                LogLevelFilterBar(
                  selected: _level,
                  onChanged: (v) => setState(() => _level = v),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No log entries found.'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final entry = filtered[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: ListTile(
                          leading: Icon(Icons.bubble_chart, color: _levelColor(entry.level, context)),
                          title: Text(entry.message),
                          subtitle: entry.timestamp != null ? Text(entry.timestamp.toString()) : null,
                          trailing: Text(entry.level.name.toUpperCase()),
                        ),
                      );
                    },
                  ),
          ),
        ],
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
