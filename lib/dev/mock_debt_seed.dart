import 'package:flutter/foundation.dart';
import 'package:naedonnaenwa/models/debt.dart';
import 'package:naedonnaenwa/models/payment_history.dart';
import 'package:naedonnaenwa/models/tag.dart';
import 'package:uuid/uuid.dart';
import 'package:naedonnaenwa/services/repository/debt_repository.dart';

Future<void> insertMockDebts(DebtRepository repo) async {
  if (!kDebugMode) return;

  final now = DateTime.now();

  final sample = [
    Debt(
      id: const Uuid().v4(),
      name: '철수',
      totalAmount: 50000,
      payments: [
        PaymentHistory(
          amount: 10000,
          paidAt: now.subtract(const Duration(days: 2)),
          type: PaymentType.repayment,
        ),
      ],
      dueDate: now.add(const Duration(days: 7)),
      note: '편의점 갔다옴',
      type: DebtType.lent,
      recurring: RecurringType.none,
      currency: CurrencyType.krw,
      createdAt: now,
      updatedAt: now,
      tags: [
        Tag.system('빌려줌'),
        Tag.user('철수'), // 사용자 태그
      ],
    ),
    Debt(
      id: const Uuid().v4(),
      name: '영희',
      totalAmount: 30000,
      payments: [],
      dueDate: now.add(const Duration(days: -3)),
      note: '점심값',
      type: DebtType.borrowed,
      recurring: RecurringType.none,
      currency: CurrencyType.krw,
      createdAt: now,
      updatedAt: now,
      tags: [
        Tag.system('빌림'),
        Tag.user('점심'),
      ],
    ),
    Debt(
      id: const Uuid().v4(),
      name: '상훈',
      totalAmount: 100000,
      payments: [
        PaymentHistory(
          amount: 20000,
          paidAt: now.subtract(const Duration(days: 1)),
          type: PaymentType.repayment,
        ),
        PaymentHistory(
          amount: 10000,
          paidAt: now,
          type: PaymentType.borrowMore,
        ),
      ],
      dueDate: now.add(const Duration(days: 30)),
      note: '매달 회비',
      type: DebtType.lent,
      recurring: RecurringType.monthly,
      currency: CurrencyType.krw,
      createdAt: now,
      updatedAt: now,
      tags: [
        Tag.system('빌려줌'),
        Tag.system('월마다'),
        Tag.user('회비'),
      ],
    ),
    Debt(
      id: const Uuid().v4(),
      name: 'David',
      totalAmount: 200,
      payments: [],
      dueDate: now.add(const Duration(days: 15)),
      note: '미국 달러 테스트',
      type: DebtType.borrowed,
      recurring: RecurringType.none,
      currency: CurrencyType.usd,
      createdAt: now,
      updatedAt: now,
      tags: [
        Tag.system('빌림'),
        Tag.user('달러'),
      ],
    ),
  ];

  for (final debt in sample) {
    await repo.addDebt(debt);
  }
}

Future<void> resetMockDebts(DebtRepository repo) async {
  await repo.deleteAllDebt();
}
