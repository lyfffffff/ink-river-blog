/// 顶部提示工具 - Ink River 设计风格
///
/// 遵循 stitch_toast 设计：圆角卡片、轻量阴影、无硬边框、顶部展示
library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/color.dart';
import '../core/app_typography.dart';

/// 在顶部展示提示（错误、警告、普通消息）
/// 采用 Ink River 设计：rounded-xl、shadow-sm、surface 层级
/// [duration] 显示时长，默认 3 秒
/// [isError] 为 true 时使用错误样式（红色调）
void showTopMessage(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 3),
  bool isError = false,
}) {
  final overlay = Overlay.of(context);
  final mq = MediaQuery.of(context);
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (ctx) => _InkRiverToast(
      message: message,
      isError: isError,
      isDark: isDark,
      topPadding: mq.padding.top + 12,
    ),
  );

  overlay.insert(entry);

  Future.delayed(duration, () {
    if (entry.mounted) {
      entry.remove();
    }
  });
}

/// 顶部展示错误提示（红色样式）
void showTopError(BuildContext context, String message) {
  showTopMessage(context, message, isError: true);
}

/// Ink River 风格提示框
class _InkRiverToast extends StatefulWidget {
  const _InkRiverToast({
    required this.message,
    required this.isError,
    required this.isDark,
    required this.topPadding,
  });

  final String message;
  final bool isError;
  final bool isDark;
  final double topPadding;

  @override
  State<_InkRiverToast> createState() => _InkRiverToastState();
}

class _InkRiverToastState extends State<_InkRiverToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isError = widget.isError;
    final isDark = widget.isDark;

    // Ink River: surface 层级、无硬边框、shadow-sm
    final backgroundColor = isError
        ? (isDark
            ? Colors.red.shade900.withValues(alpha: 0.3)
            : Colors.red.shade50)
        : (isDark ? colorScheme.surface : colorScheme.surfaceContainerLowest);

    final textColor = isError
        ? (isDark ? Colors.red.shade300 : Colors.red.shade700)
        : colorScheme.onSurface;

    final iconColor = isError
        ? (isDark ? Colors.red.shade400 : Colors.red.shade600)
        : AppColors.primary;

    return Positioned(
      top: widget.topPadding,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  isError ? Icons.error_outline_rounded : Icons.info_outline_rounded,
                  size: 22,
                  color: iconColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.message,
                    style: AppTypography.displayMedium(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
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
}
