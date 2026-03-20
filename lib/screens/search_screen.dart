/// 搜索页 - 关键词搜索文章
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/app-bar.dart';
import '../components/settings_button.dart';
import '../components/article_card.dart';
import '../components/empty_view.dart';
import '../components/loading_view.dart';
import '../constants/app_constants.dart';
import '../constants/color.dart';
import '../core/app_typography.dart';
import '../repositories/blog_repository.dart';
import '../models/blog_post.dart';
import '../routes/app_router.dart';
import 'article_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _scrollController = ScrollController();
  Future<List<BlogPost>>? _searchFuture;
  String _lastKeyword = '';
  static const double _showBackToTopThreshold = 400;
  bool _showBackToTop = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
    _searchFuture = _fetchFirstPagePosts();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) _doSearch(_searchController.text);
    });
    setState(() {});
  }

  Future<List<BlogPost>> _fetchFirstPagePosts() async {
    final data = await BlogRepository.instance.getHomeData(page: 1);
    return BlogRepository.instance.parsePostsFromHomeData(data);
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
    if (keyword.trim().isEmpty) {
      setState(() {
        _searchFuture = _fetchFirstPagePosts();
        _lastKeyword = '';
      });
      return;
    }
    setState(() {
      _lastKeyword = keyword.trim();
      _searchFuture = BlogRepository.instance.search(_lastKeyword);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                setState(() {
                                  _searchFuture = _fetchFirstPagePosts();
                                  _lastKeyword = '';
                                });
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
                  if (_searchFuture != null)
                    FutureBuilder<List<BlogPost>>(
                      future: _searchFuture!,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(32),
                            child: LoadingView(),
                          );
                        }
                        final posts = snapshot.data ?? [];
                        if (posts.isEmpty) {
                          return EmptyView(
                            message: _lastKeyword.isEmpty
                                ? '暂无文章'
                                : '未找到与「$_lastKeyword」相关的文章',
                            icon: Icons.search_off_rounded,
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _lastKeyword.isEmpty
                                  ? '最新文章 (${posts.length})'
                                  : '找到 ${posts.length} 篇相关文章',
                              style: AppTypography.displayMedium(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
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
                                metadataFormat:
                                    ArticleCardMetadataFormat.categoryDate,
                              ),
                            ),
                          ],
                        );
                      },
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

  Widget _buildAppBar(BuildContext context) {
    return OwAppBar(
      title: '$appName - 搜索',
      floating: false,
      leading: const SettingsButton(),
    );
  }
}
