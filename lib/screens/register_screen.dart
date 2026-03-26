/// 注册页 - 1:1 复刻 stitch 原型
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/auth_form_field.dart';
import '../components/primary_button.dart';
import '../data/mock_api_data.dart';
import '../utils/toast_util.dart';
import '../constants/app_constants.dart';
import '../constants/color.dart';
import '../core/app_typography.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _agreed = false;
  bool _submitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_agreed) {
      showTopError(context, '请先阅读并同意服务条款和隐私政策');
      return;
    }
    setState(() => _submitting = true);
    final res = await register(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (mounted) setState(() => _submitting = false);
    if (!mounted) return;
    if (res['code'] == 200) {
      showTopMessage(context, '注册成功，请登录');
      context.go('/login');
    } else {
      showTopError(context, res['msg'] as String? ?? '注册失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop(),
              ),
              title: const Text('立即注册'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '创建您的账户',
                      style: AppTypography.displayLarge(
                        fontSize: 32,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '加入$appName，探索更多内容',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AuthFormField(
                        label: '用户名',
                        controller: _usernameController,
                        placeholder: '请输入用户名',
                        validator: (v) =>
                            (v == null || v.isEmpty) ? '请输入用户名' : null,
                      ),
                      const SizedBox(height: 20),
                      AuthFormField(
                        label: '电子邮箱',
                        controller: _emailController,
                        placeholder: 'example@email.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? '请输入电子邮箱' : null,
                      ),
                      const SizedBox(height: 20),
                      AuthFormField(
                        label: '密码',
                        controller: _passwordController,
                        placeholder: '请输入密码',
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) return '请输入密码';
                          if (v.length < 6) return '密码不能少于6位';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      AuthFormField(
                        label: '确认密码',
                        controller: _confirmController,
                        placeholder: '请再次输入密码',
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) return '请确认密码';
                          if (v != _passwordController.text) {
                            return '两次输入的密码不一致';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _agreed,
                              onChanged: (v) =>
                                  setState(() => _agreed = v ?? false),
                              activeColor: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  children: [
                                    const TextSpan(text: '我已阅读并同意 '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => context.push('/terms'),
                        child: Text(
                          '服务条款',
                          style: TextStyle(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                                    const TextSpan(text: ' 和 '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => context.push('/privacy'),
                        child: Text(
                          '隐私政策',
                          style: TextStyle(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: _submitting ? '注册中...' : '注册',
                        height: 56,
                        onPressed: _submitting ? () {} : _submit,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '已有账户？',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => context.go('/login'),
                            child: Text(
                              '立即登录',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }
}
