import 'package:flutter/material.dart';
import 'package:hum/ui/base/widgets/base_navbar.dart';

import '/ui/home/home_view.dart';
import '/ui/collections/collections_view.dart';
import '/ui/search/search_view.dart';
import '/ui/new_memory/new_memory_view.dart';

class HumBase extends StatefulWidget {
  const HumBase({super.key});

  @override
  State<HumBase> createState() => _HumBaseState();
}

class _HumBaseState extends State<HumBase> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewMemoryView()),
        ),
        tooltip: 'New Memory',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BaseNavbar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) =>
            setState(() => _selectedIndex = value),
      ),
      body: [HomeView(), CollectionsView(), SearchView()][_selectedIndex],
    );
  }
}
