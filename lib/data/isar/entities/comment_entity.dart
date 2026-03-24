/// Isar comment entity
library;

import 'package:isar/isar.dart';

part 'comment_entity.g.dart';

@collection
class CommentEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String commentId;

  @Index()
  late String postId;

  late String authorName;
  late String authorInitial;
  late String content;
  late String timeAgo;
  late int likeCount;
  late DateTime createdAt;
}
