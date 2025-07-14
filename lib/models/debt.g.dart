// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DebtAdapter extends TypeAdapter<Debt> {
  @override
  final int typeId = 5;

  @override
  Debt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Debt(
      id: fields[0] as String,
      name: fields[1] as String,
      totalAmount: fields[2] as int,
      payments: (fields[3] as List).cast<PaymentHistory>(),
      dueDate: fields[4] as DateTime,
      type: fields[6] as DebtType,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
      currency: fields[11] as CurrencyType,
      tags: (fields[12] as List).cast<Tag>(),
      note: fields[5] as String?,
      recurring: fields[7] as RecurringType,
      isPaid: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Debt obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.totalAmount)
      ..writeByte(3)
      ..write(obj.payments)
      ..writeByte(4)
      ..write(obj.dueDate)
      ..writeByte(5)
      ..write(obj.note)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.recurring)
      ..writeByte(8)
      ..write(obj.isPaid)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.currency)
      ..writeByte(12)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DebtTypeAdapter extends TypeAdapter<DebtType> {
  @override
  final int typeId = 2;

  @override
  DebtType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DebtType.lent;
      case 1:
        return DebtType.borrowed;
      default:
        return DebtType.lent;
    }
  }

  @override
  void write(BinaryWriter writer, DebtType obj) {
    switch (obj) {
      case DebtType.lent:
        writer.writeByte(0);
        break;
      case DebtType.borrowed:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecurringTypeAdapter extends TypeAdapter<RecurringType> {
  @override
  final int typeId = 3;

  @override
  RecurringType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecurringType.none;
      case 1:
        return RecurringType.weekly;
      case 2:
        return RecurringType.monthly;
      default:
        return RecurringType.none;
    }
  }

  @override
  void write(BinaryWriter writer, RecurringType obj) {
    switch (obj) {
      case RecurringType.none:
        writer.writeByte(0);
        break;
      case RecurringType.weekly:
        writer.writeByte(1);
        break;
      case RecurringType.monthly:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CurrencyTypeAdapter extends TypeAdapter<CurrencyType> {
  @override
  final int typeId = 4;

  @override
  CurrencyType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CurrencyType.krw;
      case 1:
        return CurrencyType.usd;
      case 2:
        return CurrencyType.jpy;
      case 3:
        return CurrencyType.eur;
      case 4:
        return CurrencyType.other;
      default:
        return CurrencyType.krw;
    }
  }

  @override
  void write(BinaryWriter writer, CurrencyType obj) {
    switch (obj) {
      case CurrencyType.krw:
        writer.writeByte(0);
        break;
      case CurrencyType.usd:
        writer.writeByte(1);
        break;
      case CurrencyType.jpy:
        writer.writeByte(2);
        break;
      case CurrencyType.eur:
        writer.writeByte(3);
        break;
      case CurrencyType.other:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
