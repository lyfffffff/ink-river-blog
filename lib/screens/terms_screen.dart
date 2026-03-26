/// 服务条款页
library;

import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../constants/color.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('服务条款'),
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
              '$appName 服务条款',
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
              title: '一、服务说明',
              content: '''
$appName 为用户提供文章浏览、搜索、编辑与互动服务。使用本应用即表示您同意遵守本条款。
''',
              colorScheme: colorScheme,
            ),
            _Section(
              title: '二、账号与使用',
              content: '''
1. 您需要妥善保管账号信息
2. 不得以任何方式干扰或破坏服务运行
3. 对您发布的内容负责
''',
              colorScheme: colorScheme,
            ),
            _Section(
              title: '三、内容规范',
              content: '''
请勿发布违法、侵权、低俗或敏感内容。平台有权对违规内容进行处理。
''',
              colorScheme: colorScheme,
            ),
            _Section(
              title: '四、免责声明',
              content: '''
本应用按现状提供服务，我们将尽力保障稳定性，但不对不可抗力导致的中断负责。
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
