/// 登录态管理
///
/// 使用 SharedPreferences 持久化，应用重启后保持登录状态
library;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kAuthKey = 'auth_user';

/// 认证服务
class AuthService extends ChangeNotifier {
  AuthService._();

  static final AuthService instance = AuthService._();

  Map<String, dynamic>? _user;

  /// 当前登录用户，未登录为 null
  Map<String, dynamic>? get user => _user;

  /// 是否已登录
  bool get isLoggedIn => _user != null;

  /// 初始化，从本地加载
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_kAuthKey);
      if (json != null && json.isNotEmpty) {
        _user = _parseUser(json);
      } else {
        _user = null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AuthService: 加载失败 ($e)');
      }
      _user = null;
    }
  }

  Map<String, dynamic>? _parseUser(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}
    return null;
  }

  /// 保存登录态
  /// [persist] 为 true 时写入本地，应用重启后仍保持登录
  Future<void> saveLogin(Map<String, dynamic> user, {bool persist = true}) async {
    _user = user;
    if (persist) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_kAuthKey, jsonEncode(user));
      } catch (_) {}
    }
    notifyListeners();
  }

  /// 清除登录态
  Future<void> clearLogin() async {
    _user = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kAuthKey);
    } catch (_) {}
    notifyListeners();
  }
}
