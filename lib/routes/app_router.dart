/// 应用路由配置
///
/// 使用 go_router 统一管理路由
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/about_screen.dart';
import '../screens/article_detail_screen.dart';
import '../screens/article_edit_screen.dart';
import '../screens/article_management_screen.dart';
import '../screens/login_screen.dart';
import '../screens/main_shell.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/register_screen.dart';
import '../screens/search_screen.dart';
import '../screens/setting_screen.dart';
import '../services/auth_service.dart';
import '../models/blog_post.dart';

/// 路由路径
class AppRoutes {
  AppRoutes._();

  static const String main = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String article = '/article/:id';
  static const String articleEdit = '/article/:id/edit';
  static const String articleManagement = '/article-management';
  static const String privacy = '/privacy';
  static const String search = '/search';

  static String articlePath(String id) => '/article/$id';
  static String articleEditPath(String id) => '/article/$id/edit';
}

/// 文章详情导航参数（通过 extra 传递）
class ArticleDetailArgs {
  const ArticleDetailArgs({
    required this.post,
    this.allPosts,
    this.page,
    this.hasNext,
    this.totalCount,
  });

  final BlogPost post;
  final List<BlogPost>? allPosts;
  final int? page;
  final bool? hasNext;
  final int? totalCount;
}

late final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.main,
  redirect: (context, state) {
    final isLoggedIn = AuthService.instance.isLoggedIn;
    final isLoggingIn = state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.register;

    if (!isLoggedIn && !isLoggingIn && state.matchedLocation == AppRoutes.main) {
      return AppRoutes.login;
    }
    if (isLoggedIn && isLoggingIn) {
      return AppRoutes.main;
    }
    return null;
  },
  refreshListenable: AuthService.instance,
  routes: [
    GoRoute(
      path: AppRoutes.main,
      builder: (context, state) => const MainShell(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingScreen(),
    ),
    GoRoute(
      path: AppRoutes.about,
      builder: (context, state) =>
          const AboutScreen(showBackButton: true),
    ),
    GoRoute(
      path: '/article/:id',
      builder: (context, state) {
        final args = state.extra as ArticleDetailArgs?;
        if (args == null) {
          return const Scaffold(
            body: Center(child: Text('参数错误')),
          );
        }
        return ArticleDetailScreen(
          post: args.post,
          allPosts: args.allPosts,
          page: args.page,
          hasNext: args.hasNext,
          totalCount: args.totalCount,
        );
      },
    ),
    GoRoute(
      path: '/article/:id/edit',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ArticleEditScreen(postId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.articleManagement,
      builder: (context, state) => const ArticleManagementScreen(),
    ),
    GoRoute(
      path: AppRoutes.privacy,
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: AppRoutes.search,
      builder: (context, state) => const SearchScreen(),
    ),
  ],
);
