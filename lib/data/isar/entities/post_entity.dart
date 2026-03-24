/// Isar post entity
library;

import 'package:isar/isar.dart';

part 'post_entity.g.dart';

@collection
class PostEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String postId;

  @Index()
  late String authorId;

  late String title;
  late String excerpt;
  late String category;
  late String date;
  late String imageUrl;
  late String content;
  late int readMinutes;
  late List<String> tags;
  late DateTime updatedAt;
}
