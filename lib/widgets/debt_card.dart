import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:naedonnaenwa/models/debt.dart';
import 'package:naedonnaenwa/models/tag.dart';

class DebtCard extends StatelessWidget {
  final Debt debt;

  const DebtCard({super.key, required this.debt});

  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(debt.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
