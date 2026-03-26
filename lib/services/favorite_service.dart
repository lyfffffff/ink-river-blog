/// 收藏服务
///
/// 使用 SharedPreferences 持久化收藏的文章 ID
library;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';

const String _kFavoriteIdsKey = 'favorite_post_ids';

/// 收藏服务
class FavoriteService extends ChangeNotifier {
  FavoriteService._();

  static final FavoriteService instance = FavoriteService._();

  Set<String> _ids = {};
  String? _userId;
  bool _listeningAuth = false;

  /// 已收藏的文章 ID 集合
  Set<String> get ids => Set.unmodifiable(_ids);

  /// 是否已收藏某文章
  bool isFavorite(String postId) => _ids.contains(postId);

  /// 初始化，从本地加载
  Future<void> init() async {
    if (!_listeningAuth) {
      AuthService.instance.addListener(_onAuthChanged);
      _listeningAuth = true;
    }
    _userId = _normalizeUserId(AuthService.instance.user?['id']);
    await _loadForUser(_userId);
  }

  /// 切换收藏状态
  Future<bool> toggle(String postId) async {
    if (_userId == null) return false;
    if (_ids.contains(postId)) {
      _ids.remove(postId);
    } else {
      _ids.add(postId);
    }
    notifyListeners();
    return _save();
  }

  /// 添加收藏
  Future<bool> add(String postId) async {
    if (_userId == null) return false;
    if (_ids.contains(postId)) return true;
    _ids.add(postId);
    notifyListeners();
    return _save();
  }

  /// 取消收藏
  Future<bool> remove(String postId) async {
    if (_userId == null) return false;
    if (!_ids.contains(postId)) return true;
    _ids.remove(postId);
    notifyListeners();
    return _save();
  }

  void _onAuthChanged() {
    final nextUserId = _normalizeUserId(AuthService.instance.user?['id']);
    if (nextUserId == _userId) return;
    _userId = nextUserId;
    _loadForUser(_userId);
  }

  String? _normalizeUserId(Object? raw) {
    final id = raw?.toString().trim();
    if (id == null || id.isEmpty) return null;
    return id;
  }

  String? get _storageKey =>
      _userId == null ? null : '${_kFavoriteIdsKey}_$_userId';

  Future<void> _loadForUser(String? userId) async {
    if (userId == null) {
      _ids = {};
      notifyListeners();
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_storageKey!);
      if (json != null && json.isNotEmpty) {
        final list = jsonDecode(json) as List<dynamic>?;
        _ids = list?.map((e) => e.toString()).toSet() ?? {};
      } else {
        _ids = {};
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('FavoriteService: 加载失败 ($e)');
      }
      _ids = {};
    }
    notifyListeners();
  }

  Future<bool> _save() async {
    if (_storageKey == null) return false;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey!, jsonEncode(_ids.toList()));
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('FavoriteService: 保存失败 ($e)');
      }
      return false;
    }
  }
}
