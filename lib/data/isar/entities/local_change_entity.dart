/// Isar local change entity
library;

import 'package:isar/isar.dart';

part 'local_change_entity.g.dart';

@collection
class LocalChangeEntity {
  Id id = Isar.autoIncrement;

  @Index()
  late String userId;

  @Index()
  late String entityType;

  @Index()
  late String entityId;

  late String changeType;
  late String payloadJson;
  late DateTime createdAt;
}
