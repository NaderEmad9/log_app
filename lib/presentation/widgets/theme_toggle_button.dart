import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    return IconButton(
      icon: Icon(theme.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
      onPressed: () => ref.read(appThemeProvider.notifier).toggleTheme(),
      tooltip: 'Toggle Dark/Light Mode',
    );
  }
}
