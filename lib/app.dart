import 'package:flutter/material.dart';
import 'presentation/routes/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const LogAnalyzerApp());
}

class LogAnalyzerApp extends StatelessWidget {
  const LogAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Log Analyzer',
      theme: appTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
