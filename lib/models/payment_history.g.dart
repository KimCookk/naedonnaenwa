// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentHistoryAdapter extends TypeAdapter<PaymentHistory> {
  @override
  final int typeId = 0;

  @override
  PaymentHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentHistory(
      amount: fields[0] as int,
      paidAt: fields[1] as DateTime,
      memo: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentHistory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.paidAt)
      ..writeByte(2)
      ..write(obj.memo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
