import 'package:flutter/material.dart';

import './widgets/search_bar.dart';

class CollectionsView extends StatelessWidget {
  const CollectionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: SearchAppBar());
  }
}
