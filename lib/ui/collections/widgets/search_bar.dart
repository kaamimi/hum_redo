import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../collections_view_model.dart';

class SearchAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const SearchAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(collectionsViewModelProvider);
    final viewModel = ref.read(collectionsViewModelProvider.notifier);

    return AppBar(
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: state.isSearching
            ? TextField(
                autofocus: true,
                onChanged: (value) {
                  viewModel.updateSearchQuery(value);
                },
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {
                      viewModel.toggleSearch();
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  hintText: 'Search collections',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                ),
              )
            : const Text(
                "Collections",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
      actions: [
        if (!state.isSearching)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              viewModel.toggleSearch();
            },
          ),
      ],
    );
  }
}
