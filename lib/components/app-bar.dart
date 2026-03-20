import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/app_typography.dart';

class OwAppBar extends StatelessWidget {
  const OwAppBar({
    super.key,
    required this.title,
    this.backgroundColor,
    this.leading,
    this.showBackButton = false,
    this.centerTitle = true,
    this.actions,
    this.titleFontSize = 18,
    this.floating = false,
  });

  final String title;
  final Color? backgroundColor;
  final Widget? leading;
  final bool showBackButton;
  final bool centerTitle;
  final List<Widget>? actions;
  final double titleFontSize;
  final bool floating;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: floating,
      title: Text(
        title,
        style: AppTypography.displayMedium(
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      centerTitle: centerTitle,
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => context.pop(),
                  color: Theme.of(context).colorScheme.onSurface,
                )
              : null),
      actions: actions ?? [],
      backgroundColor: backgroundColor ??
          Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
      surfaceTintColor: Colors.transparent,
    );
  }
}
