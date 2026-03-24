/// 关注服务
///
/// 使用 SharedPreferences 持久化关注作者 ID
library;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kFollowIdsKey = 'follow_author_ids';

class FollowService extends ChangeNotifier {
  FollowService._();

  static final FollowService instance = FollowService._();

  Set<String> _ids = {};

  Set<String> get ids => Set.unmodifiable(_ids);

  bool isFollowing(String authorId) => _ids.contains(_normalize(authorId));

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_kFollowIdsKey);
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
  }

  Future<bool> toggle(String authorId) async {
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
    final normalized = _normalize(authorId);
    if (_ids.contains(normalized)) return true;
    _ids.add(normalized);
    notifyListeners();
    return _save();
  }

  Future<bool> remove(String authorId) async {
    final normalized = _normalize(authorId);
    if (!_ids.contains(normalized)) return true;
    _ids.remove(normalized);
    notifyListeners();
    return _save();
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
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kFollowIdsKey, jsonEncode(_ids.toList()));
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('FollowService: 保存失败 ($e)');
      }
      return false;
    }
  }
}
