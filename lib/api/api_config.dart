/// API 配置
///
/// 配置后端 baseUrl，用于 HTTP 请求。
/// 支持开发/生产环境切换，默认使用 JSONPlaceholder（只读假数据）。
/// 后续接入真实后端时，切换 [environment] 与 [prodBaseUrl] 即可。
library;

/// 运行环境
enum AppEnvironment {
  /// 开发环境（默认 JSONPlaceholder 假数据）
  dev,

  /// 生产环境（真实后端，接入时替换 [ApiConfig.prodBaseUrl]）
  prod,
}

/// API 配置
class ApiConfig {
  ApiConfig._();

  /// 当前运行环境
  ///
  /// 切换为 [AppEnvironment.prod] 并设置 [prodBaseUrl] 即可接入真实后端。
  static AppEnvironment environment = AppEnvironment.dev;

  /// 开发环境 baseUrl（JSONPlaceholder 只读假数据）
  static const devBaseUrl = 'https://jsonplaceholder.typicode.com';

  /// 生产环境 baseUrl（接入真实后端时替换为真实地址）
  static String prodBaseUrl = 'https://jsonplaceholder.typicode.com';

  /// 当前 baseUrl（按环境自动选择）
  static String get baseUrl =>
      environment == AppEnvironment.prod ? prodBaseUrl : devBaseUrl;

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
