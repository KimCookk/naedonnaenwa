import 'package:flutter/material.dart';
import 'package:naedonnaenwa/dev/mock_debt_seed.dart';
import 'package:naedonnaenwa/screens/home_screen.dart';
import 'package:naedonnaenwa/services/datasource/debt_hive_data_source.dart';
import 'package:naedonnaenwa/services/hive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naedonnaenwa/services/recurring_service.dart';
import 'package:naedonnaenwa/services/repository/debt_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized;
  await HiveService.init();

  final repo = DebtRepository(dataSource: DebtHiveDataSource());
  await insertMockDebts(repo);
  await RecurringService.processAllRecurringDebts(repo); // 🔁 반복부채 처리

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '내돈내놔',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
