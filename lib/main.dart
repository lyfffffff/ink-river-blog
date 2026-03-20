/// 仅负责启动应用，具体配置见 app.dart
library;

import 'package:flutter/material.dart';

import 'app.dart';
import 'theme/app_settings.dart';
import 'theme/app_theme.dart';

import 'services/auth_service.dart';
import 'services/favorite_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTheme.instance.init();
  await AppSettings.instance.init();
  await AuthService.instance.init();
  await FavoriteService.instance.init();
  runApp(const MyApp());
}
