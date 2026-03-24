/// Local data source backed by Isar
library;

import 'package:isar/isar.dart';

import 'isar_db.dart';
import 'entities/post_entity.dart';
import 'entities/comment_entity.dart';
import 'entities/favorite_entity.dart';
import 'entities/user_entity.dart';
import 'entities/local_change_entity.dart';

class LocalDataSource {
  LocalDataSource._();

  static final LocalDataSource instance = LocalDataSource._();

  Future<Isar> get _isar async => IsarDb.instance.get();

  // Posts
  Future<List<PostEntity>> getPosts() async {
    final isar = await _isar;
    return isar.postEntitys.where().findAll();
  }

  Future<PostEntity?> getPostById(String postId) async {
    final isar = await _isar;
    return isar.postEntitys.filter().postIdEqualTo(postId).findFirst();
  }

  Future<void> upsertPosts(List<PostEntity> posts) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.postEntitys.putAll(posts);
    });
  }

  Future<void> upsertPost(PostEntity post) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.postEntitys.put(post);
    });
  }

  Future<bool> deletePostById(String postId) async {
    final isar = await _isar;
    final entity = await getPostById(postId);
    if (entity == null) return false;
    return isar.writeTxn(() async => isar.postEntitys.delete(entity.id));
  }

  // Comments
  Future<List<CommentEntity>> getCommentsByPostId(String postId) async {
    final isar = await _isar;
    return isar.commentEntitys.filter().postIdEqualTo(postId).findAll();
  }

  Future<void> upsertComments(List<CommentEntity> comments) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.commentEntitys.putAll(comments);
    });
  }

  Future<void> upsertComment(CommentEntity comment) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.commentEntitys.put(comment);
    });
  }

  // Favorites
  Future<List<FavoriteEntity>> getFavorites() async {
    final isar = await _isar;
    return isar.favoriteEntitys.where().findAll();
  }

  Future<FavoriteEntity?> getFavorite(String postId) async {
    final isar = await _isar;
    return isar.favoriteEntitys.filter().postIdEqualTo(postId).findFirst();
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
    final entity = await getFavorite(postId);
    if (entity == null) return false;
    return isar.writeTxn(() async => isar.favoriteEntitys.delete(entity.id));
  }

  // Users
  Future<UserEntity?> getUserById(String userId) async {
    final isar = await _isar;
    return isar.userEntitys.filter().userIdEqualTo(userId).findFirst();
  }

  Future<void> upsertUser(UserEntity user) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.userEntitys.put(user);
    });
  }

  // Local changes
  Future<void> addLocalChange(LocalChangeEntity change) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.localChangeEntitys.put(change);
    });
  }

  Future<List<LocalChangeEntity>> getLocalChanges() async {
    final isar = await _isar;
    return isar.localChangeEntitys.where().findAll();
  }

  Future<void> clearLocalChanges() async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.localChangeEntitys.clear();
    });
  }
}
