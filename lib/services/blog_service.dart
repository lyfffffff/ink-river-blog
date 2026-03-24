/// 博客文章服务
///
/// 封装 /edit、/save、/remove 等文章 API
library;

import 'dart:convert';

import '../data/mock_api_data.dart' as api;
import '../models/blog_post.dart';
import '../data/local/local_data_source.dart';
import '../data/local/local_change.dart';
import '../services/permission_service.dart';

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
    final canManage = await _canManage(id);
    if (!canManage) return false;
    final res = await api.saveArticle(id, article);
    final ok = res['code'] == 200;
    if (ok) {
      final payload = {'id': id, ...article};
      await _recordChange(
        entityType: 'post',
        entityId: id,
        changeType: 'update',
        payload: payload,
      );
    }
    return ok;
  }

  /// /remove 删除文章
  /// 参数：文章 id
  static Future<bool> removeArticle(String id) async {
    final canManage = await _canManage(id);
    if (!canManage) return false;
    final res = await api.removeArticle(id);
    final ok = res['code'] == 200;
    if (ok) {
      await _recordChange(
        entityType: 'post',
        entityId: id,
        changeType: 'delete',
        payload: {'id': id},
      );
    }
    return ok;
  }

  static Future<void> _recordChange({
    required String entityType,
    required String entityId,
    required String changeType,
    required Map<String, dynamic> payload,
  }) async {
    final change = LocalChange(
      entityType: entityType,
      entityId: entityId,
      changeType: changeType,
      payloadJson: jsonEncode(payload),
    );
    await LocalDataSource.instance.addLocalChange(change);
  }

  static Future<bool> _canManage(String postId) async {
    if (!PermissionService.canFavorite()) return false;
    final entity = await LocalDataSource.instance.getPostById(postId);
    if (entity == null) return false;
    return entity.authorId == PermissionService.currentUserId();
  }
}

BlogPost _postFromMap(Map<String, dynamic> m) => BlogPost(
      id: m['id'] as String,
      authorId: m['authorId']?.toString() ?? 'u_1',
      title: m['title'] as String,
      excerpt: m['excerpt'] as String,
      category: m['category'] as String,
      date: m['date'] as String,
      imageUrl: m['imageUrl'] as String,
      content: m['content'] as String,
      readMinutes: m['readMinutes'] as int,
      tags: List<String>.from(m['tags'] as List),
    );
