import 'package:hive/hive.dart';

part 'tag.g.dart';

@HiveType(typeId: 6)
enum TagType {
  @HiveField(0)
  system,

  @HiveField(1)
  user,
}

@HiveType(typeId: 7)
class Tag {
  @HiveField(0)
  final String label;

  @HiveField(1)
  final TagType type;

  const Tag({
    required this.label,
    required this.type,
  });

  factory Tag.system(String label) {
    return Tag(label: label, type: TagType.system);
  }

  factory Tag.user(String label) {
    return Tag(label: label, type: TagType.user);
  }

  @override
  bool operator ==(Object other) {
    return other is Tag && other.label == label && other.type == type;
  }

  @override
  int get hashCode => label.hashCode ^ type.hashCode;
}
