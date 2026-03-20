/// 应用主题管理
///
/// 支持深浅主题切换，持久化到 SharedPreferences（Web 降级为内存存储）
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kDarkModeKey = 'dark_mode';

/// 主题控制器
class AppTheme extends ChangeNotifier {
  AppTheme._();

  static final AppTheme instance = AppTheme._();

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  bool _useMemoryFallback = false;

  /// 初始化，从本地加载
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_kDarkModeKey) ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    } catch (e) {
      _useMemoryFallback = true;
      if (kDebugMode) {
        debugPrint('AppTheme: SharedPreferences 不可用，使用内存存储 ($e)');
      }
    }
  }

  /// 设置主题
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kDarkModeKey, mode == ThemeMode.dark);
    } catch (_) {
      _useMemoryFallback = true;
    }
    notifyListeners();
  }

  /// 切换深浅模式
  Future<void> toggle() async {
    await setThemeMode(
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }

  /// 设置深色模式开关
  Future<void> setDarkMode(bool enabled) async {
    await setThemeMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }
}
