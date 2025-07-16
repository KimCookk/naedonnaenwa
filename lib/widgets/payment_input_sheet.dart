import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:naedonnaenwa/widgets/enum/payment_action.dart';

class PaymentInputSheet extends StatefulWidget {
  final void Function(PaymentAction action, int amount, DateTime paidAt)
      onSubmit;

  const PaymentInputSheet({super.key, required this.onSubmit});

  @override
  State<PaymentInputSheet> createState() => _PaymentInputSheetState();
}

class _PaymentInputSheetState extends State<PaymentInputSheet> {
  PaymentAction? _selectedAction;
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_selectedAction == null || _amountController.text.isEmpty) return;

    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;

    widget.onSubmit(_selectedAction!, amount, _selectedDate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isReady =
        _selectedAction != null && _amountController.text.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("💳 어떤 작업을 수행할까요?", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 12),

          // 액션 선택 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: PaymentAction.values.map((action) {
              final selected = _selectedAction == action;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ChoiceChip(
                  label: Text(
                    action == PaymentAction.repayment ? "📤 상환" : "💸 추가 대출",
                  ),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedAction = action),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // 금액 입력
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '금액',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // 날짜 선택
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '날짜: ${DateFormat.yMd().format(_selectedDate)}',
                style: const TextStyle(fontSize: 16),
              ),
              TextButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today),
                label: const Text('날짜 선택'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 완료 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isReady ? _submit : null,
              child: Text(
                _selectedAction == PaymentAction.repayment ? '상환 완료' : '추가 완료',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
