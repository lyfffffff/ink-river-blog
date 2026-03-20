/// 文章卡片 - 可复用组件
///
/// 用于分类页、搜索页、文章管理页等
/// 通过 [onManage] 控制是否显示管理按钮
library;

import 'package:flutter/material.dart';

import '../core/app_typography.dart';
import '../models/blog_post.dart';

/// 文章卡片
///
/// [onManage] 非空时显示「管理」按钮，适用于文章管理页
class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.post,
    required this.onTap,
    this.onManage,
    this.metadataFormat = ArticleCardMetadataFormat.categoryDate,
  });

  final BlogPost post;
  final VoidCallback onTap;
  final VoidCallback? onManage;
  final ArticleCardMetadataFormat metadataFormat;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: AppTypography.displayMedium(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (onManage == null) ...[
                        const SizedBox(height: 8),
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
                      const SizedBox(height: 8),
                      Text(
                        _buildMetadata(colorScheme),
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.outline,
                        ),
                      ),
                      if (onManage != null) ...[
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: onManage,
                          icon: const Icon(Icons.more_vert_rounded, size: 20),
                          label: const Text('管理'),
                          style: TextButton.styleFrom(
                            backgroundColor: colorScheme.surfaceContainerHighest,
                            foregroundColor: colorScheme.onSurface,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.imageUrl,
                    width: 100,
                    height: 75,
                    fit: BoxFit.cover,
                    errorBuilder: (_, e, st) => Container(
                      width: 100,
                      height: 75,
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.image_not_supported,
                        color: colorScheme.outline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _buildMetadata(ColorScheme colorScheme) {
    switch (metadataFormat) {
      case ArticleCardMetadataFormat.categoryDate:
        return '${post.category} · ${post.date}';
      case ArticleCardMetadataFormat.dateReadMinutes:
        return '${post.date} · ${post.readMinutes} 分钟阅读';
      case ArticleCardMetadataFormat.full:
        return '发布于 ${post.date} · ${post.readMinutes} 分钟阅读';
    }
  }
}

/// 元数据展示格式
enum ArticleCardMetadataFormat {
  /// 分类 · 日期（搜索页）
  categoryDate,

  /// 日期 · 阅读时长（分类页）
  dateReadMinutes,

  /// 发布于 日期 · 阅读时长（管理页）
  full,
}
