/// User record model
library;

class UserRecord {
  UserRecord({
    required this.userId,
    required this.name,
    required this.subtitle,
    required this.quote,
    required this.avatarUrl,
    required this.aboutAvatarUrl,
    required this.aboutSubtitle,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  final String userId;
  final String name;
  final String subtitle;
  final String quote;
  final String avatarUrl;
  final String aboutAvatarUrl;
  final String aboutSubtitle;
  final DateTime updatedAt;
}
