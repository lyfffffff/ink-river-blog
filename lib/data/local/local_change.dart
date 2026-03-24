/// Local change model
library;

class LocalChange {
  LocalChange({
    required this.entityType,
    required this.entityId,
    required this.changeType,
    required this.payloadJson,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String entityType;
  final String entityId;
  final String changeType;
  final String payloadJson;
  final DateTime createdAt;
}
