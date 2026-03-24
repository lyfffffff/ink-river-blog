/// Isar database initialization
library;

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'entities/post_entity.dart';
import 'entities/comment_entity.dart';
import 'entities/favorite_entity.dart';
import 'entities/user_entity.dart';
import 'entities/local_change_entity.dart';

class IsarDb {
  IsarDb._();

  static final IsarDb instance = IsarDb._();

  Isar? _isar;

  Future<Isar> get() async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        PostEntitySchema,
        CommentEntitySchema,
        FavoriteEntitySchema,
        UserEntitySchema,
        LocalChangeEntitySchema,
      ],
      directory: dir.path,
    );
    return _isar!;
  }

  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
