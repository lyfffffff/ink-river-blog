/// 首页 - 博客列表
///
/// 数据通过 mock API 请求获取
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/app-bar.dart';
import '../components/error_view.dart';
import '../components/loading_view.dart';
import '../constants/app_constants.dart';
import '../constants/color.dart';
import '../core/app_typography.dart';
import '../repositories/blog_repository.dart';
import '../models/blog_post.dart';
import 'about_screen.dart';
import 'setting_screen.dart';
import '../routes/app_router.dart';
import 'article_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = BlogRepository.instance.getHomeData(page: 1);
  }

  Future<void> _refresh() async {
    final f = BlogRepository.instance.getHomeData(page: 1);
    setState(() {
      _dataFuture = f;
    });
    await f;
  }

  void _goToPage(int page) {
    if (page < 1) return;
    final f = BlogRepository.instance.getHomeData(page: page);
    setState(() {
      _dataFuture = f;
    });
  }

  Widget _buildPagination(
    BuildContext context, {
    required int page,
    required int totalCount,
    required bool hasNext,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    const pageSize = 10;
    final totalPages = (totalCount / pageSize).ceil().clamp(1, 999);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: page > 1 ? () => _goToPage(page - 1) : null,
            icon: const Icon(Icons.chevron_left_rounded, size: 20),
            label: const Text('上一页'),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '第 $page / $totalPages 页',
            style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: hasNext ? () => _goToPage(page + 1) : null,
            icon: const Icon(Icons.chevron_right_rounded, size: 20),
            label: const Text('下一页'),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          }
          if (snapshot.hasError) {
            return ErrorView(
              message: '加载失败: ${snapshot.error}',
              onRetry: () {
                setState(
                  () => _dataFuture = BlogRepository.instance.getHomeData(
                    page: 1,
                  ),
                );
              },
            );
          }
          final data = snapshot.data ?? {};
          final user = data['user'] as Map<String, dynamic>? ?? {};
          final posts = data['posts'] as List<BlogPost>? ?? [];
          final categories = data['categories'] as List<String>? ?? [];
          final page = data['page'] as int? ?? 1;
          final totalCount = data['totalCount'] as int? ?? 0;
          final hasNext = data['hasNext'] as bool? ?? false;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _buildHeader(context),
                SliverToBoxAdapter(child: _buildHero(context, user)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: _buildPostList(
                      context,
                      posts,
                      page: page,
                      hasNext: hasNext,
                      totalCount: totalCount,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildPagination(
                    context,
                    page: page,
                    totalCount: totalCount,
                    hasNext: hasNext,
                  ),
                ),
                SliverToBoxAdapter(child: _buildFooter(context, categories)),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return OwAppBar(
      title: appName,
      floating: true,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded),
        onPressed: () async {
          await context.push('/settings');
          if (mounted) {
            final newFuture = BlogRepository.instance.getHomeData();
            setState(() {
              _dataFuture = newFuture;
            });
          }
        },
        color: colorScheme.onSurface,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: _refresh,
          color: colorScheme.onSurface,
          tooltip: '刷新',
        ),
        IconButton(
          icon: const Icon(Icons.person_outline_rounded),
          onPressed: () => context.push('/about'),
          color: colorScheme.onSurface,
        ),
      ],
    );
  }

  Widget _buildHero(BuildContext context, Map<String, dynamic> user) {
    final colorScheme = Theme.of(context).colorScheme;
    final avatarUrl = user['avatarUrl'] as String? ?? '';
    final name = user['nickname'] as String? ?? appName;
    final subtitle = user['subtitle'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  child: const Icon(Icons.person, size: 48),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: AppTypography.displayMedium(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTypography.titleLargeItalic(
              fontSize: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.push('/search'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: colorScheme.outline,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '搜索文章...',
                    style: TextStyle(color: colorScheme.outline, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostList(
    BuildContext context,
    List<BlogPost> posts, {
    int page = 1,
    bool hasNext = false,
    int totalCount = 0,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '最新文章',
              style: AppTypography.displayMedium(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 1,
          color: AppColors.primary.withValues(alpha: 0.1),
        ),
        ...posts.map(
          (post) => _PostCard(
            post: post,
            onTap: () => context.push(
              '/article/${post.id}',
              extra: ArticleDetailArgs(
                post: post,
                allPosts: posts,
                page: page,
                hasNext: hasNext,
                totalCount: totalCount,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, List<String> categories) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: AppColors.primary.withValues(alpha: 0.1)),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '分类',
                      style: AppTypography.displayMedium(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...categories.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          c,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '社交媒体',
                      style: AppTypography.displayMedium(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _SocialButton(icon: Icons.share_rounded),
                        const SizedBox(width: 12),
                        _SocialButton(icon: Icons.mail_outline_rounded),
                        const SizedBox(width: 12),
                        _SocialButton(icon: Icons.rss_feed_rounded),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '订阅',
                      style: AppTypography.displayMedium(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '获取最新的博文更新和技术见解。',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 1,
            color: AppColors.primary.withValues(alpha: 0.05),
          ),
          const SizedBox(height: 24),
          Text(
            '© 2024 $appName. 保留所有权利.',
            style: TextStyle(fontSize: 12, color: colorScheme.outline),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primary, size: 20),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.onTap});

  final BlogPost post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post.imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 120,
                  height: 120,
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.image, color: colorScheme.outline),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          post.category,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: TextStyle(
                          color: colorScheme.outline,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        post.date,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    post.title,
                    style: AppTypography.displayMedium(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.excerpt,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
