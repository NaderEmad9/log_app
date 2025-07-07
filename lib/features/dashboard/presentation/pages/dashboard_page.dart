import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'dashboard_stats.dart';
import '../../../log_upload/application/log_file_provider.dart';
import '../../../log_view/application/log_entries_provider.dart';
import '../../../log_view/domain/log_entry.dart';
import '../../../log_view/presentation/widgets/log_level_filter_bar.dart';
import '../../../log_view/presentation/widgets/log_search_bar.dart';
import '../../../log_upload/domain/log_file.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/date_filter_bar.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        // No leading button for now
        title: const Text('Log Analyzer Dashboard'),
        surfaceTintColor: Colors.transparent, // Make app bar background transparent
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface,
        elevation: 0, // Keep app bar visually static
      ),
      body: const _DashboardBody(),
    );
  }
}

class DashboardFilesList extends ConsumerStatefulWidget {
  final List<LogFile> files;
  final String search;
  final LogLevel? level;
  final DateTime? startDate;
  final DateTime? endDate;
  const DashboardFilesList({super.key, required this.files, required this.search, required this.level, this.startDate, this.endDate});

  @override
  ConsumerState<DashboardFilesList> createState() => _DashboardFilesListState();
}

class _DashboardFilesListState extends ConsumerState<DashboardFilesList> {
  final Map<String, bool> _expanded = {};

  void _deleteFile(LogFile file) {
    ref.read(logFilesProvider.notifier).removeFile(file);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.files.map((file) {
        final entries = ref.watch(logEntriesProvider(file));
        final filtered = entries.where((e) {
          final matchesSearch = widget.search.isEmpty || e.message.toLowerCase().contains(widget.search.toLowerCase());
          final matchesLevel = widget.level == null || e.level == widget.level;
          final matchesDate = (widget.startDate == null || (e.timestamp != null && !e.timestamp!.isBefore(widget.startDate!))) &&
                              (widget.endDate == null || (e.timestamp != null && !e.timestamp!.isAfter(widget.endDate!)));
          return matchesSearch && matchesLevel && matchesDate;
        }).toList();
        final isExpanded = _expanded[file.path] ?? false;
        int errorCount = 0, warningCount = 0, infoCount = 0;
        DateTime? minTime, maxTime;
        for (final e in entries) {
          switch (e.level) {
            case LogLevel.error:
              errorCount++;
              break;
            case LogLevel.warning:
              warningCount++;
              break;
            case LogLevel.success:
              infoCount++;
              break;
            default:
              break;
          }
          if (e.timestamp != null) {
            if (minTime == null || e.timestamp!.isBefore(minTime)) minTime = e.timestamp;
            if (maxTime == null || e.timestamp!.isAfter(maxTime)) maxTime = e.timestamp;
          }
        }
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Theme.of(context).cardTheme.color,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(file.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _badge('${errorCount} Errors', Colors.redAccent),
                              _badge('${warningCount} Warnings', Colors.amber),
                              _badge('${infoCount} Success', Colors.green),
                              if (entries.isNotEmpty)
                                _badge('${entries.length} timestamps', Colors.blueGrey),
                            ],
                          ),
                          if (minTime != null && maxTime != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text('Time range: ${_formatTime(minTime)} - ${_formatTime(maxTime)}', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                          tooltip: isExpanded ? 'Collapse' : 'Expand',
                          onPressed: () => setState(() => _expanded[file.path] = !isExpanded),
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.trash2, color: Colors.redAccent),
                          tooltip: 'Delete file',
                          onPressed: () => _deleteFile(file),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isExpanded)
                _LogLinesArea(entries: filtered, monthShort: _monthShort, iconForLevel: _iconForLevel, levelColor: _levelColor),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.month}/${dt.day}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }


  String _monthShort(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[(month - 1).clamp(0, 11)];
  }


  Color _levelColor(LogLevel level, BuildContext context) {
    switch (level) {
      case LogLevel.error:
        return Colors.redAccent;
      case LogLevel.warning:
        return Colors.orangeAccent;
      case LogLevel.success:
        return Colors.green;
      default:
        return Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    }
  }

