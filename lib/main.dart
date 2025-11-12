import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/theme.dart';
import '/core/services/theme_toggle.dart';
import '/ui/base/hum_base.dart';

void main() => runApp(ProviderScope(child: const HumApp()));

class HumApp extends ConsumerWidget {
  const HumApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      themeMode: themeMode,
      theme: humLightTheme,
      darkTheme: humDarkTheme,
      home: HumBase(),
    );
  }
}
