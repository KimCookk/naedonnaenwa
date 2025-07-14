import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naedonnaenwa/models/tag.dart';
import 'package:uuid/uuid.dart';
import 'package:naedonnaenwa/models/debt.dart';
import 'package:naedonnaenwa/providers/debt_list_provider.dart';

class AddDebtScreen extends ConsumerStatefulWidget {
  const AddDebtScreen({super.key});

  @override
  ConsumerState<AddDebtScreen> createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends ConsumerState<AddDebtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _tagController = TextEditingController();

  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  DebtType _type = DebtType.lent;
  CurrencyType _currency = CurrencyType.krw;
  RecurringType _recurring = RecurringType.none;
  List<Tag> _tags = [];

  @override
  void initState() {
    super.initState();
    _updateSystemTags(); // 초기 시스템 태그 등록
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // 중복 제거 (Set으로 중복 태그 제거 가능)
    final cleanedTags = _tags.toSet().toList();

    final newDebt = Debt(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      totalAmount: int.parse(_amountController.text.trim()),
      payments: [],
      dueDate: _dueDate,
      note: _noteController.text.trim(),
      type: _type,
      currency: _currency,
      recurring: _recurring,
      isPaid: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: cleanedTags,
    );

    await ref.read(debtListProvider.notifier).addDebt(newDebt);
    if (mounted) Navigator.pop(context); // 저장 후 뒤로 가기
  }

  void _updateSystemTags() {
    final systemTags = getSystemTags(_type, _recurring);
    setState(() {
      _tags.removeWhere((tag) => tag.type == TagType.system);
      _tags = [..._tags, ...systemTags];
    });
  }

  List<Tag> getSystemTags(DebtType type, RecurringType recurring) {
    final tags = <Tag>[];
    if (type == DebtType.lent) {
      tags.add(const Tag(label: '빌려줌', type: TagType.system));
    } else {
      tags.add(const Tag(label: '빌림', type: TagType.system));
    }

    switch (recurring) {
      case RecurringType.weekly:
        tags.add(const Tag(label: '매주반복', type: TagType.system));
        break;
      case RecurringType.monthly:
        tags.add(const Tag(label: '매달반복', type: TagType.system));
        break;
      default:
        break;
    }
    return tags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📥 부채 추가')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '상대방 이름'),
                validator: (value) =>
                    value == null || value.isEmpty ? '이름을 입력하세요' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '총 금액 (숫자만)'),
                validator: (value) =>
                    value == null || int.tryParse(value) == null
                        ? '숫자를 입력하세요'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: '메모 (선택)'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<DebtType>(
                  value: _type,
                  decoration: const InputDecoration(labelText: '부채 유형'),
                  items: DebtType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type == DebtType.lent ? '💸 빌려줌' : '📤 빌림'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _type = value!;
                    });
                    _updateSystemTags();
                  }),
              const SizedBox(height: 12),
              DropdownButtonFormField<CurrencyType>(
                value: _currency,
                decoration: const InputDecoration(labelText: '통화'),
                items: CurrencyType.values.map((cur) {
                  return DropdownMenuItem(
                    value: cur,
                    child: Text(cur.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _currency = value!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<RecurringType>(
                  value: _recurring,
                  decoration: const InputDecoration(labelText: '반복 여부'),
                  items: RecurringType.values.map((recurring) {
                    final label = switch (recurring) {
                      RecurringType.none => '반복 없음',
                      RecurringType.weekly => '매주 반복',
                      RecurringType.monthly => '매달 반복',
                    };
                    return DropdownMenuItem(
                      value: recurring,
                      child: Text(label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _recurring = value!);
                    _updateSystemTags();
                  }),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('태그 입력 (최대 12개)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _tagController,
                    decoration: const InputDecoration(
                      hintText: '띄어쓰기로 태그 입력',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.endsWith(' ')) {
                        final input = value.trim();
                        if (input.isEmpty) return;

                        final tag = Tag(label: input, type: TagType.user);

                        if (_tags.contains(tag)) return;
                        if (_tags.length >= 12) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('태그는 최대 12개까지 등록할 수 있어요')),
                          );
                          return;
                        }

                        setState(() {
                          _tags.add(tag);
                          _tagController.clear();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _tags.map((tag) {
                      return Chip(
                        label: Text(tag.label),
                        backgroundColor: tag.type == TagType.system
                            ? Colors.grey[300]
                            : null,
                        onDeleted: tag.type == TagType.user
                            ? () => setState(() => _tags.remove(tag))
                            : null,
                      );
                    }).toList(),
                  )
                ],
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('마감일'),
                subtitle: Text('${_dueDate.toLocal()}'.split(' ')[0]),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _dueDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => _dueDate = picked);
                  },
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text('저장하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
