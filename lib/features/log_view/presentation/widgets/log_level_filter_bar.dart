import 'package:flutter/material.dart';
import '../../../log_view/domain/log_entry.dart';

class LogLevelFilterBar extends StatelessWidget {
  final LogLevel? selected;
  final ValueChanged<LogLevel?> onChanged;
  const LogLevelFilterBar({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilterChip(
          label: const Text('All'),
          selected: selected == null,
          onSelected: (_) => onChanged(null),
          backgroundColor: Theme.of(context).cardTheme.color,
          selectedColor: Colors.white,
          labelStyle: TextStyle(color: selected == null ? Colors.black : Colors.white),
          showCheckmark: false,
          side: const BorderSide(color: Colors.white),
        ),
        const SizedBox(width: 8),
        FilterChip(
          avatar: const Icon(Icons.error_outline, color: Colors.red, size: 20),
          label: const Text('Errors'),
          selected: selected == LogLevel.error,
          onSelected: (_) => onChanged(LogLevel.error),
          backgroundColor: Theme.of(context).cardTheme.color,
          selectedColor: Colors.white,
          labelStyle: TextStyle(color: selected == LogLevel.error ? Colors.black : Colors.white),
          showCheckmark: false,
          side: const BorderSide(color: Colors.white),
        ),
        const SizedBox(width: 8),
        FilterChip(
          avatar: const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20),
          label: const Text('Warnings'),
          selected: selected == LogLevel.warning,
          onSelected: (_) => onChanged(LogLevel.warning),
          backgroundColor: Theme.of(context).cardTheme.color,
          selectedColor: Colors.white,
          labelStyle: TextStyle(color: selected == LogLevel.warning ? Colors.black : Colors.white),
          showCheckmark: false,
          side: const BorderSide(color: Colors.white),
        ),
        const SizedBox(width: 8),
        FilterChip(
          avatar: const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
          label: const Text('Success'),
          selected: selected == LogLevel.success,
          onSelected: (_) => onChanged(LogLevel.success),
          backgroundColor: Theme.of(context).cardTheme.color,
          selectedColor: Colors.white,
          labelStyle: TextStyle(color: selected == LogLevel.success ? Colors.black : Colors.white),
          showCheckmark: false,
          side: const BorderSide(color: Colors.white),
        ),
      ],
    );
  }
}
