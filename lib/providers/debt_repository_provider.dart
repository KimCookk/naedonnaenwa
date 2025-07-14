import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naedonnaenwa/services/datasource/debt_hive_data_source.dart';
import 'package:naedonnaenwa/services/repository/debt_repository.dart';

final debtRepositoryProvider = Provider<DebtRepository>((ref) {
  final dataSource = DebtHiveDataSource(); // 나중에 바꾸기 쉬움!
  return DebtRepository(dataSource: dataSource);
});
