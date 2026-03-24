/// Local data source for Web (in-memory)
library;

import '../../models/blog_post.dart';
import '../../models/comment.dart';
import 'local_change.dart';
import 'user_record.dart';

class LocalDataSource {
  LocalDataSource._();

  static final LocalDataSource instance = LocalDataSource._();

  final Map<String, BlogPost> _posts = {};
  final Map<String, List<Comment>> _commentsByPost = {};
  final Set<String> _favoriteIds = {};
  final Map<String, UserRecord> _users = {};
  final List<LocalChange> _changes = [];

  // Posts
  Future<List<BlogPost>> getPosts() async => _posts.values.toList();

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
    return List<Comment>.from(_commentsByPost[postId] ?? const <Comment>[]);
  }

  Future<void> upsertComments(String postId, List<Comment> comments) async {
    _commentsByPost[postId] = List<Comment>.from(comments);
  }

  Future<void> upsertComment(String postId, Comment comment) async {
    final list = _commentsByPost.putIfAbsent(postId, () => <Comment>[]);
    list.add(comment);
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
    _changes.add(change);
  }

  Future<List<LocalChange>> getLocalChanges() async => List<LocalChange>.from(_changes);

  Future<void> clearLocalChanges() async {
    _changes.clear();
  }
}
