import 'package:flutter/material.dart';
import '/core/data/models/memory.dart';

class MemoryMetadata extends StatelessWidget {
  final Memory memory;

  const MemoryMetadata({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatFullDate(memory.createdAt),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          if (memory.tags != null && memory.tags!.isNotEmpty)
            Wrap(
              spacing: 8,
              children: memory.tags!
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      onDeleted: () {
                        // TODO: Remove tag
                      },
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime dateTime) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
