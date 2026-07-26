/// 评论数据模型
library;

class Comment {
  Comment({
    required this.id,
    required this.authorName,
    required this.authorInitial,
    required this.content,
    required this.timeAgo,
    required this.likeCount,
  });

  final String id;
  final String authorName;
  final String authorInitial;
  final String content;
  final String timeAgo;
  final int likeCount;

  Comment copyWith({
    String? id,
    String? authorName,
    String? authorInitial,
    String? content,
    String? timeAgo,
    int? likeCount,
  }) {
    return Comment(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorInitial: authorInitial ?? this.authorInitial,
      content: content ?? this.content,
      timeAgo: timeAgo ?? this.timeAgo,
      likeCount: likeCount ?? this.likeCount,
    );
  }
}
