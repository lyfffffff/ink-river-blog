/// 我的收藏
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/app-bar.dart';
import '../components/empty_view.dart';
import '../components/article_card.dart';
import '../core/app_typography.dart';
import '../services/favorite_service.dart';
import '../repositories/blog_repository.dart';
import '../models/blog_post.dart';
import '../routes/app_router.dart';
import '../utils/toast_util.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<BlogPost>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = BlogRepository.instance.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListenableBuilder(
        listenable: FavoriteService.instance,
        builder: (context, _) => CustomScrollView(
          slivers: [
            OwAppBar(
              title: '我的收藏',
              showBackButton: true,
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: FutureBuilder<List<BlogPost>>(
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final posts = snapshot.data ?? [];
                  final favorites = posts
                      .where((p) => FavoriteService.instance.isFavorite(p.id))
                      .toList();
                  if (favorites.isEmpty) {
                    return const EmptyView(
                      message: '暂无收藏',
                      icon: Icons.bookmark_border_rounded,
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '已收藏 (${favorites.length})',
                          style: AppTypography.displayMedium(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...favorites.map(
                          (post) => Column(
                            children: [
                              ArticleCard(
                                post: post,
                                onTap: () => context.push(
                                  '/article/${post.id}',
                                  extra: ArticleDetailArgs(
                                    post: post,
                                    allPosts: favorites,
                                    page: 1,
                                    hasNext: false,
                                    totalCount: favorites.length,
                                  ),
                                ),
                                metadataFormat: ArticleCardMetadataFormat.full,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () async {
                                    await FavoriteService.instance.remove(post.id);
                                    if (mounted) {
                                      showTopMessage(context, '已取消收藏');
                                    }
                                  },
                                  child: const Text('取消收藏'),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
