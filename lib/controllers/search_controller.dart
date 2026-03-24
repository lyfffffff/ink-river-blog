/// Search controller and state
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/blog_post.dart';
import '../repositories/blog_repository.dart';
import 'providers.dart';

class SearchState {
  const SearchState({
    required this.keyword,
    required this.results,
  });

  final String keyword;
  final List<BlogPost> results;

  SearchState copyWith({String? keyword, List<BlogPost>? results}) {
    return SearchState(
      keyword: keyword ?? this.keyword,
      results: results ?? this.results,
    );
  }
}

class SearchController extends StateNotifier<AsyncValue<SearchState>> {
  SearchController(this._repo) : super(const AsyncValue.loading()) {
    search('');
  }

  final BlogRepository _repo;

  Future<void> search(String keyword) async {
    state = const AsyncValue.loading();
    try {
      final results = await _repo.search(keyword);
      state = AsyncValue.data(SearchState(keyword: keyword, results: results));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final searchControllerProvider =
    StateNotifierProvider<SearchController, AsyncValue<SearchState>>(
  (ref) => SearchController(ref.read(blogRepositoryProvider)),
);
