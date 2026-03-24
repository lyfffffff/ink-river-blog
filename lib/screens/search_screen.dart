/// 搜索页 - 关键词搜索文章
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/app-bar.dart';
import '../components/settings_button.dart';
import '../components/article_card.dart';
import '../components/empty_view.dart';
import '../components/loading_view.dart';
import '../constants/app_constants.dart';
import '../constants/color.dart';
import '../core/app_typography.dart';
import '../controllers/search_controller.dart';
import '../models/blog_post.dart';
import '../routes/app_router.dart';
import 'article_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _scrollController = ScrollController();
  static const double _showBackToTopThreshold = 400;
  bool _showBackToTop = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) _doSearch(_searchController.text);
    });
    setState(() {});
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final show = _scrollController.offset >= _showBackToTopThreshold;
    if (show != _showBackToTop) {
      setState(() => _showBackToTop = show);
    }
  }

  void _doSearch(String keyword) {
    ref.read(searchControllerProvider.notifier).search(keyword);
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(searchControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: '搜索文章标题、内容、标签...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded),
                                  onPressed: () {
                                    _searchController.clear();
                                    _doSearch('');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: _doSearch,
                        onChanged: (v) {
                          if (v.isEmpty) _doSearch('');
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => _doSearch(_searchController.text),
                              icon: const Icon(Icons.search_rounded, size: 20),
                              label: const Text('搜索'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      searchAsync.when(
                        loading: () => const Padding(
                          padding: EdgeInsets.all(32),
                          child: LoadingView(),
                        ),
                        error: (_, __) => const EmptyView(
                          message: '搜索失败，请重试',
                          icon: Icons.search_off_rounded,
                        ),
                        data: (state) => _buildResults(
                          context,
                          state.keyword,
                          state.results,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_showBackToTop)
            Positioned(
              right: 24,
              bottom: 24,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(28),
                child: InkWell(
                  onTap: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                    );
                  },
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResults(
    BuildContext context,
    String keyword,
    List<BlogPost> posts,
  ) {
    if (posts.isEmpty) {
      return EmptyView(
        message: keyword.isEmpty ? '暂无文章' : '未找到与「$keyword」相关的文章',
        icon: Icons.search_off_rounded,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          keyword.isEmpty ? '最新文章 (${posts.length})' : '找到 ${posts.length} 篇相关文章',
          style: AppTypography.displayMedium(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        ...posts.map(
          (post) => ArticleCard(
            post: post,
            onTap: () => context.push(
              '/article/${post.id}',
              extra: ArticleDetailArgs(
                post: post,
                allPosts: posts,
                page: 1,
                hasNext: false,
                totalCount: posts.length,
              ),
            ),
            metadataFormat: ArticleCardMetadataFormat.categoryDate,
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return OwAppBar(
      title: '$appName - 搜索',
      floating: false,
      leading: const SettingsButton(),
    );
  }
}
