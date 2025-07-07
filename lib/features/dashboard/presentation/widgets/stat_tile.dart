import 'package:flutter/material.dart';

class StatTile extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final String? subtitle;
  final int? fileCount;
  const StatTile({required this.label, required this.count, required this.color, this.subtitle, this.fileCount});

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
