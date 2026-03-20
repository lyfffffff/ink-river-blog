/// 设置项 - 左侧文案 + 右侧（值/箭头/开关）
library;

import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
    required this.title,
    this.trailing,
    this.value,
    this.onTap,
    this.showDivider = true,
  });

  final String title;
  final Widget? trailing;
  final String? value;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Widget right = trailing ??
        (value != null
            ? Text(
                value!,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            : Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.outline,
                size: 24,
              ));

    final child = InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            right,
          ],
        ),
      ),
    );

    if (showDivider) {
      return Column(
        children: [
          child,
          Divider(height: 1, color: Theme.of(context).dividerColor),
        ],
      );
    }
    return child;
  }
}
