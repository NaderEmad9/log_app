import 'package:flutter/material.dart';

class ErrorStatTile extends StatelessWidget {
  final int count;
  final int fileCount;
  const ErrorStatTile({required this.count, required this.fileCount});

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
