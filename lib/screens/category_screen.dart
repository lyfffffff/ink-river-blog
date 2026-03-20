/// 分类页 - 按分类展示文章列表
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/app-bar.dart';
import '../components/settings_button.dart';
import '../components/article_card.dart';
import '../components/empty_view.dart';
import '../components/error_view.dart';
import '../components/loading_view.dart';
import '../constants/app_constants.dart';
import '../constants/color.dart';
import '../core/app_typography.dart';
import '../repositories/blog_repository.dart';
import '../models/blog_post.dart';
import '../routes/app_router.dart';
import 'article_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<String>> _categoriesFuture;
  String? _selectedCategory;
  Future<List<BlogPost>>? _postsFuture;
  bool _hasInitializedCategory = false;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = BlogRepository.instance.getCategoriesWithPosts();
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _postsFuture = BlogRepository.instance.getPostsByCategory(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder<List<String>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          }
          if (snapshot.hasError) {
            return ErrorView(
              message: '加载失败',
              onRetry: () =>
                  setState(() => _categoriesFuture = BlogRepository.instance.getCategoriesWithPosts()),
            );
          }
          final categories = snapshot.data ?? [];
          if (categories.isNotEmpty &&
              _selectedCategory == null &&
              !_hasInitializedCategory) {
            _hasInitializedCategory = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _selectCategory(categories.first);
            });
          }
          return CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '文章分类',
                        style: AppTypography.displayMedium(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: categories.map((c) {
                          final isSelected = _selectedCategory == c;
                          return GestureDetector(
                            onTap: () => _selectCategory(c),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Theme.of(context).dividerColor,
                                ),
                              ),
                              child: Text(
                                c,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      if (_selectedCategory != null && _postsFuture != null)
                        FutureBuilder<List<BlogPost>>(
                          future: _postsFuture!,
                          builder: (context, postSnapshot) {
                            if (postSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(32),
                                child: LoadingView(),
                              );
                            }
                            final posts = postSnapshot.data ?? [];
                            if (posts.isEmpty) {
                              return const EmptyView(
                                message: '该分类暂无文章',
                                icon: Icons.folder_off_rounded,
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$_selectedCategory (${posts.length})',
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
                                        ArticleCardMetadataFormat.dateReadMinutes,
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
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return OwAppBar(
      title: '$appName - 分类',
      floating: false,
      leading: const SettingsButton(),
    );
  }
}
