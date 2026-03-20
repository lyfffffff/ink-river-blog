/// 博客文章数据模型
library;

class BlogPost {
  BlogPost({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.category,
    required this.date,
    required this.imageUrl,
    required this.content,
    required this.readMinutes,
    required this.tags,
  });

  final String id;
  final String title;
  final String excerpt;
  final String category;
  final String date;
  final String imageUrl;
  final String content;
  final int readMinutes;
  final List<String> tags;
}
