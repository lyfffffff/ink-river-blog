/// Shared providers
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/blog_repository.dart';
import 'app_controllers.dart';

final blogRepositoryProvider = Provider<BlogRepository>((ref) {
  return BlogRepository.instance;
});

final currentUserIdProvider = Provider<String?>((ref) {
  final auth = ref.watch(authControllerProvider);
  return auth.user?['id']?.toString();
});

final currentUserProfileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null || userId.isEmpty) return {};
  return ref.read(blogRepositoryProvider).getProfile(userId: userId);
});
