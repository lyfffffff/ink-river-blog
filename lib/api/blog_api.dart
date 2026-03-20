/// 博客 API - 真实 HTTP 请求
///
/// 基于 JSONPlaceholder 的数据映射与接口调用
library;

import 'dart:math';

import '../data/mock_data.dart';
import '../models/blog_post.dart';
import '../models/comment.dart';

import 'api_client.dart';
import 'api_config.dart';

/// 博客 API
class BlogApi {
  BlogApi._();

  static final BlogApi _instance = BlogApi._();
  static BlogApi get instance => _instance;

  /// 获取文章列表 GET /posts
  static Future<List<BlogPost>> fetchPosts() async {
    return fetchPostsPage(1, 100);
  }

  /// 获取文章列表分页 GET /posts?_page=&_limit=
  static Future<List<BlogPost>> fetchPostsPage(int page, int limit) async {
    final res = await ApiClient.instance.get(
      ApiConfig.postsPagePath(page, limit),
    );
    if (res['code'] != 200 || res['data'] == null) {
      return [];
    }
    final data = res['data'];
    if (data is! List) return [];
    return data.map((e) => _postFromMap(e as Map<String, dynamic>)).toList();
  }

  /// 解析为 BlogPost
  /// 兼容标准格式与 JSONPlaceholder 格式
  static BlogPost _postFromMap(Map<String, dynamic> m) {
    final id = m['id'];
    if (id is int) {
      return _fromJsonPlaceholder(m);
    }
    return _fromStandard(m);
  }

  /// 标准格式: id, title, excerpt, category, date, imageUrl, content, readMinutes, tags
  static BlogPost _fromStandard(Map<String, dynamic> m) => BlogPost(
        id: m['id']?.toString() ?? '',
        title: m['title'] as String? ?? '',
        excerpt: m['excerpt'] as String? ?? '',
        category: m['category'] as String? ?? '未分类',
        date: m['date'] as String? ?? '',
        imageUrl: m['imageUrl'] as String? ?? 'https://via.placeholder.com/400x225',
        content: m['content'] as String? ?? '',
        readMinutes: m['readMinutes'] as int? ?? 5,
        tags: m['tags'] != null ? List<String>.from(m['tags'] as List) : [],
      );

  /// JSONPlaceholder 格式: id, userId, title, body
  /// 根据文章 id 确定性随机分配分类和 1-3 个标签
  static BlogPost _fromJsonPlaceholder(Map<String, dynamic> m) {
    final id = m['id'];
    final seed = id is int ? id : id.hashCode;
    final rnd = Random(seed);
    final category =
        categoryList[rnd.nextInt(categoryList.length)];
    final tagCount = 1 + rnd.nextInt(3);
    final tags = tagsList.toList()..shuffle(rnd);
    final postTags = tags.take(tagCount).toList();
    return BlogPost(
      id: m['id']?.toString() ?? '',
      title: m['title'] as String? ?? '',
      excerpt: (m['body'] as String? ?? '').length > 80
          ? '${(m['body'] as String).substring(0, 80)}...'
          : (m['body'] as String? ?? ''),
      category: category,
      date: '2024',
      imageUrl: 'https://picsum.photos/400/225?random=${m['id']}',
      content: m['body'] as String? ?? '',
      readMinutes: 5,
      tags: postTags,
    );
  }

  /// 获取单篇文章 GET /posts/{id}
  static Future<BlogPost?> fetchPostById(String id) async {
    final res = await ApiClient.instance.get(ApiConfig.postPath(id));
    if (res['code'] != 200 || res['data'] == null) return null;
    final m = res['data'] as Map<String, dynamic>;
    return _postFromMap(m);
  }

  /// 获取文章评论 GET /posts/{postId}/comments
  /// JSONPlaceholder: id, postId, name, email, body
  static Future<List<Comment>> fetchComments(String postId) async {
    final res = await ApiClient.instance.get(ApiConfig.commentsPath(postId));
    if (res['code'] != 200 || res['data'] == null) return [];
    final data = res['data'];
    if (data is! List) return [];
    return data.map((e) => _commentFromMap(e as Map<String, dynamic>)).toList();
  }

  static Comment _commentFromMap(Map<String, dynamic> m) {
    final name = m['name'] as String? ?? 'Anonymous';
    return Comment(
      id: m['id']?.toString() ?? '',
      authorName: name,
      authorInitial: name.isNotEmpty ? name[0].toUpperCase() : '?',
      content: m['body'] as String? ?? '',
      timeAgo: 'recently',
      likeCount: 0,
    );
  }

  /// 获取用户信息 GET /users/{userId}
  /// JSONPlaceholder: id, name, username, email, phone, website, company
  /// 缺失字段用 Mock 补全
  static Future<Map<String, dynamic>> fetchUser(String userId) async {
    final res = await ApiClient.instance.get(ApiConfig.userPath(userId));
    if (res['code'] != 200 || res['data'] == null) return {};
    final m = res['data'] as Map<String, dynamic>;
    return _userToProfile(m);
  }

  static Map<String, dynamic> _userToProfile(Map<String, dynamic> m) {
    final name = m['name'] as String? ?? 'User';
    final company = m['company'] as Map<String, dynamic>?;
    final companyName = company?['name'] as String? ?? '';
    return {
      'name': name,
      'subtitle': companyName.isNotEmpty ? companyName : (m['username'] as String? ?? ''),
      'quote': '',
      'avatarUrl': 'https://i.pravatar.cc/128?u=${m['id']}',
      'aboutAvatarUrl': 'https://i.pravatar.cc/256?u=${m['id']}',
      'aboutSubtitle': m['email'] as String? ?? '',
      'introParagraphs': [
        'Hello, I am $name.',
        m['phone'] != null ? 'Contact: ${m['phone']}' : null,
        m['website'] != null ? 'Website: ${m['website']}' : null,
      ].whereType<String>().toList(),
      'skills': [],
      'timeline': [],
    };
  }
}