  IconData _iconForLevel(LogLevel level) {
    switch (level) {
      case LogLevel.error:
        return LucideIcons.xCircle;
      case LogLevel.warning:
        return LucideIcons.alertTriangle;
      case LogLevel.success:
        return LucideIcons.checkCircle2;
      default:
        return LucideIcons.info;
    }
  }
}

class _DashboardBody extends ConsumerStatefulWidget {
  const _DashboardBody();

  @override
  ConsumerState<_DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends ConsumerState<_DashboardBody> {
  String _search = '';
  LogLevel? _level;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final logFiles = ref.watch(logFilesProvider);
    if (logFiles.isEmpty) {
      return Center(
        child: DropTarget(
          onDragDone: (details) async {
            final files = details.files;
            final duplicates = await ref.read(logFilesProvider.notifier).addDroppedFilesWithCheck(files);
            if (duplicates != null && duplicates.isNotEmpty) {
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (ctx) => Dialog(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('File(s) already exist', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 16),
                          Text(
                            'The following file(s) were already added and will not be added again:',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            duplicates.join(', '),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          ),
                          const SizedBox(height: 24),
                          OutlinedButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white, width: 1.5),
                              foregroundColor: Colors.blueAccent,
                              backgroundColor: Theme.of(context).cardTheme.color,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            ),
                            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            constraints: const BoxConstraints(minHeight: 420), // Increased minHeight for larger drop area
            decoration: ShapeDecoration(
              color: Theme.of(context).cardColor, // Use cardColor for background
              shape: _DashedBorder(
                color: const Color.fromARGB(255, 48, 85, 180),
                borderRadius: 12,
                dashWidth: 8,
                dashSpace: 6,
                strokeWidth: 2,
              ),
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                height: 420, // Match the minHeight for perfect centering
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.share, size: 64, color: const Color.fromARGB(255, 48, 85, 180)),
                      const SizedBox(height: 16),
                      const Text('Choose your log files', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      const Text('supports .log and .txt files', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.normal)),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        child: const Text('Choose Files', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColorLight,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20), // Increased vertical padding
                        ),
                        onPressed: () async {
                          final duplicates = await ref.read(logFilesProvider.notifier).pickAndAddFilesWithCheck();
                          if (duplicates != null && duplicates.isNotEmpty && context.mounted) {
                            showDialog(
                              context: context,
                              builder: (ctx) => Dialog(
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text('File(s) already exist', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                      const SizedBox(height: 16),
                                      Text(
                                        'The following file(s) were already added and will not be added again:',
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        duplicates.join(', '),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                      ),
                                      const SizedBox(height: 24),
                                      OutlinedButton(
                                        onPressed: () => Navigator.of(ctx).pop(),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Colors.white, width: 1.5),
                                          foregroundColor: Colors.blueAccent,
                                          backgroundColor: Theme.of(context).cardColor,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                        ),
                                        child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const DashboardStats(),
        DateFilterBar(
          startDate: _startDate,
          endDate: _endDate,
          onStartDateChanged: (date) => setState(() => _startDate = date),
          onEndDateChanged: (date) => setState(() => _endDate = date),
          onClear: (_startDate != null || _endDate != null)
              ? () => setState(() {
                  _startDate = null;
                  _endDate = null;
                })
              : null,
        ),
        // Add New File button centered alone after date filter
        if (logFiles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    final duplicates = await ref.read(logFilesProvider.notifier).pickAndAddFilesWithCheck();
                    if (duplicates != null && duplicates.isNotEmpty && context.mounted) {
                      showDialog(
                        context: context,
                        builder: (ctx) => Dialog(
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('File(s) already exist', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                const SizedBox(height: 16),
                                Text(
                                  'The following file(s) were already added and will not be added again:',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  duplicates.join(', '),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                ),
                                const SizedBox(height: 24),
                                OutlinedButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white, width: 1.5),
                                    foregroundColor: Colors.blueAccent,
                                    backgroundColor: Theme.of(context).cardColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                  ),
                                  child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    foregroundColor: Colors.blueAccent,
                    backgroundColor: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(LucideIcons.share, color: Colors.blueAccent, size: 28),
                      SizedBox(height: 6),
                      Text('Add New File', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
              const SizedBox(width: 12),
              LogLevelFilterBar(
                selected: _level,
                onChanged: (v) => setState(() => _level = v),
              ),
            ],
          ),
        ),
        // Clear All Files button after search & filters row
        if (logFiles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => ref.read(logFilesProvider.notifier).clear(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    foregroundColor: Colors.redAccent,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(LucideIcons.trash2, color: Colors.redAccent, size: 28),
                      SizedBox(height: 6),
                      Text('Clear All Files', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        DashboardFilesList(
          files: logFiles,
          search: _search,
          level: _level,
          startDate: _startDate,
          endDate: _endDate,
        ),
      ],
    );
  }
}

class _LogLinesArea extends StatefulWidget {
  final List<LogEntry> entries;
  final String Function(int) monthShort;
  final IconData Function(LogLevel) iconForLevel;
  final Color Function(LogLevel, BuildContext) levelColor;
  const _LogLinesArea({required this.entries, required this.monthShort, required this.iconForLevel, required this.levelColor});

  @override
  State<_LogLinesArea> createState() => _LogLinesAreaState();
}

class _LogLinesAreaState extends State<_LogLinesArea> {
  late final ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (widget.entries.isEmpty) {
      return const Text('No log entries found.');
    }
    return SizedBox(
      height: 300,
      child: Scrollbar(
        controller: _controller,
        thumbVisibility: true,
        child: ListView.builder(
          controller: _controller,
          itemCount: widget.entries.length,
          itemBuilder: (context, i) {
            final entry = widget.entries[i];
            final lineNumber = i + 1;
            final iconData = widget.iconForLevel(entry.level);
            final iconColor = widget.levelColor(entry.level, context);
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(iconData, color: iconColor, size: 20),
                    const SizedBox(width: 8),
                    Text('$lineNumber:', style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
                    const SizedBox(width: 8),
                    if (entry.timestamp != null && entry.host.isNotEmpty) ...[
                      Builder(
                        builder: (context) {
                          final ts = "'${entry.timestamp!.day.toString().padLeft(2, '0')} ${widget.monthShort(entry.timestamp!.month)} ${entry.timestamp!.hour.toString().padLeft(2, '0')}:${entry.timestamp!.minute.toString().padLeft(2, '0')}:${entry.timestamp!.second.toString().padLeft(2, '0')}'";
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(ts, style: const TextStyle(fontSize: 11, color: Colors.blueAccent, fontWeight: FontWeight.w400)),
                              const SizedBox(width: 8),
                              Text(entry.host, style: const TextStyle(fontSize: 16, color: Colors.white)),
                              const SizedBox(width: 8),
                              Flexible(
                                fit: FlexFit.loose,
                                child: SelectableText(entry.message, style: const TextStyle(fontSize: 16, color: Colors.white)),
                              ),
                            ],
                          );
                        },
                      ),
                    ] else ...[
                      Flexible(
                        fit: FlexFit.loose,
                        child: SelectableText(entry.message, style: const TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DashedBorder extends ShapeBorder {
  final Color color;
  final double borderRadius;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  const _DashedBorder({
    required this.color,
    this.borderRadius = 0,
    this.dashWidth = 5,
    this.dashSpace = 3,
    this.strokeWidth = 1.5,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ShapeBorder scale(double t) => this;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    _drawDashedRect(canvas, rrect, paint);
  }

  void _drawDashedRect(Canvas canvas, RRect rrect, Paint paint) {
    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics().toList();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  ShapeBorder lerpFrom(ShapeBorder? a, double t) => this;
  @override
  ShapeBorder lerpTo(ShapeBorder? b, double t) => this;
}
