/// Isar user entity
library;

import 'package:isar/isar.dart';

part 'user_entity.g.dart';

@collection
class UserEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String userId;

  late String name;
  late String subtitle;
  late String quote;
  late String avatarUrl;
  late String aboutAvatarUrl;
  late String aboutSubtitle;
  late DateTime updatedAt;
}
