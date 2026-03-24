/// 认证表单布局 - 居中卡片、品牌头部
library;

import 'package:flutter/material.dart';

import '../constants/color.dart';
import '../core/app_typography.dart';

class AuthFormLayout extends StatelessWidget {
  const AuthFormLayout({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.brush_rounded,
    this.trailing,
    required this.child,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 48, color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: AppTypography.displayLarge(
                        fontSize: 28,
                        color: Colors.grey[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 32),
                    child,
                  ],
                ),
              ),
              if (trailing != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: trailing!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
