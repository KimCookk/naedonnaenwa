import 'package:hive/hive.dart';

part 'payment_history.g.dart';

@HiveType(typeId: 0)
class PaymentHistory {
  @HiveField(0)
  final int amount; // 상환 금액
  @HiveField(1)
  final DateTime paidAt; // 상환 날짜
  @HiveField(2)
  final String? memo; // 메모

  PaymentHistory({
    required this.amount,
    required this.paidAt,
    this.memo,
  });
}
