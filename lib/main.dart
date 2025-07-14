import 'package:flutter/material.dart';
import 'package:naedonnaenwa/services/hive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized;
  await HiveService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '내돈내놔',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const Scaffold(
        body: Center(child: Text("내돈내놔 앱 시작 🎉")),
      ),
    );
  }
}
