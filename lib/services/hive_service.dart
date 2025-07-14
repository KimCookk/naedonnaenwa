import 'package:hive_flutter/hive_flutter.dart';
import 'package:naedonnaenwa/models/payment_history.dart';
import 'package:naedonnaenwa/models/debt.dart';
import 'package:naedonnaenwa/models/tag.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(PaymentTypeAdapter());
    Hive.registerAdapter(PaymentHistoryAdapter());
    Hive.registerAdapter(DebtTypeAdapter());
    Hive.registerAdapter(RecurringTypeAdapter());
    Hive.registerAdapter(CurrencyTypeAdapter());
    Hive.registerAdapter(DebtAdapter());
    Hive.registerAdapter(TagTypeAdapter());
    Hive.registerAdapter(TagAdapter());
  }
}
