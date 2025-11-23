import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final VoidCallback onToggleSearch;
  final ValueChanged<String> onSearchQueryChanged;

  const SearchAppBar({
    super.key,
    required this.isSearching,
    required this.onToggleSearch,
    required this.onSearchQueryChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isSearching,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && isSearching) onToggleSearch();
      },
      child: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                onChanged: onSearchQueryChanged,
                decoration: InputDecoration(
                  hintText: 'Search collections',
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(32),
                  ),

                  // Back button
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: onToggleSearch,
                  ),
                ),
              )
            : const Text(
                'Collections',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        actions: [
          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: onToggleSearch,
            ),
        ],
      ),
    );
  }
}
