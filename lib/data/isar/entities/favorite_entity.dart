/// Isar favorite entity
library;

import 'package:isar/isar.dart';

part 'favorite_entity.g.dart';

@collection
class FavoriteEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String postId;

  late DateTime createdAt;
}
