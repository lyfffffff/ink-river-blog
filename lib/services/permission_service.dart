/// Permission helpers
library;

import '../models/blog_post.dart';
import '../services/auth_service.dart';

enum UserRole {
  guest,
  user,
  owner,
}

class PermissionService {
  PermissionService._();

  static UserRole currentRole() {
    return AuthService.instance.isLoggedIn ? UserRole.user : UserRole.guest;
  }

  static String? currentUserId() {
    return AuthService.instance.user?['id']?.toString();
  }

  static bool canFavorite() => AuthService.instance.isLoggedIn;

  static bool canComment() => AuthService.instance.isLoggedIn;

  static bool isOwner(BlogPost post) {
    final userId = currentUserId();
    if (userId == null || userId.isEmpty) return false;
    return post.authorId == userId;
  }

  static bool canManagePost(BlogPost post) {
    return AuthService.instance.isLoggedIn && isOwner(post);
  }
}
