import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './widgets/search_bar.dart';
import './widgets/month_collections.dart';
import './collections_view_model.dart';

class CollectionsView extends ConsumerWidget {
  const CollectionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(collectionsViewModelProvider);
    final viewModel = ref.read(collectionsViewModelProvider.notifier);

    return Scaffold(
      appBar: SearchAppBar(
        isSearching: state.isSearching,
        onToggleSearch: () => viewModel.toggleSearch(),
        onSearchQueryChanged: (value) => viewModel.updateSearchQuery(value),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: MonthCollections(),
      ),
    );
  }
}
