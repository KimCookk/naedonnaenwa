import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:naedonnaenwa/models/debt.dart';
import 'package:naedonnaenwa/models/payment_history.dart';
import 'package:naedonnaenwa/models/tag.dart';
import 'package:naedonnaenwa/providers/debt_list_provider.dart';
import 'package:naedonnaenwa/providers/debt_repository_provider.dart';
import 'package:naedonnaenwa/widgets/enum/payment_action.dart';
import 'package:naedonnaenwa/widgets/payment_input_sheet.dart';

class DebtCard extends ConsumerWidget {
  final Debt debt;

  const DebtCard({super.key, required this.debt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getCardColor(debt),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(debt.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Spacer(),
              Text(
                '${_currencySymbol(debt.currency)}${debt.remainingAmount}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: debt.remainingAmount == 0
                      ? Colors.grey
                      : debt.type == DebtType.lent
                          ? Colors.green
                          : Colors.red,
                ),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) => PaymentInputSheet(
                            onSubmit: (action, amount, paidAt) async {
                              final type = action == PaymentAction.repayment
                                  ? PaymentType.repayment
                                  : PaymentType.borrowMore;

                              final updatedPayments = [
                                ...debt.payments
                              ]; // 기존 내역 복사
                              updatedPayments.add(PaymentHistory(
                                amount: amount,
                                paidAt: paidAt,
                                type: type,
                              ));

                              final updatedDebt = debt.copyWith(
                                payments: updatedPayments,
                                updatedAt: DateTime.now(),
                              );

                              await ref
                                  .read(debtRepositoryProvider)
                                  .updateDebt(updatedDebt);
                              ref.invalidate(debtListProvider); // 상태 새로고침
                            },
                          ));
                },
                icon: Icon(Icons.edit),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(_formatDate(debt.dueDate)),
              const SizedBox(width: 8),
              if (_getOverdueText(debt) != null)
                Text(_getOverdueText(debt)!,
                    style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
          Text(debt.note ?? ""),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: -8,
            children: debt.tags
                .map((tag) => Chip(
                      label: Text(tag.label),
                      backgroundColor: tag.type == TagType.system
                          ? Colors.grey[200]
                          : Colors.blue[100],
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: tag.type == TagType.system
                            ? Colors.black87
                            : Colors.blue[900],
                      ),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('yyyy.MM.dd');
    return formatter.format(date);
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

  Color _getCardColor(Debt debt) {
    if (debt.remainingAmount == 0) return Colors.grey[100]!;

    final now = DateTime.now();
    if (now.isAfter(debt.dueDate)) return Colors.red[50]!;

    return Colors.white;
  }

  String? _getOverdueText(Debt debt) {
    final now = DateTime.now();
    if (now.isBefore(debt.dueDate)) return null;

    final days = now.difference(debt.dueDate).inDays;
    return '+$days일 지남';
  }
}
