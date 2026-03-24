/// App-level controllers
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';
import '../services/favorite_service.dart';
import '../theme/app_settings.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._service) {
    _service.addListener(_onChanged);
  }

  final AuthService _service;

  Map<String, dynamic>? get user => _service.user;
  bool get isLoggedIn => _service.isLoggedIn;

  Future<void> saveLogin(Map<String, dynamic> user, {bool persist = true}) {
    return _service.saveLogin(user, persist: persist);
  }

  Future<void> clearLogin() => _service.clearLogin();

  void _onChanged() => notifyListeners();

  @override
  void dispose() {
    _service.removeListener(_onChanged);
    super.dispose();
  }
}

class FavoritesController extends ChangeNotifier {
  FavoritesController(this._service) {
    _service.addListener(_onChanged);
  }

  final FavoriteService _service;

  Set<String> get ids => _service.ids;

  bool isFavorite(String postId) => _service.isFavorite(postId);

  Future<bool> toggle(String postId) => _service.toggle(postId);

  Future<bool> add(String postId) => _service.add(postId);

  Future<bool> remove(String postId) => _service.remove(postId);

  void _onChanged() => notifyListeners();

  @override
  void dispose() {
    _service.removeListener(_onChanged);
    super.dispose();
  }
}

class SettingsController extends ChangeNotifier {
  SettingsController(this._settings) {
    _settings.addListener(_onChanged);
  }

  final AppSettings _settings;

  bool get doNotDisturb => _settings.doNotDisturb;
  FontScaleOption get fontScale => _settings.fontScale;
  double get fontScaleValue => _settings.fontScaleValue;

  void setDoNotDisturb(bool value) => _settings.setDoNotDisturb(value);
  void setFontScale(FontScaleOption option) => _settings.setFontScale(option);

  void _onChanged() => notifyListeners();

  @override
  void dispose() {
    _settings.removeListener(_onChanged);
    super.dispose();
  }
}

final authControllerProvider = ChangeNotifierProvider<AuthController>((ref) {
  return AuthController(AuthService.instance);
});

final favoritesControllerProvider =
    ChangeNotifierProvider<FavoritesController>((ref) {
  return FavoritesController(FavoriteService.instance);
});

final settingsControllerProvider =
    ChangeNotifierProvider<SettingsController>((ref) {
  return SettingsController(AppSettings.instance);
});
