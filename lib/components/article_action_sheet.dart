/// 文章操作弹窗 - 底部弹出
///
/// 1:1 复刻 stitch 设计
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/color.dart';
import '../models/blog_post.dart';

/// 操作类型
enum ArticleAction {
  edit,
  pin,
  stats,
  delete,
  cancel,
}

/// 显示文章操作弹窗
Future<ArticleAction?> showArticleActionSheet(
  BuildContext context, {
  required BlogPost post,
}) {
  return showModalBottomSheet<ArticleAction>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => _ArticleActionSheetContent(post: post),
  );
}

class _ArticleActionSheetContent extends StatelessWidget {
  const _ArticleActionSheetContent({required this.post});

  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final maxHeight = MediaQuery.of(context).size.height * 0.85;
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Text(
                    '文章管理',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
              _ActionItem(
                icon: Icons.edit_rounded,
                label: '编辑文章',
                onTap: () => context.pop(ArticleAction.edit),
              ),
              _ActionItem(
                icon: Icons.vertical_align_top_rounded,
                label: '置顶文章',
                onTap: () => context.pop(ArticleAction.pin),
              ),
              _ActionItem(
                icon: Icons.bar_chart_rounded,
                label: '查看数据',
                onTap: () => context.pop(ArticleAction.stats),
              ),
              _ActionItem(
                icon: Icons.delete_outline_rounded,
                label: '删除文章',
                isDestructive: true,
                onTap: () => context.pop(ArticleAction.delete),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.pop(ArticleAction.cancel),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      foregroundColor: colorScheme.onSurface,
                      side: BorderSide(color: colorScheme.outlineVariant),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('取消', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isDestructive ? Colors.red : AppColors.primary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDestructive ? Colors.red : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
