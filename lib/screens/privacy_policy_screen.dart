/// 隐私协议页
library;

import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../constants/color.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('隐私协议'),
        centerTitle: true,
        backgroundColor: colorScheme.surface.withValues(alpha: 0.95),
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$appName 隐私协议',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '更新日期：2025年3月',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            _Section(
              title: '一、信息收集',
              content: '''
我们重视您的隐私。在使用 $appName 时，我们可能收集以下信息：

1. 您主动提供的信息：如注册时填写的用户名、邮箱等
2. 设备信息：为提供更好的服务，我们可能收集设备型号、操作系统版本等
3. 使用数据：如文章浏览记录、阅读偏好等，用于优化内容推荐
''',
              colorScheme: colorScheme,
            ),
            _Section(
              title: '二、信息使用',
              content: '''
我们收集的信息将用于：

1. 提供、维护和改进我们的服务
2. 个性化您的使用体验
3. 发送重要通知（如您已订阅）
4. 保障账号与内容安全
5. 遵守法律法规要求
''',
              colorScheme: colorScheme,
            ),
            _Section(
              title: '三、信息共享',
              content: '''
我们不会出售您的个人信息。在以下情况下，我们可能与第三方共享信息：

1. 经您明确同意
2. 为完成您请求的服务所必需
3. 法律法规要求或合法程序
4. 保护 $appName 及用户的安全与权益
''',
              colorScheme: colorScheme,
            ),
            _Section(
              title: '四、数据安全',
              content: '''
我们采取合理的技术和管理措施保护您的个人信息，防止未经授权的访问、使用或泄露。但请注意，没有任何互联网传输或电子存储方式是绝对安全的。
''',
              colorScheme: colorScheme,
            ),
            _Section(
              title: '五、您的权利',
              content: '''
您有权：

1. 访问、更正或删除您的个人信息
2. 撤回此前给予的同意
3. 注销账号
4. 就隐私问题联系我们

如您对本协议有任何疑问，请通过应用内「关于我」页面的联系方式与我们联系。
''',
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                '$appName · 见天地 见众生 见自己',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.outline,
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.content,
    required this.colorScheme,
  });

  final String title;
  final String content;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content.trim(),
            style: TextStyle(
              fontSize: 15,
              height: 1.7,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
