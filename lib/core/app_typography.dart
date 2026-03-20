/// 应用字体样式
///
/// 使用思源黑体（Source Han Sans CN），免费可商用，无需网络加载
library;

import 'package:flutter/material.dart';

/// 思源黑体字体族名
const String kFontFamily = 'SourceHanSansCN';

abstract class AppTypography {
  static TextStyle displayLarge({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) =>
      TextStyle(
        fontSize: fontSize ?? 28,
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color,
        fontFamily: kFontFamily,
      );

  static TextStyle displayMedium({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    FontStyle? fontStyle,
  }) =>
      TextStyle(
        fontSize: fontSize ?? 24,
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color,
        fontFamily: kFontFamily,
        fontStyle: fontStyle ?? FontStyle.normal,
      );

  static TextStyle titleLarge({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    FontStyle? fontStyle,
  }) =>
      TextStyle(
        fontSize: fontSize ?? 20,
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color,
        fontFamily: kFontFamily,
        fontStyle: fontStyle ?? FontStyle.normal,
      );

  static TextStyle titleLargeItalic({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) =>
      TextStyle(
        fontSize: fontSize ?? 18,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color,
        fontFamily: kFontFamily,
        fontStyle: FontStyle.italic,
      );

  static TextStyle titleMedium({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) =>
      TextStyle(
        fontSize: fontSize ?? 18,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color,
        fontFamily: kFontFamily,
      );
}
