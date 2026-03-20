/// 文章详情页
///
/// 数据通过 mock API 请求获取
/// 支持纯文本与 Delta 富文本内容展示
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:flutter_application_1/components/app-bar.dart';

import '../constants/app_constants.dart';
import '../routes/app_router.dart';
import '../utils/toast_util.dart';
import '../constants/color.dart';
import '../services/favorite_service.dart';
import '../core/app_typography.dart';
import '../repositories/blog_repository.dart';
import '../models/blog_post.dart';
import '../models/comment.dart';

/// 判断内容是否为 Delta JSON 格式
bool _isDeltaContent(String content) => content.trim().startsWith('[');

/// 从 Delta JSON 或纯文本创建 Document
/// flutter_quill 要求 Document 最后一个节点必须以 \n 结尾
Document _documentFromContent(String content) {
  if (!_isDeltaContent(content)) {
    final plain = content.isEmpty ? '\n' : (content.endsWith('\n') ? content : content + '\n');
    return Document.fromJson([{'insert': plain}]);
  }
  try {
    final list = jsonDecode(content) as List;
    final normalized = _normalizeDeltaForQuill(list);
    return Document.fromJson(normalized);
  } catch (_) {
    final plain = content.endsWith('\n') ? content : content + '\n';
    return Document.fromJson([{'insert': plain}]);
  }
}

/// 确保 Delta 最后一个 insert 以 \n 结尾（满足 flutter_quill 要求）
List<Map<String, dynamic>> _normalizeDeltaForQuill(List<dynamic> ops) {
  if (ops.isEmpty) return [{'insert': '\n'}];
  final list = ops.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  final last = list.last;
  final insert = last['insert'];
  if (insert is String) {
    if (!insert.endsWith('\n')) {
      list[list.length - 1] = {...last, 'insert': insert + '\n'};
    }
  } else {
    list.add({'insert': '\n'});
  }
  return list;
}

class ArticleDetailScreen extends StatefulWidget {
  const ArticleDetailScreen({
    super.key,
    required this.post,
    this.allPosts,
    this.page,
    this.hasNext,
    this.totalCount,
  });

  final BlogPost post;
  /// 可选，用于上一篇/下一篇导航。若不传则自动拉取
  final List<BlogPost>? allPosts;
  /// 当前页码（从首页进入时传入，用于跨页上一篇/下一篇）
  final int? page;
  /// 是否有下一页
  final bool? hasNext;
  /// 总文章数（用于计算是否有上一页）
  final int? totalCount;

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  late Future<Map<String, dynamic>> _dataFuture;
  List<BlogPost>? _postsForNav;
  int? _page;
  bool? _hasNext;
  int? _totalCount;
  bool _loadingPrevNext = false;
  static const int _commentsPerPage = 10;
  int _commentsDisplayCount = _commentsPerPage;
  final List<Comment> _localComments = [];

