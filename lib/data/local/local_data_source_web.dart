/// Local data source for Web (SharedPreferences-backed)
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/blog_post.dart';
import '../../models/comment.dart';
import 'local_change.dart';
import 'user_record.dart';

class LocalDataSource {
  LocalDataSource._();

  static final LocalDataSource instance = LocalDataSource._();

  static const String _kCommentsKey = 'local_comments_by_post';
  static const String _kChangesKey = 'local_change_list';

  final Map<String, BlogPost> _posts = {};
  final Map<String, List<Comment>> _commentsByPost = {};
  final Set<String> _favoriteIds = {};
  final Map<String, UserRecord> _users = {};
  final List<LocalChange> _changes = [];
  bool _loaded = false;
  Future<void>? _loadFuture;

  Future<void> _ensureLoaded() {
    if (_loaded) return Future.value();
    _loadFuture ??= _load();
    return _loadFuture!;
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final commentsJson = prefs.getString(_kCommentsKey);
      if (commentsJson != null && commentsJson.isNotEmpty) {
        final decoded = jsonDecode(commentsJson);
        if (decoded is Map<String, dynamic>) {
          decoded.forEach((key, value) {
            if (value is List) {
              _commentsByPost[key] = value
                  .whereType<Map>()
                  .map((e) => _commentFromMap(Map<String, dynamic>.from(e)))
                  .toList();
            }
          });
        }
      }

      final changesJson = prefs.getString(_kChangesKey);
      if (changesJson != null && changesJson.isNotEmpty) {
        final decoded = jsonDecode(changesJson);
        if (decoded is List) {
          _changes
            ..clear()
            ..addAll(decoded
                .whereType<Map>()
                .map((e) => _changeFromMap(Map<String, dynamic>.from(e))));
        }
      }
    } catch (_) {
      // ignore corrupted cache
    } finally {
      _loaded = true;
    }
  }

  Future<void> _saveComments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _commentsByPost.map(
        (key, value) => MapEntry(key, value.map(_commentToMap).toList()),
      );
      await prefs.setString(_kCommentsKey, jsonEncode(data));
    } catch (_) {}
  }

  Future<void> _saveChanges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _kChangesKey,
        jsonEncode(_changes.map(_changeToMap).toList()),
      );
    } catch (_) {}
  }

  // Posts
  Future<List<BlogPost>> getPosts() async {
    return _posts.values.toList();
  }

  Future<BlogPost?> getPostById(String postId) async => _posts[postId];

  Future<void> upsertPosts(List<BlogPost> posts) async {
    for (final post in posts) {
      _posts[post.id] = post;
    }
  }

  Future<void> upsertPost(BlogPost post) async {
    _posts[post.id] = post;
  }

  Future<bool> deletePostById(String postId) async {
    return _posts.remove(postId) != null;
  }

  // Comments
  Future<List<Comment>> getCommentsByPostId(String postId) async {
    await _ensureLoaded();
    return List<Comment>.from(_commentsByPost[postId] ?? const <Comment>[]);
  }

  Future<void> upsertComments(String postId, List<Comment> comments) async {
    await _ensureLoaded();
    _commentsByPost[postId] = List<Comment>.from(comments);
    await _saveComments();
  }

  Future<void> upsertComment(String postId, Comment comment) async {
    await _ensureLoaded();
    final list = _commentsByPost.putIfAbsent(postId, () => <Comment>[]);
    list.add(comment);
    await _saveComments();
  }

  // Favorites
  Future<Set<String>> getFavoriteIds() async => Set<String>.from(_favoriteIds);

  Future<bool> isFavorite(String postId) async => _favoriteIds.contains(postId);

  Future<void> addFavorite(String postId) async {
    _favoriteIds.add(postId);
  }

  Future<bool> removeFavorite(String postId) async {
    return _favoriteIds.remove(postId);
  }

  // Users
  Future<UserRecord?> getUserById(String userId) async => _users[userId];

  Future<void> upsertUser(UserRecord user) async {
    _users[user.userId] = user;
  }

  // Local changes
  Future<void> addLocalChange(LocalChange change) async {
    await _ensureLoaded();
    _changes.add(change);
    await _saveChanges();
  }

  Future<List<LocalChange>> getLocalChanges({String? userId}) async {
    await _ensureLoaded();
    if (userId == null || userId.isEmpty) {
      return List<LocalChange>.from(_changes);
    }
    return _changes.where((c) => c.userId == userId).toList();
  }

  Future<void> clearLocalChanges() async {
    await _ensureLoaded();
    _changes.clear();
    await _saveChanges();
  }
}

Map<String, dynamic> _commentToMap(Comment c) => {
      'id': c.id,
      'authorName': c.authorName,
      'authorInitial': c.authorInitial,
      'content': c.content,
      'timeAgo': c.timeAgo,
      'likeCount': c.likeCount,
    };

Comment _commentFromMap(Map<String, dynamic> m) => Comment(
      id: m['id']?.toString() ?? '',
      authorName: m['authorName'] as String? ?? 'Anonymous',
      authorInitial: m['authorInitial'] as String? ?? '?',
      content: m['content'] as String? ?? '',
      timeAgo: m['timeAgo'] as String? ?? '',
      likeCount: m['likeCount'] as int? ?? 0,
    );

Map<String, dynamic> _changeToMap(LocalChange c) => {
      'userId': c.userId,
      'entityType': c.entityType,
      'entityId': c.entityId,
      'changeType': c.changeType,
      'payloadJson': c.payloadJson,
      'createdAt': c.createdAt.toIso8601String(),
    };

LocalChange _changeFromMap(Map<String, dynamic> m) => LocalChange(
      userId: m['userId']?.toString() ?? '',
      entityType: m['entityType']?.toString() ?? '',
      entityId: m['entityId']?.toString() ?? '',
      changeType: m['changeType']?.toString() ?? '',
      payloadJson: m['payloadJson']?.toString() ?? '{}',
      createdAt: DateTime.tryParse(m['createdAt']?.toString() ?? ''),
    );
