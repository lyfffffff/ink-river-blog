/// 搜索历史服务
///
/// 基于 SharedPreferences 持久化搜索关键词历史，
/// 按最近使用排序，最多保留 10 条，去重。
library;

import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  SearchHistoryService._();

  static const _key = 'search_history';
  static const _maxCount = 10;

  /// 读取历史列表（最近的在前）
  static Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? <String>[];
  }

  /// 新增一条搜索记录（去重并置顶，超出上限截断）
  static Future<void> add(String keyword) async {
    final k = keyword.trim();
    if (k.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final list = (prefs.getStringList(_key) ?? <String>[]).toList();
    list.remove(k);
    list.insert(0, k);
    if (list.length > _maxCount) list.removeRange(_maxCount, list.length);
    await prefs.setStringList(_key, list);
  }

  /// 删除单条历史
  static Future<void> remove(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    final list = (prefs.getStringList(_key) ?? <String>[]).toList();
    list.remove(keyword);
    await prefs.setStringList(_key, list);
  }

  /// 清空全部历史
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
