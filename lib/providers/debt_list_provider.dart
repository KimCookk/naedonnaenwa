import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naedonnaenwa/models/debt.dart';
import 'package:naedonnaenwa/providers/debt_repository_provider.dart';

final debtListProvider =
    AsyncNotifierProvider<DebtListNotifier, List<Debt>>(DebtListNotifier.new);

class DebtListNotifier extends AsyncNotifier<List<Debt>> {
  @override
  Future<List<Debt>> build() async {
    final repo = ref.read(debtRepositoryProvider);
    final debts = await repo.getAllDebts();
    return debts;
  }

  Future<void> addDebt(Debt debt) async {
    final repo = ref.read(debtRepositoryProvider);
    await repo.addDebt(debt);
    state = AsyncValue.data(await repo.getAllDebts());
  }

  Future<void> deleteDebt(String id) async {
    final repo = ref.read(debtRepositoryProvider);
    await repo.deleteDebt(id);
    state = AsyncValue.data(await repo.getAllDebts());
  }

  Future<void> updateDebt(Debt debt) async {
    final repo = ref.read(debtRepositoryProvider);
    await repo.updateDebt(debt);
    state = AsyncValue.data(await repo.getAllDebts());
  }

  Future<void> refresh() async {
    final repo = ref.read(debtRepositoryProvider);
    state = const AsyncValue.loading();
    state = AsyncValue.data(await repo.getAllDebts());
  }
}
