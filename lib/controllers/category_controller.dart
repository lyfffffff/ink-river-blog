/// Category controller and state
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/blog_post.dart';
import '../repositories/blog_repository.dart';
import 'providers.dart';

class CategoryState {
  const CategoryState({
    required this.categories,
    required this.selected,
    required this.posts,
  });

  final List<String> categories;
  final String selected;
  final List<BlogPost> posts;

  CategoryState copyWith({
    List<String>? categories,
    String? selected,
    List<BlogPost>? posts,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      selected: selected ?? this.selected,
      posts: posts ?? this.posts,
    );
  }
}

class CategoryController extends StateNotifier<AsyncValue<CategoryState>> {
  CategoryController(this._repo) : super(const AsyncValue.loading()) {
    load();
  }

  final BlogRepository _repo;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final categories = await _repo.getCategoriesWithPosts();
      final selected = categories.isNotEmpty ? categories.first : '';
      final posts = selected.isNotEmpty
          ? await _repo.getPostsByCategory(selected)
          : <BlogPost>[];
      state = AsyncValue.data(
        CategoryState(categories: categories, selected: selected, posts: posts),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> selectCategory(String category) async {
    final current = state.valueOrNull;
    state = const AsyncValue.loading();
    try {
      final posts = await _repo.getPostsByCategory(category);
      state = AsyncValue.data(
        CategoryState(
          categories: current?.categories ?? [category],
          selected: category,
          posts: posts,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final categoryControllerProvider =
    StateNotifierProvider<CategoryController, AsyncValue<CategoryState>>(
  (ref) => CategoryController(ref.read(blogRepositoryProvider)),
);
