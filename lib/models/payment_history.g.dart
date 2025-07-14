// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentHistoryAdapter extends TypeAdapter<PaymentHistory> {
  @override
  final int typeId = 1;

  @override
  PaymentHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentHistory(
      amount: fields[0] as int,
      paidAt: fields[1] as DateTime,
      type: fields[3] as PaymentType,
      memo: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentHistory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.paidAt)
      ..writeByte(2)
      ..write(obj.memo)
      ..writeByte(3)
      ..write(obj.type);
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

class PaymentTypeAdapter extends TypeAdapter<PaymentType> {
  @override
  final int typeId = 0;

  @override
  PaymentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PaymentType.repayment;
      case 1:
        return PaymentType.borrowMore;
      default:
        return PaymentType.repayment;
    }
  }

  @override
  void write(BinaryWriter writer, PaymentType obj) {
    switch (obj) {
      case PaymentType.repayment:
        writer.writeByte(0);
        break;
      case PaymentType.borrowMore:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
