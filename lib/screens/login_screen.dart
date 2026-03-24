/// 登录页 - 1:1 复刻 stitch 原型
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/auth_form_field.dart';
import '../components/auth_form_layout.dart';
import '../components/primary_button.dart';
import '../constants/app_constants.dart';
import '../constants/color.dart';
import '../data/mock_api_data.dart';
import '../repositories/blog_repository.dart';
import '../services/auth_service.dart';
import '../utils/toast_util.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _loading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    final res = await login(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );
    setState(() => _loading = false);
    if (!mounted) return;
    if (res['code'] == 200) {
      final user = res['data'] as Map<String, dynamic>?;
      if (user != null) {
        final userId = user['id']?.toString();
        if (userId != null && userId.isNotEmpty) {
          final profile =
              await BlogRepository.instance.getProfile(userId: userId);
          final merged = {
            ...user,
            if (profile['name'] != null) 'nickname': profile['name'],
            if (profile['avatarUrl'] != null) 'avatarUrl': profile['avatarUrl'],
            if (profile['subtitle'] != null) 'subtitle': profile['subtitle'],
          };
          await AuthService.instance.saveLogin(merged, persist: _rememberMe);
        } else {
          await AuthService.instance.saveLogin(user, persist: _rememberMe);
        }
      }
      if (!mounted) return;
      final from = GoRouterState.of(context).uri.queryParameters['from'];
      if (from != null && from.isNotEmpty) {
        context.go(from);
      } else {
        context.go('/');
      }
    } else {
      showTopError(context, res['msg'] as String? ?? '登录失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: AuthFormLayout(
          title: appName,
          subtitle: '执笔墨色，共绘山河',
          trailing: TextButton(
            onPressed: () => context.go('/'),
            child: Text(
              '暂时跳过',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthFormField(
                  label: '用户名 / 邮箱',
                  controller: _usernameController,
                  placeholder: '请输入您的账号',
                  validator: (v) =>
                      (v == null || v.isEmpty) ? '请输入用户名或邮箱' : null,
                ),
                const SizedBox(height: 20),
                AuthFormField(
                  label: '密码',
                  controller: _passwordController,
                  placeholder: '请输入您的密码',
                  obscureText: true,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? '请输入密码' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (v) =>
                            setState(() => _rememberMe = v ?? false),
                        activeColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '记住登录状态',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: _loading ? '登录中...' : '立即登录',
                  onPressed: _loading ? () {} : _submit,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '还没有账号？ ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/register'),
                      child: Text(
                        '立即注册',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
