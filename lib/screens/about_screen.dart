/// 关于我页面
///
/// 数据通过 mock API 请求获取
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../constants/color.dart';
import '../core/app_typography.dart';
import '../components/app-bar.dart';
import '../components/settings_button.dart';
import '../components/error_view.dart';
import '../components/loading_view.dart';
import '../repositories/blog_repository.dart';
import '../services/auth_service.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key, this.showBackButton = true});

  final bool showBackButton;

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final userId = AuthService.instance.user?['id']?.toString();
    _profileFuture = BlogRepository.instance.getProfile(userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          }
          if (snapshot.hasError) {
            return ErrorView(
              message: '加载失败: ${snapshot.error}',
              onRetry: () => setState(_loadProfile),
            );
          }
          final profile = snapshot.data ?? {};

          final colorScheme = Theme.of(context).colorScheme;
          return CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildProfileHeader(context, profile),
                      _buildIntroduction(context, profile),
                      _buildSkills(context, profile),
                      _buildTimeline(context, profile),
                      _buildContact(context),
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return OwAppBar(
      title: '关于我',
      showBackButton: false,
      leading: widget.showBackButton
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => context.pop(),
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SettingsButton(),
              ],
            )
          : const SettingsButton(),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share_rounded),
          onPressed: () {},
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ],
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    Map<String, dynamic> profile,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final aboutAvatarUrl =
        profile['aboutAvatarUrl'] as String? ?? profile['avatarUrl'] as String? ?? '';
    final name = profile['name'] as String? ?? appName;
    final quote = profile['quote'] as String? ?? '';
    final aboutSubtitle = profile['aboutSubtitle'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                aboutAvatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.person, size: 64),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            name,
            style: AppTypography.displayLarge(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            quote,
            style: AppTypography.titleLargeItalic(
              fontSize: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            aboutSubtitle,
            style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroduction(
    BuildContext context,
    Map<String, dynamic> profile,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final introParagraphs =
        profile['introParagraphs'] as List<dynamic>? ?? [];
    final paragraphs = introParagraphs.map((e) => e.toString()).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.primary, width: 4),
              ),
            ),
            child: Text(
              '个人简介',
              style: AppTypography.titleLarge(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...paragraphs.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                p,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.8,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkills(BuildContext context, Map<String, dynamic> profile) {
    final colorScheme = Theme.of(context).colorScheme;
    final skills = profile['skills'] as List<dynamic>? ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.primary, width: 4),
              ),
            ),
            child: Text(
              '兴趣与技能',
              style: AppTypography.titleLarge(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 2.5,
            children: skills.map<Widget>((skill) {
              final s = skill as Map<String, dynamic>;
              final icon = s['icon'];
              final label = s['label'] as String? ?? '';
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    if (icon != null)
                      Icon(
                        icon as IconData,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, Map<String, dynamic> profile) {
    final colorScheme = Theme.of(context).colorScheme;
    final timeline = profile['timeline'] as List<dynamic>? ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.primary, width: 4),
              ),
            ),
            child: Text(
              '创作历程',
              style: AppTypography.titleLarge(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ...timeline.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value as Map<String, dynamic>;
            final isPrimary = item['isPrimary'] as bool? ?? false;
            return _TimelineItem(
              period: item['period'] as String? ?? '',
              title: item['title'] as String? ?? '',
              desc: item['desc'] as String? ?? '',
              isPrimary: isPrimary,
              isLast: i == timeline.length - 1,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContact(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Column(
        children: [
          Text(
            '与我联络',
            style: AppTypography.titleLarge(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ContactIcon(icon: Icons.mail_outline_rounded),
              const SizedBox(width: 32),
              _ContactIcon(icon: Icons.code_rounded),
              const SizedBox(width: 32),
              _ContactIcon(icon: Icons.camera_alt_outlined),
              const SizedBox(width: 32),
              _ContactIcon(icon: Icons.rss_feed_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Text(
            '© 2024 $appName. 保留所有权利。',
            style: TextStyle(fontSize: 12, color: colorScheme.outline),
          ),
          const SizedBox(height: 4),
          Text(
            '由 极简主义 与 热情 驱动',
            style: TextStyle(fontSize: 12, color: colorScheme.outline),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.period,
    required this.title,
    required this.desc,
    required this.isPrimary,
    required this.isLast,
  });

  final String period;
  final String title;
  final String desc;
  final bool isPrimary;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surface,
                  border: Border.all(
                    color: isPrimary ? AppColors.primary : colorScheme.outline,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPrimary
                          ? AppColors.primary
                          : colorScheme.outline,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: Theme.of(context).dividerColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    period,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isPrimary ? AppColors.primary : colorScheme.outline,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: AppTypography.titleMedium(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactIcon extends StatelessWidget {
  const _ContactIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 32,
      color: Theme.of(context).colorScheme.outline,
    );
  }
}
