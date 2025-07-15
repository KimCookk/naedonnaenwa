import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naedonnaenwa/models/debt.dart';
import 'package:naedonnaenwa/models/tag.dart';
import 'package:naedonnaenwa/providers/debt_list_provider.dart';
import 'package:naedonnaenwa/providers/selected_tags_provider.dart';

final filteredDebtProvider = Provider<List<Debt>>((ref) {
  final List<Debt> debts = ref.watch(debtListProvider).maybeWhen(
        data: (data) => data,
        orElse: () => [],
      );
  final selectedTags = ref.watch(selectedTagsProvider);

  if (selectedTags.isEmpty) return debts;

  return debts.where((debt) {
    return selectedTags.every((tag) => debt.tags.contains(tag));
  }).toList();
});
