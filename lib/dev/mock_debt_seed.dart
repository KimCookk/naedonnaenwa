import 'package:flutter/foundation.dart';
import 'package:naedonnaenwa/models/debt.dart';
import 'package:naedonnaenwa/models/payment_history.dart';
import 'package:uuid/uuid.dart';
import 'package:naedonnaenwa/services/repository/debt_repository.dart';

Future<void> insertMockDebts(DebtRepository repo) async {
  if (!kDebugMode) return; // 릴리즈 모드에선 실행 안 함

  final sample = [
    Debt(
      id: const Uuid().v4(),
      name: '철수',
      totalAmount: 50000,
      payments: [
        PaymentHistory(
            amount: 10000, paidAt: DateTime.now(), type: PaymentType.repayment),
      ],
      dueDate: DateTime.now().add(const Duration(days: 7)),
      note: '편의점 갔다옴',
      type: DebtType.lent,
      recurring: RecurringType.none,
      currency: CurrencyType.krw,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Debt(
      id: const Uuid().v4(),
      name: '영희',
      totalAmount: 30000,
      payments: [],
      dueDate: DateTime.now().add(const Duration(days: 3)),
      note: '점심값',
      type: DebtType.borrowed,
      recurring: RecurringType.none,
      currency: CurrencyType.krw,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  for (final debt in sample) {
    await repo.addDebt(debt);
  }
}
