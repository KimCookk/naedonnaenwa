import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naedonnaenwa/models/debt.dart';
import 'package:naedonnaenwa/providers/selected_tags_provider.dart';

class TagFilterBar extends ConsumerWidget {
  final List<Debt> allDebts;

  const TagFilterBar({super.key, required this.allDebts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTags = ref.watch(selectedTagsProvider);
    final allTags = allDebts.expand((d) => d.tags).toSet().toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: allTags.map((tag) {
          final isSelected = selectedTags.contains(tag);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(tag.label),
              selected: isSelected,
              onSelected: (_) {
                ref.read(selectedTagsProvider.notifier).update((state) {
                  if (isSelected) {
                    return state.where((t) => t != tag).toList();
                  } else {
                    return [...state, tag];
                  }
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
