/// Article detail controller and state
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/blog_post.dart';
import '../models/comment.dart';
import '../repositories/blog_repository.dart';
import '../services/favorite_service.dart';
import 'providers.dart';

class ArticleDetailState {
  const ArticleDetailState({
    required this.post,
    required this.comments,
    required this.profile,
    required this.isFavorite,
  });

  final BlogPost post;
  final List<Comment> comments;
  final Map<String, dynamic> profile;
  final bool isFavorite;

  ArticleDetailState copyWith({
    BlogPost? post,
    List<Comment>? comments,
    Map<String, dynamic>? profile,
    bool? isFavorite,
  }) {
    return ArticleDetailState(
      post: post ?? this.post,
      comments: comments ?? this.comments,
      profile: profile ?? this.profile,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class ArticleDetailController
    extends StateNotifier<AsyncValue<ArticleDetailState>> {
  ArticleDetailController(this._repo) : super(const AsyncValue.loading());

  final BlogRepository _repo;

  Future<void> load({required String postId, BlogPost? initial}) async {
    state = const AsyncValue.loading();
    try {
      final post = initial ?? await _fetchPost(postId);
      final comments = await _repo.getComments(postId);
      final profile = await _repo.getProfile(userId: post.authorId);
      final isFav = FavoriteService.instance.isFavorite(postId);
      state = AsyncValue.data(
        ArticleDetailState(
          post: post,
          comments: comments,
          profile: profile,
          isFavorite: isFav,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleFavorite() async {
    final value = state.valueOrNull;
    if (value == null) return;
    await FavoriteService.instance.toggle(value.post.id);
    state = AsyncValue.data(
      value.copyWith(
        isFavorite: FavoriteService.instance.isFavorite(value.post.id),
      ),
    );
  }

  Future<void> addComment(Comment comment) async {
    final value = state.valueOrNull;
    if (value == null) return;
    _repo.addLocalComment(value.post.id, comment);
    state = AsyncValue.data(
      value.copyWith(comments: [...value.comments, comment]),
    );
  }

  Future<BlogPost> _fetchPost(String postId) async {
    final posts = await _repo.getPosts();
    return posts.firstWhere((p) => p.id == postId);
  }
}

final articleDetailControllerProvider =
    StateNotifierProvider<ArticleDetailController, AsyncValue<ArticleDetailState>>(
  (ref) => ArticleDetailController(ref.read(blogRepositoryProvider)),
);
