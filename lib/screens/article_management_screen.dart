/// 文章管理页 - 我的文章列表 + 操作弹窗
///
/// 1:1 复刻 stitch 设计
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../components/article_action_sheet.dart';
import '../components/article_card.dart';
import '../components/delete_article_dialog.dart';
import '../repositories/blog_repository.dart';
import '../models/blog_post.dart';
import '../utils/toast_util.dart';
import '../services/blog_service.dart';
import '../routes/app_router.dart';
import 'article_detail_screen.dart';
import 'article_edit_screen.dart';

class ArticleManagementScreen extends StatefulWidget {
  const ArticleManagementScreen({super.key});

  @override
  State<ArticleManagementScreen> createState() => _ArticleManagementScreenState();
}

class _ArticleManagementScreenState extends State<ArticleManagementScreen> {
  late Future<List<BlogPost>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    setState(() {
      _postsFuture = BlogRepository.instance.getPosts();
    });
  }

  Future<void> _handleAction(BlogPost post, ArticleAction action) async {
    switch (action) {
      case ArticleAction.edit:
        final ok = await context.push<bool>('/article/${post.id}/edit');
        if (ok == true) _loadPosts();
        break;
      case ArticleAction.pin:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('置顶功能开发中')),
        );
        break;
      case ArticleAction.stats:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('数据统计功能开发中')),
        );
        break;
      case ArticleAction.delete:
        final confirmed = await showDeleteArticleDialog(context);
        if (confirmed && mounted) {
          final ok = await BlogService.removeArticle(post.id);
          if (!mounted) return;
          if (ok) {
            _loadPosts();
            showTopMessage(context, '已删除');
          } else {
            showTopError(context, '删除失败');
          }
        }
        break;
      case ArticleAction.cancel:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: FutureBuilder<List<BlogPost>>(
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '加载失败',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _loadPosts,
                            child: const Text('重试'),
                          ),
                        ],
                      ),
                    );
                  }
                  final posts = snapshot.data ?? [];
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        '我的文章',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...posts.map((post) => ArticleCard(
                            post: post,
                            onManage: () => _showActionSheet(post),
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
                                ArticleCardMetadataFormat.full,
                          )),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showActionSheet(BlogPost post) async {
    final action = await showArticleActionSheet(context, post: post);
    if (action != null && action != ArticleAction.cancel && mounted) {
      _handleAction(post, action);
    }
  }

  Widget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, size: 28),
            onPressed: () => context.pop(),
            color: colorScheme.onSurface,
          ),
          Expanded(
            child: Text(
              appName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 28),
            onPressed: () {},
            color: colorScheme.onSurface,
          ),
        ],
      ),
    );
  }
}
