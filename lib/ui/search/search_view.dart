import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _updateSearchQuery,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _updateSearchQuery('');
                    },
                  )
                : null,
            hintText: 'Search your memories',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: _searchQuery.isEmpty
          ? Center(
              child: Text(
                'Enter a search term',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : ListView.builder(
              itemCount: 15, // Replace with actual search results
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Journal Entry ${index + 1}'),
                  subtitle: Text('Sample entry matching "$_searchQuery"'),
                  leading: const Icon(Icons.description_outlined),
                  onTap: () {
                    // Navigate to entry detail
                  },
                );
              },
            ),
    );
  }
}
