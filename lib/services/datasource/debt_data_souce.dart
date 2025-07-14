import 'package:naedonnaenwa/models/debt.dart';

abstract class DebtDataSource {
  Future<void> add(Debt debt);
  Future<void> update(Debt debt);
  Future<void> delete(String id);
  Future<Debt?> getById(String id);
  Future<List<Debt>> getAll();
}
