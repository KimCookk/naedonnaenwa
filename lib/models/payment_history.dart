import 'package:hive/hive.dart';

part 'payment_history.g.dart';

@HiveType(typeId: 0)
enum PaymentType {
  @HiveField(0)
  repayment, // 상환
  @HiveField(1)
  borrowMore, // 추가 빌림
}

@HiveType(typeId: 1)
class PaymentHistory {
  @HiveField(0)
  final int amount; // 상환 금액

  @HiveField(1)
  final DateTime paidAt; // 상환 날짜

  @HiveField(2)
  final String? memo; // 메모

  @HiveField(3)
  final PaymentType type;

  PaymentHistory({
    required this.amount,
    required this.paidAt,
    required this.type,
    this.memo,
  });
}
