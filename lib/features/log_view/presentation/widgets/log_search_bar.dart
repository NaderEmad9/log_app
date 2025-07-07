import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LogSearchBar extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const LogSearchBar({super.key, required this.value, required this.onChanged});

  @override
  State<LogSearchBar> createState() => _LogSearchBarState();
}

class _LogSearchBarState extends State<LogSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _controller.addListener(() {
      if (_controller.text != widget.value) {
        widget.onChanged(_controller.text);
      }
    });
  }

  @override
  void didUpdateWidget(LogSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor, // Use the exact dashboard card color
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            prefixIcon:  Icon(LucideIcons.search),
            hintText: 'Search logs...',
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    tooltip: 'Clear search',
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged('');
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color.fromARGB(255, 25, 50, 95), width: 2.5),
            ),
          ),
        ),
      ),
    );
  }
}
