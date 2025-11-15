import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollectionsState {
  final bool isSearching;
  final String searchQuery;

  const CollectionsState({this.isSearching = false, this.searchQuery = ''});

  CollectionsState copyWith({bool? isSearching, String? searchQuery}) {
    return CollectionsState(
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

final collectionsViewModelProvider =
    NotifierProvider.autoDispose<CollectionsViewModel, CollectionsState>(
      CollectionsViewModel.new,
    );

class CollectionsViewModel extends Notifier<CollectionsState> {
  @override
  CollectionsState build() => const CollectionsState();

  void toggleSearch() {
    state = state.copyWith(isSearching: !state.isSearching, searchQuery: '');
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}
