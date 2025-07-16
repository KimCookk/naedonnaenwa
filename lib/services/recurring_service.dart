import 'package:naedonnaenwa/models/debt.dart';
import 'package:naedonnaenwa/models/payment_history.dart';
import 'package:naedonnaenwa/services/repository/debt_repository.dart';

class RecurringService {
  static Future<void> processAllRecurringDebts(DebtRepository repo) async {
    final allDebts = await repo.getAllDebts();
    final now = DateTime.now();

    for (final debt in allDebts) {
      if (debt.recurring == RecurringType.none) continue;
      if (now.isBefore(debt.dueDate)) continue;

      final updated = _generateNextCycle(debt);
      await repo.updateDebt(updated);
    }
  }

  static Debt _generateNextCycle(Debt debt) {
    final now = DateTime.now();
    final nextDueDate = switch (debt.recurring) {
      RecurringType.weekly => debt.dueDate.add(const Duration(days: 7)),
      RecurringType.monthly => DateTime(
          debt.dueDate.year,
          debt.dueDate.month + 1,
          debt.dueDate.day,
        ),
      _ => debt.dueDate,
    };

    final newPayment = PaymentHistory(
      amount: debt.totalAmount,
      paidAt: now,
      type: PaymentType.borrowMore,
    );

    return Debt(
      id: debt.id,
      name: debt.name,
      totalAmount: debt.totalAmount,
      payments: [...debt.payments, newPayment],
      dueDate: nextDueDate,
      note: debt.note,
      type: debt.type,
      recurring: debt.recurring,
      currency: debt.currency,
      isPaid: false,
      createdAt: debt.createdAt,
      updatedAt: now,
      tags: debt.tags,
    );
  }
}
