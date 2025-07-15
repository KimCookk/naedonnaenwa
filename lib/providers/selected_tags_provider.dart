import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naedonnaenwa/models/tag.dart';

final selectedTagsProvider = StateProvider<List<Tag>>((ref) => []);
