import 'package:flutter/material.dart';

class MemoryNote extends StatelessWidget {
  final String note;

  const MemoryNote({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 16),
          Text(
            note,
            style: Theme.of(context).textTheme.bodyLarge,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
