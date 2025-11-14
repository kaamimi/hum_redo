import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/services/theme_toggle.dart';
import '/ui/home/widgets/week_timeline.dart';
import '/ui/home/widgets/streak_card.dart';
import '/ui/home/widgets/recent_memories.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hello, Kami',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              brightness == Brightness.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CurrentWeekTimeline(),
            StreakCard(currentStreak: 30),
            const SizedBox(height: 16),
            RecentMemories(),
          ],
        ),
      ),
    );
  }
}
