/// 跳转设置页的按钮
///
/// 用于 AppBar 左上角，点击跳转至 /settings
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 设置页入口按钮
class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      icon: const Icon(Icons.menu_rounded),
      onPressed: () => context.push('/settings'),
      color: colorScheme.onSurface,
      tooltip: '设置',
    );
  }
}
