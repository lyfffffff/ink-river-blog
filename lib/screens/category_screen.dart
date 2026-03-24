/// 分类页 - 按分类展示文章列表
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/app-bar.dart';
import '../components/settings_button.dart';
import '../components/article_card.dart';
import '../components/empty_view.dart';
import '../components/error_view.dart';
import '../components/loading_view.dart';
import '../constants/app_constants.dart';
import '../constants/color.dart';
import '../core/app_typography.dart';
import '../controllers/category_controller.dart';
import '../models/blog_post.dart';
import '../routes/app_router.dart';
import 'article_detail_screen.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  void _selectCategory(String category) {
    ref.read(categoryControllerProvider.notifier).selectCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    final categoryAsync = ref.watch(categoryControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: categoryAsync.when(
        loading: () => const LoadingView(),
        error: (_, __) => ErrorView(
          message: '加载失败',
          onRetry: () => ref.read(categoryControllerProvider.notifier).load(),
        ),
        data: (state) => _buildContent(context, state),
      ),
    );
  }

  Widget _buildContent(BuildContext context, CategoryState state) {
    final categories = state.categories;
    final selectedCategory = state.selected;
    final posts = state.posts;

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
                    final isSelected = selectedCategory == c;
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
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
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
                if (posts.isEmpty)
                  const EmptyView(
                    message: '该分类暂无文章',
                    icon: Icons.folder_off_rounded,
                  )
                else
                  _buildPosts(context, selectedCategory, posts),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPosts(
    BuildContext context,
    String selectedCategory,
    List<BlogPost> posts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$selectedCategory (${posts.length})',
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
            metadataFormat: ArticleCardMetadataFormat.dateReadMinutes,
          ),
        ),
      ],
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
