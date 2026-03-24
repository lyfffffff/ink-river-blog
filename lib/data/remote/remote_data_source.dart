/// Remote data source wrapper (JSONPlaceholder)
library;

import '../../api/blog_api.dart';
import '../../models/blog_post.dart';
import '../../models/comment.dart';

class RemoteDataSource {
  RemoteDataSource._();

  static final RemoteDataSource instance = RemoteDataSource._();

  Future<List<BlogPost>> fetchPostsPage(int page, int limit) {
    return BlogApi.fetchPostsPage(page, limit);
  }

  Future<BlogPost?> fetchPostById(String id) {
    return BlogApi.fetchPostById(id);
  }

  Future<List<Comment>> fetchComments(String postId) {
    return BlogApi.fetchComments(postId);
  }

  Future<Map<String, dynamic>> fetchUser(String userId) {
    return BlogApi.fetchUser(userId);
  }
}
