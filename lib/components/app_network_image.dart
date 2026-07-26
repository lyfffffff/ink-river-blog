/// 统一的网络图片加载组件
///
/// 提供：加载占位、淡入动画、错误兜底，避免直接使用 Image.network
/// 带来的"白屏闪现"与无错误兜底问题。所有网络图片应统一使用本组件。
library;

import 'package:flutter/material.dart';

class AppNetworkImage extends StatefulWidget {
  const AppNetworkImage({
    super.key,
    required this.src,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String src;
  final double? width;
  final double? height;
  final BoxFit fit;

  /// 可选圆角，内部用 ClipRRect 裁剪
  final double? borderRadius;

  @override
  State<AppNetworkImage> createState() => _AppNetworkImageState();
}

class _AppNetworkImageState extends State<AppNetworkImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade;

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = Container(
      width: widget.width,
      height: widget.height,
      color: scheme.surfaceContainerHighest,
    );
    final errorView = Container(
      width: widget.width,
      height: widget.height,
      color: scheme.surfaceContainerHighest,
      child: Icon(
        Icons.broken_image_outlined,
        color: scheme.outline,
        size: ((widget.width ?? 40) * 0.4).clamp(16.0, 48.0),
      ),
    );

    Widget image = Image.network(
      widget.src,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          _fade.forward();
          return FadeTransition(opacity: _fade, child: child);
        }
        return placeholder;
      },
      errorBuilder: (context, error, stackTrace) => errorView,
    );

    if (widget.borderRadius != null) {
      image = ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius!),
        child: image,
      );
    }
    return image;
  }
}
