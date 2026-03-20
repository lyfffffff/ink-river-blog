/// 博客数据仓库
///
/// 统一数据入口，封装 mock_api_data 与 API 调用
library;

import '../data/mock_api_data.dart' as api;
import '../models/blog_post.dart';
import '../models/comment.dart';

/// 博客仓库
class BlogRepository {
  BlogRepository._();

  static final BlogRepository instance = BlogRepository._();

  /// 首页数据（分页）
  Future<Map<String, dynamic>> getHomeData({int page = 1}) =>
      api.fetchHomeData(page: page);

  /// 文章列表
  Future<List<BlogPost>> getPosts() => api.fetchPosts();

  /// 按分类获取文章
  Future<List<BlogPost>> getPostsByCategory(String category) =>
      api.fetchPostsByCategory(category);

  /// 搜索文章
  Future<List<BlogPost>> search(String keyword) => api.searchPosts(keyword);

  /// 分类列表
  Future<List<String>> getCategoriesWithPosts() =>
      api.fetchCategoriesWithPosts();

  /// 用户资料
  Future<Map<String, dynamic>> getProfile() => api.fetchProfile();

  /// 文章评论
  Future<List<Comment>> getComments(String postId) =>
      api.fetchComments(postId);

  /// 从首页数据解析文章列表
  List<BlogPost> parsePostsFromHomeData(Map<String, dynamic> data) =>
      api.parsePostsFromHomeData(data);

  /// 添加本地评论（会话有效）
  void addLocalComment(String postId, Comment comment) =>
      api.addLocalComment(postId, comment);
}
