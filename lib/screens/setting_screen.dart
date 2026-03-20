/// 设置页 - 1:1 复刻 stitch 原型
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/app-bar.dart';
import '../components/auth_form_field.dart';
import '../components/settings_item.dart';
import '../components/settings_section.dart';
import '../components/settings_switch_item.dart';
import '../constants/app_constants.dart';
import '../constants/color.dart';
import '../data/mock_api_data.dart';
import '../services/auth_service.dart';
import '../utils/toast_util.dart';
import '../theme/app_settings.dart' show AppSettings, FontScaleOption;
import '../theme/app_theme.dart';
import 'article_management_screen.dart';
import 'login_screen.dart';
import 'privacy_policy_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _pushEnabled = true;

  void _logout() {
    AuthService.instance.clearLogin();
    if (!mounted) return;
    context.go('/login');
  }

  void _showChangePasswordDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    String? validator(String? v) {
      if (v == null || v.isEmpty) return '请输入密码';
      if (v.length < 6) return '密码不能少于6位';
      return null;
    }

    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              constraints: const BoxConstraints(maxWidth: 420),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '修改密码',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '请定期更换您的密码以保证账号安全',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AuthFormField(
                        label: '当前密码',
                        controller: oldCtrl,
                        placeholder: '请输入当前密码',
                        obscureText: true,
                        validator: validator,
                      ),
                      const SizedBox(height: 16),
                      AuthFormField(
                        label: '新密码',
                        controller: newCtrl,
                        placeholder: '请输入 8-16 位新密码',
                        obscureText: true,
                        validator: validator,
                      ),
                      const SizedBox(height: 16),
                      AuthFormField(
                        label: '确认新密码',
                        controller: confirmCtrl,
                        placeholder: '请再次输入新密码',
                        obscureText: true,
                        validator: (v) {
                          final r = validator(v);
                          if (r != null) return r;
                          if (v != newCtrl.text) return '两次输入的新密码不一致';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => ctx.pop(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(
                                  color: Theme.of(ctx).dividerColor,
                                ),
                              ),
                              child: const Text('取消'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (!(formKey.currentState?.validate() ?? false)) {
                                  return;
                                }
                                final res = await changePassword(
                                  userId: 'u_1',
                                  oldPassword: oldCtrl.text,
                                  newPassword: newCtrl.text,
                                  newPassword2: confirmCtrl.text,
                                );
                                if (!ctx.mounted) return;
                                ctx.pop();
                                if (!context.mounted) return;
                                final msg = res['msg'] as String? ?? '操作完成';
                                if (res['code'] == 200) {
                                  showTopMessage(context, msg);
                                } else {
                                  showTopError(context, msg);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text('保存修改'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFontScaleDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '字体大小',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...FontScaleOption.values.map((opt) {
                final isSelected =
                    AppSettings.instance.fontScale == opt;
                return ListTile(
                  title: Text(opt.label),
                  trailing: isSelected
                      ? Icon(Icons.check_rounded, color: AppColors.primary)
                      : null,
                  onTap: () {
                    AppSettings.instance.setFontScale(opt);
                    ctx.pop();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }


  void _showLogoutDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colorScheme.surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.logout_rounded, size: 32, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              appName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '确定要退出登录吗？',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '退出后将无法接收实时通知',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.outline,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: Text(
              '取消',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () {
              ctx.pop();
              _logout();
            },
            child: const Text(
              '确认退出',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          OwAppBar(
            title: '设置',
            showBackButton: true,
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SettingsSection(
                  title: '账号安全',
                  children: [
                    SettingsItem(title: '账号 ID', value: '12345678'),
                    SettingsItem(
                      title: '修改密码',
                      showDivider: false,
                      onTap: () => _showChangePasswordDialog(context),
                    ),
                  ],
                ),
                SettingsSection(
                  title: '通知设置',
                  children: [
                    SettingsSwitchItem(
                      title: '推送通知',
                      value: _pushEnabled,
                      onChanged: (v) => setState(() => _pushEnabled = v),
                    ),
                    ListenableBuilder(
                      listenable: AppSettings.instance,
                      builder: (context, _) => SettingsSwitchItem(
                        title: '消息免打扰',
                        value: AppSettings.instance.doNotDisturb,
                        onChanged: (v) =>
                            AppSettings.instance.setDoNotDisturb(v),
                        showDivider: false,
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  title: '个性外观',
                  children: [
                    ListenableBuilder(
                      listenable: AppTheme.instance,
                      builder: (context, _) => SettingsSwitchItem(
                        title: '深色模式',
                        value: AppTheme.instance.isDark,
                        onChanged: (v) => AppTheme.instance.setDarkMode(v),
                      ),
                    ),
                    ListenableBuilder(
                      listenable: AppSettings.instance,
                      builder: (context, _) => SettingsItem(
                        title: '字体大小',
                        value: AppSettings.instance.fontScale.label,
                        showDivider: false,
                        onTap: () => _showFontScaleDialog(context),
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  title: '内容管理',
                  children: [
                    SettingsItem(
                      title: '管理文章',
                      onTap: () {
                        if (AuthService.instance.isLoggedIn) {
                          context.push('/article-management');
                        } else {
                          showTopError(context, '请先登录');
                          context.push('/login');
                        }
                      },
                      showDivider: false,
                    ),
                  ],
                ),
                SettingsSection(
                  title: '关于',
                  children: [
                    SettingsItem(title: '当前版本', value: 'v 2.4.0'),
                    SettingsItem(
                      title: '隐私协议',
                      showDivider: false,
                      onTap: () => context.push('/privacy'),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListenableBuilder(
                    listenable: AuthService.instance,
                    builder: (context, _) {
                      final isLoggedIn = AuthService.instance.isLoggedIn;
                      return SizedBox(
                        width: double.infinity,
                        child: isLoggedIn
                            ? OutlinedButton(
                                onPressed: () => _showLogoutDialog(context),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: const BorderSide(color: Colors.red),
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('退出登录'),
                              )
                            : FilledButton(
                                onPressed: () => context.push('/login'),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text('登录'),
                              ),
                    );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '$appName · 见天地 见众生 见自己',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
