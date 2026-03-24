/// 博客数据仓库
///
/// Local-first 数据入口，封装 LocalDataSource 与 RemoteDataSource
library;

import 'dart:convert';

import '../data/local/local_data_source.dart';
import '../data/local/local_change.dart';
import '../data/local/user_record.dart';
import '../data/remote/remote_data_source.dart';
import '../models/blog_post.dart';
import '../models/comment.dart';
import '../data/mock_data.dart';

/// 博客仓库
class BlogRepository {
  BlogRepository._();

  static final BlogRepository instance = BlogRepository._();

  static const int _pageSize = 10;

  final LocalDataSource _local = LocalDataSource.instance;
  final RemoteDataSource _remote = RemoteDataSource.instance;

  /// 首页数据（分页）
  Future<Map<String, dynamic>> getHomeData({int page = 1}) async {
    final localPosts = await _local.getPosts();
    if (localPosts.isNotEmpty) {
      refreshPosts();
      return _buildHomeData(localPosts, page: page);
    }

    try {
      final remote = await _remote.fetchPostsPage(page, _pageSize);
      final merged = await _applyLocalChanges(remote);
      await _cachePosts(merged);
      return _buildHomeData(merged, page: page);
    } catch (_) {
      return _buildHomeData(const <BlogPost>[], page: page);
    }
  }

  /// 初始同步（首次启动）
  Future<void> syncInitialData() async {
    final localPosts = await _local.getPosts();
    if (localPosts.isNotEmpty) return;
    final remote = await _remote.fetchPostsPage(1, 100);
    final merged = await _applyLocalChanges(remote);
    await _cachePosts(merged);
  }

  /// 刷新缓存
  Future<void> refreshPosts() async {
    try {
      final remote = await _remote.fetchPostsPage(1, 100);
      final merged = await _applyLocalChanges(remote);
      await _cachePosts(merged);
    } catch (_) {}
  }

  /// 文章列表
  Future<List<BlogPost>> getPosts() async {
    final localPosts = await _local.getPosts();
    if (localPosts.isNotEmpty) {
      refreshPosts();
      return localPosts;
    }
    try {
      final remote = await _remote.fetchPostsPage(1, 100);
      final merged = await _applyLocalChanges(remote);
      await _cachePosts(merged);
      return merged;
    } catch (_) {
      return [];
    }
  }

  /// 按分类获取文章
  Future<List<BlogPost>> getPostsByCategory(String category) async {
    final posts = await getPosts();
    return posts.where((p) => p.category == category).toList();
  }

  /// 搜索文章
  Future<List<BlogPost>> search(String keyword) async {
    final k = keyword.trim().toLowerCase();
    if (k.isEmpty) return getPosts();
    final posts = await getPosts();
    return posts.where((p) {
      if (p.title.toLowerCase().contains(k)) return true;
      if (p.excerpt.toLowerCase().contains(k)) return true;
      if (p.content.toLowerCase().contains(k)) return true;
      if (p.tags.any((t) => t.toLowerCase().contains(k))) return true;
      return false;
    }).toList();
  }

  /// 分类列表
  Future<List<String>> getCategoriesWithPosts() async {
    final posts = await getPosts();
    final set = <String>{};
    for (final p in posts) {
      set.add(p.category);
    }
    final categories = set.toList()..sort();
    return categories.isNotEmpty
        ? categories
        : blogInfo['categories'] as List<String>;
  }

  /// 用户资料
  Future<Map<String, dynamic>> getProfile({String? userId}) async {
    final id = (userId == null || userId.isEmpty) ? '1' : userId;
    final local = await _local.getUserById(id);
    if (local != null) {
      return _userToProfileMap(local);
    }
    try {
      final profile = await _remote.fetchUser(id);
      if (profile.isNotEmpty) {
        final user = UserRecord(
          userId: id,
          name: profile['name'] as String? ?? '',
          subtitle: profile['subtitle'] as String? ?? '',
          quote: profile['quote'] as String? ?? '',
          avatarUrl: profile['avatarUrl'] as String? ?? '',
          aboutAvatarUrl: profile['aboutAvatarUrl'] as String? ?? '',
          aboutSubtitle: profile['aboutSubtitle'] as String? ?? '',
        );
        await _local.upsertUser(user);
        return _userToProfileMap(user);
      }
    } catch (_) {}
    return _fallbackProfile(id);
  }

