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
}
