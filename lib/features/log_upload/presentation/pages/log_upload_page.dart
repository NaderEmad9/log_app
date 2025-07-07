import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/log_file_provider.dart';
import '../../../log_view/presentation/pages/log_view_page.dart';

class LogUploadPage extends ConsumerWidget {
  const LogUploadPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logFiles = ref.watch(logFilesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Log Files')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (logFiles.isNotEmpty)
              ...logFiles.map((file) => ListTile(
                    leading: const Icon(Icons.description),
                    title: Text(file.name),
                    subtitle: Text(file.path),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LogViewPage(logFile: file),
                      ),
                    ),
                  )),
            if (logFiles.isEmpty) ...[
              const Text('Choose your log files', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              const Text('supports .log and .txt files', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.normal)),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.upload_file, color: Colors.white),
                label: const Text('Select Log Files', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                onPressed: () async {
                  final duplicates = await ref.read(logFilesProvider.notifier).pickAndAddFilesWithCheck();
                  if (duplicates != null && duplicates.isNotEmpty && context.mounted) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('File(s) already exist'),
                        content: Text('The following file(s) were already added and will not be added again:\n\n' + duplicates.join(', ')),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
