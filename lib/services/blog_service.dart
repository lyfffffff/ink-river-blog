/// 博客文章服务
///
/// 封装 /edit、/save、/remove 等文章 API
library;

import '../data/mock_api_data.dart' as api;
import '../models/blog_post.dart';

/// 文章服务
class BlogService {
  BlogService._();

  /// /edit 获取文章详情（用于编辑）
  /// 参数：文章 id
  static Future<BlogPost?> getArticleForEdit(String id) async {
    final res = await api.editArticle(id);
    if (res['code'] != 200 || res['data'] == null) return null;
    return _postFromMap(res['data'] as Map<String, dynamic>);
  }

  /// /save 保存文章
  /// 参数：文章 id、文章详情
  static Future<bool> saveArticle(String id, Map<String, dynamic> article) async {
    final res = await api.saveArticle(id, article);
    return res['code'] == 200;
  }

  /// /remove 删除文章
  /// 参数：文章 id
  static Future<bool> removeArticle(String id) async {
    final res = await api.removeArticle(id);
    return res['code'] == 200;
  }
}

BlogPost _postFromMap(Map<String, dynamic> m) => BlogPost(
      id: m['id'] as String,
      title: m['title'] as String,
      excerpt: m['excerpt'] as String,
      category: m['category'] as String,
      date: m['date'] as String,
      imageUrl: m['imageUrl'] as String,
      content: m['content'] as String,
      readMinutes: m['readMinutes'] as int,
      tags: List<String>.from(m['tags'] as List),
    );
