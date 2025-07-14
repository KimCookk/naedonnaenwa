import 'package:hive_flutter/hive_flutter.dart';
import 'package:naedonnaenwa/models/debt.dart';
import 'package:naedonnaenwa/services/datasource/debt_data_souce.dart';

class DebtHiveDataSource implements DebtDataSource {
  static const String boxName = 'debts';

  Future<Box<Debt>> _openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<Debt>(boxName);
    }
    return Hive.box<Debt>(boxName);
  }

  @override
  Future<void> add(Debt debt) async {
    final box = await _openBox();
    await box.put(debt.id, debt);
  }

  @override
  Future<void> delete(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  @override
  Future<List<Debt>> getAll() async {
    final box = await _openBox();
    return box.values.toList();
  }

  @override
  Future<Debt?> getById(String id) async {
    final box = await _openBox();
    return box.get(id);
  }

  @override
  Future<void> update(Debt debt) async {
    final box = await _openBox();
    await box.put(debt.id, debt);
  }
}
