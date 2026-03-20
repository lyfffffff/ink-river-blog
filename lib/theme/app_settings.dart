/// 应用设置管理
///
/// 消息免打扰、字体大小等，持久化到 SharedPreferences
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kDoNotDisturbKey = 'do_not_disturb';
const String _kFontScaleKey = 'font_scale';

/// 字体大小选项
enum FontScaleOption {
  small('小', 0.9),
  medium('中', 1.0),
  large('大', 1.15);

  const FontScaleOption(this.label, this.scale);
  final String label;
  final double scale;
}

/// 设置控制器
class AppSettings extends ChangeNotifier {
  AppSettings._();

  static final AppSettings instance = AppSettings._();

  bool _doNotDisturb = false;
  FontScaleOption _fontScale = FontScaleOption.medium;

  bool get doNotDisturb => _doNotDisturb;
  FontScaleOption get fontScale => _fontScale;
  double get fontScaleValue => _fontScale.scale;

  /// 初始化
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _doNotDisturb = prefs.getBool(_kDoNotDisturbKey) ?? false;
      final scaleIndex = prefs.getInt(_kFontScaleKey) ?? 1;
      _fontScale = FontScaleOption.values[scaleIndex.clamp(0, 2)];
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AppSettings: SharedPreferences 不可用 ($e)');
      }
    }
  }

  /// 设置消息免打扰
  Future<void> setDoNotDisturb(bool enabled) async {
    if (_doNotDisturb == enabled) return;
    _doNotDisturb = enabled;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kDoNotDisturbKey, enabled);
    } catch (_) {}
    notifyListeners();
  }

  /// 设置字体大小
  Future<void> setFontScale(FontScaleOption option) async {
    if (_fontScale == option) return;
    _fontScale = option;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kFontScaleKey, option.index);
    } catch (_) {}
    notifyListeners();
  }
}
