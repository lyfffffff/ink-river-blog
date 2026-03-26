/// 关注服务
///
/// 使用 SharedPreferences 持久化关注作者 ID
library;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';

const String _kFollowIdsKey = 'follow_author_ids';

class FollowService extends ChangeNotifier {
  FollowService._();

  static final FollowService instance = FollowService._();

  Set<String> _ids = {};
  String? _userId;
  bool _listeningAuth = false;

  Set<String> get ids => Set.unmodifiable(_ids);

  bool isFollowing(String authorId) => _ids.contains(_normalize(authorId));

  Future<void> init() async {
    if (!_listeningAuth) {
      AuthService.instance.addListener(_onAuthChanged);
      _listeningAuth = true;
    }
    _userId = _normalizeUserId(AuthService.instance.user?['id']);
    await _loadForUser(_userId);
  }

  Future<bool> toggle(String authorId) async {
    if (_userId == null) return false;
    final normalized = _normalize(authorId);
    if (_ids.contains(normalized)) {
      _ids.remove(normalized);
    } else {
      _ids.add(normalized);
    }
    notifyListeners();
    return _save();
  }

  Future<bool> add(String authorId) async {
    if (_userId == null) return false;
    final normalized = _normalize(authorId);
    if (_ids.contains(normalized)) return true;
    _ids.add(normalized);
    notifyListeners();
    return _save();
  }

  Future<bool> remove(String authorId) async {
    if (_userId == null) return false;
    final normalized = _normalize(authorId);
    if (!_ids.contains(normalized)) return true;
    _ids.remove(normalized);
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
      _userId == null ? null : '${_kFollowIdsKey}_$_userId';

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
        _ids = list
                ?.map((e) => _normalize(e.toString()))
                .toSet() ??
            {};
      } else {
        _ids = {};
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('FollowService: 加载失败 ($e)');
      }
      _ids = {};
    }
    notifyListeners();
  }

  String _normalize(String authorId) {
    final trimmed = authorId.trim();
    if (trimmed.startsWith('u_')) {
      final rest = trimmed.substring(2);
      if (rest.isNotEmpty && int.tryParse(rest) != null) {
        return rest;
      }
    }
    return trimmed;
  }

  Future<bool> _save() async {
    if (_storageKey == null) return false;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey!, jsonEncode(_ids.toList()));
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('FollowService: 保存失败 ($e)');
      }
      return false;
    }
  }
}
