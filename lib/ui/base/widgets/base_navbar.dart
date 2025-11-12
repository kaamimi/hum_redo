import 'package:flutter/material.dart';

class BaseNavbar extends StatelessWidget {
  const BaseNavbar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: [
          NavigationDestination(
            selectedIcon: const Icon(Icons.home_rounded),
            icon: const Icon(Icons.home_outlined),
            label: 'Home',
            tooltip: 'Home',
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.collections_bookmark_rounded),
            icon: const Icon(Icons.collections_bookmark_outlined),
            label: 'Collections',
            tooltip: 'Collections',
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.search_rounded),
            icon: const Icon(Icons.search_outlined),
            label: 'Search',
            tooltip: 'Search',
          ),
        ],
      ),
    );
  }
}