  /// 文章评论
  Future<List<Comment>> getComments(String postId) async {
    final local = await _local.getCommentsByPostId(postId);
    if (local.isNotEmpty) {
      return local;
    }
    try {
      final remote = await _remote.fetchComments(postId);
      await _local.upsertComments(postId, remote);
      return remote;
    } catch (_) {
      return local;
    }
  }

  /// 从首页数据解析文章列表（兼容旧接口）
  List<BlogPost> parsePostsFromHomeData(Map<String, dynamic> data) {
    final raw = data['posts'] as List? ?? [];
    return raw.map((e) {
      if (e is BlogPost) return e;
      return _postFromJsonMap(e as Map<String, dynamic>);
    }).toList();
  }

  /// 添加本地评论（会话有效）
  void addLocalComment(String postId, Comment comment) {
    _local.upsertComment(postId, comment);
  }

  Future<void> _cachePosts(List<BlogPost> posts) async {
    await _local.upsertPosts(posts);
  }

  Map<String, dynamic> _userToProfileMap(UserRecord user) => {
        'id': user.userId,
        'name': user.name,
        'subtitle': user.subtitle,
        'quote': user.quote,
        'avatarUrl': user.avatarUrl,
        'aboutAvatarUrl': user.aboutAvatarUrl,
        'aboutSubtitle': user.aboutSubtitle,
        'introParagraphs': userInfo['introParagraphs'],
        'skills': userInfo['skills'],
        'timeline': userInfo['timeline'],
      };

  Map<String, dynamic> _fallbackProfile(String userId) {
    if (userId == '1') {
      return {
        'id': userId,
        'name': userInfo['name'],
        'subtitle': userInfo['subtitle'],
        'quote': userInfo['quote'],
        'avatarUrl': userInfo['avatarUrl'],
        'aboutAvatarUrl': userInfo['aboutAvatarUrl'],
        'aboutSubtitle': userInfo['aboutSubtitle'],
        'introParagraphs': userInfo['introParagraphs'],
        'skills': userInfo['skills'],
        'timeline': userInfo['timeline'],
      };
    }
    return {
      'id': userId,
      'name': '作者 $userId',
      'subtitle': '',
      'quote': '',
      'avatarUrl': '',
      'aboutAvatarUrl': '',
      'aboutSubtitle': '',
      'introParagraphs': const <String>[],
      'skills': const <Map<String, dynamic>>[],
      'timeline': const <Map<String, dynamic>>[],
    };
  }

  Map<String, dynamic> _buildHomeData(List<BlogPost> posts, {required int page}) {
    final totalCount = posts.length;
    final start = (page - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, totalCount);
    final pagePosts = start < totalCount ? posts.sublist(start, end) : <BlogPost>[];
    final categories = posts.map((p) => p.category).toSet().toList()..sort();
    return {
      'user': {
        'id': '1',
        'nickname': userInfo['name'],
        'avatarUrl': userInfo['avatarUrl'],
        'subtitle': userInfo['subtitle'],
      },
      'posts': pagePosts,
      'categories': categories.isNotEmpty ? categories : blogInfo['categories'],
      'page': page,
      'totalCount': totalCount,
      'hasNext': end < totalCount,
    };
  }

  Future<List<BlogPost>> _applyLocalChanges(List<BlogPost> remote) async {
    final changes = await _local.getLocalChanges();
    if (changes.isEmpty) return remote;

    final map = {for (final p in remote) p.id: p};
    for (final change in changes) {
      if (change.entityType != 'post') continue;
      if (change.changeType == 'delete') {
        map.remove(change.entityId);
        continue;
      }
      if (change.changeType == 'update' || change.changeType == 'create') {
        final decoded = jsonDecode(change.payloadJson) as Map<String, dynamic>;
        final post = _postFromJsonMap(decoded);
        map[post.id] = post;
      }
    }
    return map.values.toList();
  }
}

BlogPost _postFromJsonMap(Map<String, dynamic> m) => BlogPost(
      id: m['id']?.toString() ?? '',
      authorId: m['authorId']?.toString() ?? 'u_1',
      title: m['title'] as String? ?? '',
      excerpt: m['excerpt'] as String? ?? '',
      category: m['category'] as String? ?? '未分类',
      date: m['date'] as String? ?? '',
      imageUrl: m['imageUrl'] as String? ?? '',
      content: m['content'] as String? ?? '',
      readMinutes: m['readMinutes'] as int? ?? 5,
      tags: m['tags'] != null ? List<String>.from(m['tags'] as List) : <String>[],
    );
