/// 我的关注
library;

import 'package:flutter/material.dart';

import '../components/app-bar.dart';
import '../components/empty_view.dart';
import '../services/follow_service.dart';
import '../utils/toast_util.dart';
import '../constants/color.dart';
import '../repositories/blog_repository.dart';

class FollowsScreen extends StatefulWidget {
  const FollowsScreen({super.key});

  @override
  State<FollowsScreen> createState() => _FollowsScreenState();
}

class _FollowsScreenState extends State<FollowsScreen> {
  final Map<String, Future<Map<String, dynamic>>> _profileFutures = {};

  Future<Map<String, dynamic>> _loadProfile(String userId) {
    return _profileFutures.putIfAbsent(
      userId,
      () => BlogRepository.instance.getProfile(userId: userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListenableBuilder(
        listenable: FollowService.instance,
        builder: (context, _) {
          final ids = FollowService.instance.ids.toList();
          return CustomScrollView(
            slivers: [
              OwAppBar(
                title: '我的关注',
                showBackButton: true,
                centerTitle: true,
              ),
              SliverToBoxAdapter(
                child: ids.isEmpty
                    ? const EmptyView(
                        message: '暂无关注',
                        icon: Icons.person_off_rounded,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: ids.map((id) {
                            return FutureBuilder<Map<String, dynamic>>(
                              future: _loadProfile(id),
                              builder: (context, snapshot) {
                                final profile = snapshot.data ?? {};
                                final name =
                                    (profile['name']?.toString().trim().isNotEmpty ??
                                            false)
                                        ? profile['name'].toString()
                                        : '作者 $id';
                                final subtitle =
                                    profile['subtitle']?.toString() ?? '';
                                final avatarUrl =
                                    profile['avatarUrl']?.toString() ?? '';
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: AppColors.primary
                                          .withValues(alpha: 0.15),
                                      backgroundImage: avatarUrl.isNotEmpty
                                          ? NetworkImage(avatarUrl)
                                          : null,
                                      child: avatarUrl.isEmpty
                                          ? const Icon(Icons.person)
                                          : null,
                                    ),
                                    title: Text(name),
                                    subtitle: subtitle.isNotEmpty
                                        ? Text(subtitle)
                                        : null,
                                    trailing: TextButton(
                                      onPressed: () async {
                                        await FollowService.instance.remove(id);
                                        _profileFutures.remove(id);
                                        if (context.mounted) {
                                          showTopMessage(context, '已取消关注');
                                        }
                                      },
                                      child: const Text('取消关注'),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
