/// Home controller and state
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/blog_post.dart';
import '../repositories/blog_repository.dart';
import 'providers.dart';

class HomeState {
  const HomeState({
    required this.user,
    required this.posts,
    required this.categories,
    required this.page,
    required this.totalCount,
    required this.hasNext,
    this.isLoadingMore = false,
    this.isRefreshing = false,
  });

  final Map<String, dynamic> user;
  final List<BlogPost> posts;
  final List<String> categories;
  final int page;
  final int totalCount;
  final bool hasNext;

  /// 翻页加载中（保留已有列表，底部显示 loading）
  final bool isLoadingMore;

  /// 下拉刷新中（保留已有列表，RefreshIndicator 显示指示器）
  final bool isRefreshing;

  HomeState copyWith({
    Map<String, dynamic>? user,
    List<BlogPost>? posts,
    List<String>? categories,
    int? page,
    int? totalCount,
    bool? hasNext,
    bool? isLoadingMore,
    bool? isRefreshing,
  }) {
    return HomeState(
      user: user ?? this.user,
      posts: posts ?? this.posts,
      categories: categories ?? this.categories,
      page: page ?? this.page,
      totalCount: totalCount ?? this.totalCount,
      hasNext: hasNext ?? this.hasNext,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  factory HomeState.fromMap(Map<String, dynamic> data) {
    return HomeState(
      user: data['user'] as Map<String, dynamic>? ?? {},
      posts: (data['posts'] as List? ?? []).cast<BlogPost>(),
      categories: (data['categories'] as List? ?? []).cast<String>(),
      page: data['page'] as int? ?? 1,
      totalCount: data['totalCount'] as int? ?? 0,
      hasNext: data['hasNext'] as bool? ?? false,
    );
  }
}

class HomeController extends StateNotifier<AsyncValue<HomeState>> {
  HomeController(this._repo) : super(const AsyncValue.loading()) {
    load(page: 1);
  }

  final BlogRepository _repo;

  Future<void> load({int page = 1}) async {
    final previous = state.valueOrNull;
    if (previous == null) {
      // 首次加载：显示骨架屏
      state = const AsyncValue.loading();
    } else {
      // 翻页或刷新时保留已有数据，避免全屏闪烁
      state = AsyncValue.data(
        previous.copyWith(
          isLoadingMore: page > 1,
          isRefreshing: page == 1,
        ),
      );
    }
    try {
      final data = await _repo.getHomeData(page: page);
      state = AsyncValue.data(HomeState.fromMap(data));
    } catch (e, st) {
      if (previous == null) {
        state = AsyncValue.error(e, st);
      } else {
        // 翻页/刷新失败时保留旧数据，仅清除加载态
        state = AsyncValue.data(
          previous.copyWith(isLoadingMore: false, isRefreshing: false),
        );
      }
    }
  }

  Future<void> refresh() async => load(page: 1);

  Future<void> goToPage(int page) async => load(page: page);
}

final homeControllerProvider =
    StateNotifierProvider<HomeController, AsyncValue<HomeState>>(
  (ref) => HomeController(ref.read(blogRepositoryProvider)),
);
