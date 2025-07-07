import 'package:flutter/material.dart';

class TotalFilesTile extends StatelessWidget {
  final int fileCount;
  final int timestampCount;
  const TotalFilesTile({required this.fileCount, required this.timestampCount});

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
