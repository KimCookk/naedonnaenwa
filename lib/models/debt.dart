import 'package:hive/hive.dart';
import 'package:naedonnaenwa/models/payment_history.dart';
import 'package:naedonnaenwa/models/tag.dart';

part 'debt.g.dart';

@HiveType(typeId: 2)
enum DebtType {
  @HiveField(0)
  lent, // 내가 빌려준 돈
  @HiveField(1)
  borrowed, // 내가 빌린 돈
}

@HiveType(typeId: 3)
enum RecurringType {
  @HiveField(0)
  none,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
}

@HiveType(typeId: 4)
enum CurrencyType {
  @HiveField(0)
  krw, // 원화 ₩
  @HiveField(1)
  usd, // 달러 $
  @HiveField(2)
  jpy, // 엔화 ¥
  @HiveField(3)
  eur, // 유로 €
  @HiveField(4)
  other,
}

@HiveType(typeId: 5)
class Debt {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int totalAmount;

  @HiveField(3)
  final List<PaymentHistory> payments;

  @HiveField(4)
  final DateTime dueDate;

  @HiveField(5)
  final String? note;

  @HiveField(6)
  final DebtType type;

  @HiveField(7)
  final RecurringType recurring;

  @HiveField(8)
  final bool isPaid;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  @HiveField(11)
  final CurrencyType currency;

  @HiveField(12)
  List<Tag> tags;

  Debt({
    required this.id,
    required this.name,
    required this.totalAmount,
    required this.payments,
    required this.dueDate,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.currency,
    required this.tags,
    this.note,
    this.recurring = RecurringType.none,
    this.isPaid = false,
  });

  int get remainingAmount {
    int result = totalAmount;

    for (final p in payments) {
      if (p.type == PaymentType.repayment) {
        result -= p.amount;
      } else if (p.type == PaymentType.borrowMore) {
        result += p.amount;
      }
    }

    return result;
  }

  Debt copyWith({
    String? id,
    String? name,
    int? totalAmount,
    List<PaymentHistory>? payments,
    DateTime? dueDate,
    String? note,
    DebtType? type,
    RecurringType? recurring,
    bool? isPaid,
    DateTime? createdAt,
    DateTime? updatedAt,
    CurrencyType? currency,
    List<Tag>? tags,
  }) {
    return Debt(
      id: id ?? this.id,
      name: name ?? this.name,
      totalAmount: totalAmount ?? this.totalAmount,
      payments: payments ?? this.payments,
      dueDate: dueDate ?? this.dueDate,
      note: note ?? this.note,
      type: type ?? this.type,
      recurring: recurring ?? this.recurring,
      isPaid: isPaid ?? this.isPaid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currency: currency ?? this.currency,
      tags: tags ?? this.tags,
    );
  }
}