  @override
  void initState() {
    super.initState();
    if (widget.allPosts != null) {
      _postsForNav = widget.allPosts;
      _page = widget.page;
      _hasNext = widget.hasNext;
      _totalCount = widget.totalCount;
    } else {
      BlogRepository.instance.getPosts().then((posts) {
        if (mounted) setState(() => _postsForNav = posts);
      });
    }
    _dataFuture = Future.wait([
      BlogRepository.instance.getProfile(),
      BlogRepository.instance.getComments(widget.post.id),
    ]).then((results) => <String, dynamic>{
          'profile': results[0],
          'comments': results[1],
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FavoriteService.instance,
      builder: (context, _) => Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('加载失败: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('返回'),
                  ),
                ],
              ),
            );
          }
          final data = snapshot.data ?? {};
          final profile = data['profile'] as Map<String, dynamic>? ?? {};
          final comments = data['comments'] as List<Comment>? ?? [];

          return CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(child: _buildHeroImage(context)),
              SliverToBoxAdapter(child: _buildAuthorInfo(context, profile)),
              SliverToBoxAdapter(child: _buildArticleContent(context)),
              SliverToBoxAdapter(child: _buildTags(context)),
              SliverToBoxAdapter(child: _buildPrevNext(context)),
              SliverToBoxAdapter(
                child: _buildComments(
                  context,
                  [...comments, ..._localComments],
                  profile,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          );
        },
      ),
    ),
    );
  }

  void _showShareModal(BuildContext context) {
    final link = '${Uri.base}#/article/${widget.post.id}';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(ctx).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '分享应用链接',
              style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                link,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      try {
                        await Share.share(
                          '${widget.post.title}\n$link',
                          subject: widget.post.title,
                        );
                      } catch (_) {
                        await Clipboard.setData(ClipboardData(text: link));
                      }
                      if (ctx.mounted) ctx.pop();
                      if (context.mounted) {
                        showTopMessage(context, '已分享');
                      }
                    },
                    icon: const Icon(Icons.share_rounded, size: 18),
                    label: const Text('分享'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: link));
                      if (ctx.mounted) ctx.pop();
                      if (context.mounted) {
                        showTopMessage(context, '链接已复制');
                      }
                    },
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: const Text('复制链接'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => ctx.pop(),
                    child: const Text('关闭'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return OwAppBar(
      title: '文章详情',
      showBackButton: true,
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share_rounded),
          onPressed: () => _showShareModal(context),
          color: Colors.grey[800],
        ),
        IconButton(
          icon: Icon(
            FavoriteService.instance.isFavorite(widget.post.id)
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
          ),
          onPressed: () async {
            await FavoriteService.instance.toggle(widget.post.id);
            if (mounted) {
              showTopMessage(
                context,
                FavoriteService.instance.isFavorite(widget.post.id)
                    ? '已收藏'
                    : '已取消收藏',
              );
            }
          },
          color: Colors.grey[800],
        ),
      ],
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    final post = widget.post;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                post.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image,
                    size: 48,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      post.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.title,
                    style: AppTypography.displayMedium(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorInfo(
    BuildContext context,
    Map<String, dynamic> profile,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final post = widget.post;
    final avatarUrl = profile['avatarUrl'] as String? ?? '';
    final name = profile['name'] as String? ?? appName;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            backgroundImage:
                avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
            child: avatarUrl.isEmpty
                ? const Icon(Icons.person, color: AppColors.primary)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.displayMedium(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  '发布于 ${post.date} · ${post.readMinutes}分钟阅读',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              '关注',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final post = widget.post;
    if (_isDeltaContent(post.content)) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _RichArticleContent(content: post.content),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: post.content
            .split('\n\n')
            .where((s) => s.trim().isNotEmpty)
            .map((paragraph) {
          if (paragraph.startsWith('"')) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: AppColors.primary, width: 4),
                  ),
                ),
                child: Text(
                  paragraph.replaceAll('"', ''),
                  style: AppTypography.displayMedium(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: AppColors.primary,
                  ),
                ),
              ),
            );
          }
          if (paragraph.length < 50 && !paragraph.contains('。')) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                paragraph,
                style: AppTypography.displayMedium(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              paragraph.replaceAll('•', '• '),
              style: TextStyle(
                fontSize: 16,
                height: 1.8,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTags(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final post = widget.post;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: post.tags
            .map(
              (tag) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  '# $tag',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> _goToPrevPage() async {
    if (_loadingPrevNext || _page == null || _page! <= 1) return;
    setState(() => _loadingPrevNext = true);
    try {
      final data = await BlogRepository.instance.getHomeData(page: _page! - 1);
      final list = BlogRepository.instance.parsePostsFromHomeData(data);
      if (list.isEmpty || !mounted) return;
      final prevPost = list.last;
      context.pushReplacement(
        '/article/${prevPost.id}',
        extra: ArticleDetailArgs(
          post: prevPost,
          allPosts: list,
          page: _page! - 1,
          hasNext: true,
          totalCount: _totalCount,
        ),
      );
    } finally {
      if (mounted) setState(() => _loadingPrevNext = false);
    }
  }

  Future<void> _goToNextPage() async {
    if (_loadingPrevNext || _hasNext != true || _page == null) return;
    setState(() => _loadingPrevNext = true);
    try {
      final data = await BlogRepository.instance.getHomeData(page: _page! + 1);
      final list = BlogRepository.instance.parsePostsFromHomeData(data);
      final nextHasNext = data['hasNext'] as bool? ?? false;
      if (list.isEmpty || !mounted) return;
      final nextPost = list.first;
      context.pushReplacement(
        '/article/${nextPost.id}',
        extra: ArticleDetailArgs(
          post: nextPost,
          allPosts: list,
          page: _page! + 1,
          hasNext: nextHasNext,
          totalCount: _totalCount,
        ),
      );
    } finally {
      if (mounted) setState(() => _loadingPrevNext = false);
    }
  }

  Widget _buildPrevNext(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final posts = _postsForNav ?? [];
    final idx = posts.indexWhere((p) => p.id == widget.post.id);
    final prevPost = idx > 0 ? posts[idx - 1] : null;
    final nextPost = idx >= 0 && idx < posts.length - 1 ? posts[idx + 1] : null;
    final canFetchPrev = idx == 0 && _page != null && _page! > 1;
    final canFetchNext =
        idx == posts.length - 1 && idx >= 0 && _hasNext == true;
    final hasPrev = prevPost != null || canFetchPrev;
    final hasNext = nextPost != null || canFetchNext;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: hasPrev
                ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _loadingPrevNext
                          ? null
                          : () {
                              if (prevPost != null) {
                                context.pushReplacement(
                                  '/article/${prevPost.id}',
                                  extra: ArticleDetailArgs(
                                    post: prevPost,
                                    allPosts: posts,
                                    page: _page,
                                    hasNext: _hasNext,
                                    totalCount: _totalCount,
                                  ),
                                );
                              } else {
                                _goToPrevPage();
                              }
                            },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            if (_loadingPrevNext && canFetchPrev)
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.primary,
                                ),
                              )
                            else
                              Icon(
                                Icons.chevron_left_rounded,
                                color: colorScheme.outline,
                                size: 20,
                              ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '上一篇',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.outline,
                                    ),
                                  ),
                                  Text(
                                    prevPost?.title ?? '加载上一页...',
                                    style: AppTypography.displayMedium(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '上一篇',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.outline,
                          ),
                        ),
                        Text(
                          '没有了',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: hasNext
                ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _loadingPrevNext
                          ? null
                          : () {
                              if (nextPost != null) {
                                context.pushReplacement(
                                  '/article/${nextPost.id}',
                                  extra: ArticleDetailArgs(
                                    post: nextPost,
                                    allPosts: posts,
                                    page: _page,
                                    hasNext: _hasNext,
                                    totalCount: _totalCount,
                                  ),
                                );
                              } else {
                                _goToNextPage();
                              }
                            },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '下一篇',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.outline,
                                    ),
                                  ),
                                  Text(
                                    nextPost?.title ?? '加载下一页...',
                                    style: AppTypography.displayMedium(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (_loadingPrevNext && canFetchNext)
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.primary,
                                ),
                              )
                            else
                              Icon(
                                Icons.chevron_right_rounded,
                                color: colorScheme.outline,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '下一篇',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.outline,
                          ),
                        ),
                        Text(
                          '没有了',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showCommentModal(
    BuildContext context,
    Map<String, dynamic> profile,
  ) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(ctx).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: '写下你的评论...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(ctx).colorScheme.surfaceContainerHighest,
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => ctx.pop(),
                      child: const Text('取消'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        final content = controller.text.trim();
                        ctx.pop();
                        if (content.isNotEmpty) {
                          final name = profile['name'] as String? ?? '我';
                          final newComment = Comment(
                            id: 'local_${DateTime.now().millisecondsSinceEpoch}',
                            authorName: name,
                            authorInitial: name.isEmpty ? '?' : name[0],
                            content: content,
                            timeAgo: '刚刚',
                            likeCount: 0,
                          );
                          BlogRepository.instance.addLocalComment(widget.post.id, newComment);
                          setState(() => _localComments.add(newComment));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('评论已发布')),
                          );
                        }
                      },
                      child: const Text('发布'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).then((_) => controller.dispose());
  }

  Widget _buildComments(
    BuildContext context,
    List<Comment> comments,
    Map<String, dynamic> profile,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayed = comments.take(_commentsDisplayCount).toList();
    final hasMore = comments.length > _commentsDisplayCount;

    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '评论 (${comments.length})',
                style: AppTypography.displayMedium(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showCommentModal(context, profile),
                icon: Icon(
                  Icons.edit_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
                label: Text(
                  '写评论',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...displayed.map((c) => _CommentItem(comment: c)),
          const SizedBox(height: 24),
          if (hasMore)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _commentsDisplayCount += _commentsPerPage;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '展开更多评论',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.outline,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            )
          else if (comments.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '已全部加载完毕',
                  style: TextStyle(
                    color: colorScheme.outline,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  const _CommentItem({required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: Text(
              comment.authorInitial,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comment.authorName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      comment.timeAgo,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up_outlined,
                      size: 14,
                      color: colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${comment.likeCount}',
                      style: TextStyle(fontSize: 12, color: colorScheme.outline),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '回复',
                      style: TextStyle(fontSize: 12, color: colorScheme.outline),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 富文本内容展示（Delta JSON 格式）
class _RichArticleContent extends StatefulWidget {
  const _RichArticleContent({required this.content});

  final String content;

  @override
  State<_RichArticleContent> createState() => _RichArticleContentState();
}

class _RichArticleContentState extends State<_RichArticleContent> {
  late final QuillController _controller;

  @override
  void initState() {
    super.initState();
    _controller = QuillController(
      document: _documentFromContent(widget.content),
      selection: const TextSelection.collapsed(offset: 0),
    );
    _controller.readOnly = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      controller: _controller,
      config: QuillEditorConfig(padding: EdgeInsets.zero),
    );
  }
}
