/// Local data source backed by Isar
library;

import 'package:isar/isar.dart';

import '../../models/blog_post.dart';
import '../../models/comment.dart';
import 'local_change.dart';
import 'user_record.dart';
import '../isar/isar_db.dart';
import '../isar/entities/post_entity.dart';
import '../isar/entities/comment_entity.dart';
import '../isar/entities/favorite_entity.dart';
import '../isar/entities/user_entity.dart';
import '../isar/entities/local_change_entity.dart';

class LocalDataSource {
  LocalDataSource._();

  static final LocalDataSource instance = LocalDataSource._();

  Future<Isar> get _isar async => IsarDb.instance.get();

  // Posts
  Future<List<BlogPost>> getPosts() async {
    final isar = await _isar;
    final entities = await isar.postEntitys.where().findAll();
    return entities.map(_postFromEntity).toList();
  }

  Future<BlogPost?> getPostById(String postId) async {
    final isar = await _isar;
    final entity = await isar.postEntitys.filter().postIdEqualTo(postId).findFirst();
    return entity == null ? null : _postFromEntity(entity);
  }

  Future<void> upsertPosts(List<BlogPost> posts) async {
    final isar = await _isar;
    final entities = posts.map(_postToEntity).toList();
    await isar.writeTxn(() async {
      await isar.postEntitys.putAll(entities);
    });
  }

  Future<void> upsertPost(BlogPost post) async {
    final isar = await _isar;
    final entity = _postToEntity(post);
    await isar.writeTxn(() async {
      await isar.postEntitys.put(entity);
    });
  }

  Future<bool> deletePostById(String postId) async {
    final isar = await _isar;
    final entity = await isar.postEntitys.filter().postIdEqualTo(postId).findFirst();
    if (entity == null) return false;
    return isar.writeTxn(() async => isar.postEntitys.delete(entity.id));
  }

  // Comments
  Future<List<Comment>> getCommentsByPostId(String postId) async {
    final isar = await _isar;
    final entities = await isar.commentEntitys.filter().postIdEqualTo(postId).findAll();
    return entities.map(_commentFromEntity).toList();
  }

  Future<void> upsertComments(String postId, List<Comment> comments) async {
    final isar = await _isar;
    final entities = comments.map((c) => _commentToEntity(c, postId)).toList();
    await isar.writeTxn(() async {
      await isar.commentEntitys.putAll(entities);
    });
  }

  Future<void> upsertComment(String postId, Comment comment) async {
    final isar = await _isar;
    final entity = _commentToEntity(comment, postId);
    await isar.writeTxn(() async {
      await isar.commentEntitys.put(entity);
    });
  }

  // Favorites
  Future<Set<String>> getFavoriteIds() async {
    final isar = await _isar;
    final favorites = await isar.favoriteEntitys.where().findAll();
    return favorites.map((e) => e.postId).toSet();
  }

  Future<bool> isFavorite(String postId) async {
    final isar = await _isar;
    final entity = await isar.favoriteEntitys.filter().postIdEqualTo(postId).findFirst();
    return entity != null;
  }

  Future<void> addFavorite(String postId) async {
    final isar = await _isar;
    final entity = FavoriteEntity()
      ..postId = postId
      ..createdAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.favoriteEntitys.put(entity);
    });
  }

  Future<bool> removeFavorite(String postId) async {
    final isar = await _isar;
    final entity = await isar.favoriteEntitys.filter().postIdEqualTo(postId).findFirst();
    if (entity == null) return false;
    return isar.writeTxn(() async => isar.favoriteEntitys.delete(entity.id));
  }

  // Users
  Future<UserRecord?> getUserById(String userId) async {
    final isar = await _isar;
    final entity = await isar.userEntitys.filter().userIdEqualTo(userId).findFirst();
    if (entity == null) return null;
    return _userFromEntity(entity);
  }

  Future<void> upsertUser(UserRecord user) async {
    final isar = await _isar;
    final entity = _userToEntity(user);
    await isar.writeTxn(() async {
      await isar.userEntitys.put(entity);
    });
  }

  // Local changes
  Future<void> addLocalChange(LocalChange change) async {
    final isar = await _isar;
    final entity = _changeToEntity(change);
    await isar.writeTxn(() async {
      await isar.localChangeEntitys.put(entity);
    });
  }

  Future<List<LocalChange>> getLocalChanges({String? userId}) async {
    final isar = await _isar;
    final entities = (userId == null || userId.isEmpty)
        ? await isar.localChangeEntitys.where().findAll()
        : await isar.localChangeEntitys
            .filter()
            .userIdEqualTo(userId)
            .findAll();
    return entities.map(_changeFromEntity).toList();
  }

  Future<void> clearLocalChanges() async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.localChangeEntitys.clear();
    });
  }
}

PostEntity _postToEntity(BlogPost post) => PostEntity()
  ..postId = post.id
  ..authorId = post.authorId
  ..title = post.title
  ..excerpt = post.excerpt
  ..category = post.category
  ..date = post.date
  ..imageUrl = post.imageUrl
  ..content = post.content
  ..readMinutes = post.readMinutes
  ..tags = post.tags
  ..updatedAt = DateTime.now();

BlogPost _postFromEntity(PostEntity e) => BlogPost(
      id: e.postId,
      authorId: e.authorId,
      title: e.title,
      excerpt: e.excerpt,
      category: e.category,
      date: e.date,
      imageUrl: e.imageUrl,
      content: e.content,
      readMinutes: e.readMinutes,
      tags: e.tags,
    );

CommentEntity _commentToEntity(Comment c, String postId) => CommentEntity()
  ..commentId = c.id
  ..postId = postId
  ..authorName = c.authorName
  ..authorInitial = c.authorInitial
  ..content = c.content
  ..timeAgo = c.timeAgo
  ..likeCount = c.likeCount
  ..createdAt = DateTime.now();

Comment _commentFromEntity(CommentEntity e) => Comment(
      id: e.commentId,
      authorName: e.authorName,
      authorInitial: e.authorInitial,
      content: e.content,
      timeAgo: e.timeAgo,
      likeCount: e.likeCount,
    );

UserEntity _userToEntity(UserRecord user) => UserEntity()
  ..userId = user.userId
  ..name = user.name
  ..subtitle = user.subtitle
  ..quote = user.quote
  ..avatarUrl = user.avatarUrl
  ..aboutAvatarUrl = user.aboutAvatarUrl
  ..aboutSubtitle = user.aboutSubtitle
  ..updatedAt = user.updatedAt;

UserRecord _userFromEntity(UserEntity e) => UserRecord(
      userId: e.userId,
      name: e.name,
      subtitle: e.subtitle,
      quote: e.quote,
      avatarUrl: e.avatarUrl,
      aboutAvatarUrl: e.aboutAvatarUrl,
      aboutSubtitle: e.aboutSubtitle,
      updatedAt: e.updatedAt,
    );

LocalChangeEntity _changeToEntity(LocalChange change) => LocalChangeEntity()
  ..userId = change.userId
  ..entityType = change.entityType
  ..entityId = change.entityId
  ..changeType = change.changeType
  ..payloadJson = change.payloadJson
  ..createdAt = change.createdAt;

LocalChange _changeFromEntity(LocalChangeEntity e) => LocalChange(
      userId: e.userId,
      entityType: e.entityType,
      entityId: e.entityId,
      changeType: e.changeType,
      payloadJson: e.payloadJson,
      createdAt: e.createdAt,
    );
