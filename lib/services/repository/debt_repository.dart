import 'package:naedonnaenwa/models/debt.dart';
import 'package:naedonnaenwa/services/datasource/debt_data_souce.dart';

class DebtRepository {
  final DebtDataSource dataSource;

  DebtRepository({required this.dataSource});

  Future<void> addDebt(Debt debt) => dataSource.add(debt);
  Future<void> updateDebt(Debt debt) => dataSource.update(debt);
  Future<void> deleteDebt(String id) => dataSource.delete(id);
  Future<void> deleteAllDebt() => dataSource.allDelete();
  Future<Debt?> getDebtById(String id) => dataSource.getById(id);
  Future<List<Debt>> getAllDebts() => dataSource.getAll();
}
