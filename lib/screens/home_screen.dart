import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naedonnaenwa/dev/mock_debt_seed.dart';
import 'package:naedonnaenwa/providers/debt_list_provider.dart';
import 'package:naedonnaenwa/models/debt.dart';
import 'package:naedonnaenwa/providers/debt_repository_provider.dart';
import 'package:naedonnaenwa/providers/filtered_debt_provider.dart';
import 'package:naedonnaenwa/screens/add_debt_screen.dart';
import 'package:naedonnaenwa/widgets/debt_card.dart';
import 'package:naedonnaenwa/widgets/tag_filter_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredDebts = ref.watch(filteredDebtProvider);
    final allDebts = ref.watch(debtListProvider);
    final repo = ref.read(debtRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('💰 내돈내놔',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await resetMockDebts(repo);
              ref.invalidate(debtListProvider);
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddDebtScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: allDebts.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('에러 발생: $error')),
          data: (debts) {
            if (debts.isEmpty) {
              return const Center(
                child: Text('등록된 빚이 없어요 🥲', style: TextStyle(fontSize: 16)),
              );
            }
            return Column(
              children: [
                TagFilterBar(allDebts: allDebts.value ?? []),
                SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      itemCount: filteredDebts.length,
                      itemBuilder: (context, index) {
                        final debt = filteredDebts[index];
                        return DebtCard(debt: debt);
                      },
                    ),
                  ),
                ),
              ],
            );

            // return ListView.separated(
            //   itemCount: debts.length,
            //   separatorBuilder: (_, __) => const SizedBox(height: 12),
            //   itemBuilder: (context, index) {
            //     final debt = debts[index];
            //     final remaining = debt.remainingAmount;

            //     Color color = remaining == 0
            //         ? Colors.grey
            //         : debt.type == DebtType.lent
            //             ? Colors.green
            //             : Colors.redAccent;

            //     final typeLabel =
            //         debt.type == DebtType.lent ? '💸 빌려줌' : '📤 빌림';
            //     final currency = _currencySymbol(debt.currency);

            //     return Container(
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(16),
            //         boxShadow: const [
            //           BoxShadow(
            //             color: Colors.black12,
            //             blurRadius: 8,
            //             offset: Offset(0, 4),
            //           )
            //         ],
            //       ),
            //       child: ListTile(
            //         contentPadding: const EdgeInsets.symmetric(
            //             horizontal: 16, vertical: 12),
            //         title: Text(debt.name,
            //             style: const TextStyle(
            //                 fontSize: 18, fontWeight: FontWeight.bold)),
            //         subtitle: Text(typeLabel),
            //         trailing: Text(
            //           '$currency${remaining.toString()}',
            //           style: TextStyle(
            //             fontSize: 16,
            //             color: color,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            // );
          },
        ),
      ),
    );
  }

  String _currencySymbol(CurrencyType currency) {
    switch (currency) {
      case CurrencyType.krw:
        return '₩';
      case CurrencyType.usd:
        return '\$';
      case CurrencyType.jpy:
        return '¥';
      case CurrencyType.eur:
        return '€';
      default:
        return '';
    }
  }
}
