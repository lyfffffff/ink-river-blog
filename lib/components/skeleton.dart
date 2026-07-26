/// 骨架屏组件
///
/// 在首次加载数据时展示，提供与真实内容近似的占位布局，
/// 改善"白屏 -> 内容"的突兀感，提升产品化观感。
library;

import 'package:flutter/material.dart';

/// 单个骨架块，带呼吸闪烁动画
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 6,
  });

  final double? width;
  final double? height;
  final double borderRadius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: base.withValues(alpha: 0.3 + _controller.value * 0.4),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}

/// 文章卡片骨架（与首页 _PostCard 布局对应）
class PostCardSkeleton extends StatelessWidget {
  const PostCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 120, height: 120, borderRadius: 12),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SkeletonBox(width: 50, height: 14),
                    SizedBox(width: 8),
                    SkeletonBox(width: 60, height: 12),
                  ],
                ),
                SizedBox(height: 10),
                SkeletonBox(width: double.infinity, height: 18),
                SizedBox(height: 6),
                SkeletonBox(width: 200, height: 18),
                SizedBox(height: 10),
                SkeletonBox(width: double.infinity, height: 14),
                SizedBox(height: 6),
                SkeletonBox(width: 160, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 首页骨架列表
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonBox(width: 120, height: 22),
            const SizedBox(height: 16),
            for (int i = 0; i < itemCount; i++) const PostCardSkeleton(),
          ],
        ),
      ),
    );
  }
}
