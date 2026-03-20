/// 应用颜色常量
///
/// 复用率高的颜色集中管理，便于主题统一与维护
library;

import 'package:flutter/material.dart';

/// 应用颜色
///
/// 提取自 stitch 设计：浅色 background-light #F6F8F8，深色 background-dark #101F22
class AppColors {
  AppColors._();

  /// 主色 - 青蓝 #11B4D4（深浅模式通用）
  static const Color primary = Color(0xFF11B4D4);

  /// 浅色模式背景 #F6F8F8
  static const Color background = Color(0xFFF6F8F8);

  /// 深色模式背景 #101F22（stitch background-dark）
  static const Color surfaceDark = Color(0xFF101F22);

  /// 深色模式卡片/表面色（slate-900 #1E293B）
  static const Color surfaceDarkCard = Color(0xFF1E293B);
}
