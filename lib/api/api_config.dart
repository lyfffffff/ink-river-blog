/// API 配置
///
/// 配置后端 baseUrl，用于 HTTP 请求
/// 默认使用 JSONPlaceholder: /posts, /comments, /users
library;

/// API 配置
class ApiConfig {
  ApiConfig._();

  /// 后端 baseUrl
  static String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// 文章列表 GET /posts
  static String get postsPath => '$baseUrl/posts';

  /// 文章列表分页 GET /posts?_page=1&_limit=10
  static String postsPagePath(int page, int limit) =>
      '$baseUrl/posts?_page=$page&_limit=$limit';

  /// 单篇文章 GET /posts/{id}
  static String postPath(String id) => '$baseUrl/posts/$id';

  /// 文章评论 GET /posts/{postId}/comments
  static String commentsPath(String postId) => '$baseUrl/posts/$postId/comments';

  /// 用户信息 GET /users/{userId}
  static String userPath(String userId) => '$baseUrl/users/$userId';
}
