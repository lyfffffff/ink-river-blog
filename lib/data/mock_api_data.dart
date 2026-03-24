/// 虚拟 API 请求数据
///
/// 文章、评论、用户等从 JSONPlaceholder 获取
/// 编辑、保存、删除、评论等为本地 overlay（会话有效）
library;

import '../api/blog_api.dart';
import '../models/blog_post.dart';
import '../models/comment.dart';
import 'mock_data.dart';

/// API 响应结构：{code, msg, data}
Map<String, dynamic> apiResponse({
  int code = 200,
  String msg = '操作成功',
  dynamic data,
}) => {'code': code, 'msg': msg, 'data': data};

/// 模拟网络延迟
Future<T> _delay<T>(T value, [int ms = 300]) async {
  await Future.delayed(Duration(milliseconds: ms));
  return value;
}

/// Mock 会话状态：已删除的文章 id（线上数据模式下本地移除）
final Set<String> _removedPostIds = {};

/// Mock 会话状态：已保存的文章覆盖数据（线上数据模式下本地替换同 id 内容）
final Map<String, Map<String, dynamic>> _savedPostOverrides = {};

/// Mock 会话状态：本地发布的评论（按 postId 分组，插入到线上评论中）
final Map<String, List<Comment>> _localCommentsByPostId = {};

/// Mock 会话状态：修改密码后的新密码（内存存储，刷新后恢复为 123456）
String? _localPasswordOverride;

/// 文章、评论统一使用线上 API，此处仅作 fallback 占位（空列表）
final List<BlogPost> mockPosts = [];
final List<Comment> mockComments = [];

/// 获取有效文章列表（排除已删除，应用已保存覆盖）
List<Map<String, dynamic>> _getEffectivePosts() {
  return mockPosts.where((p) => !_removedPostIds.contains(p.id)).map((p) {
    final over = _savedPostOverrides[p.id];
    return over ?? _postToMap(p);
  }).toList();
}

/// 对线上文章列表应用本地 overlay：过滤已删除、替换已编辑
List<BlogPost> _applyOverlayToPosts(List<BlogPost> posts) {
  return posts
      .where((p) => !_removedPostIds.contains(p.id))
      .map((p) {
        final over = _savedPostOverrides[p.id];
        if (over != null) return _postFromMap(over);
        return p;
      })
      .toList();
}

/// 根据 id 获取博客文章
Future<Map<String, dynamic>> getPostById(String id) async {
  if (_removedPostIds.contains(id)) {
    return _delay(apiResponse(code: 404, msg: '文章不存在', data: null));
  }
  final over = _savedPostOverrides[id];
  if (over != null) {
    return _delay(apiResponse(data: over));
  }
  final post = mockPosts.cast<BlogPost?>().firstWhere(
    (p) => p?.id == id,
    orElse: () => null,
  );
  if (post == null) {
    return _delay(apiResponse(code: 404, msg: '文章不存在', data: null));
  }
  return _delay(apiResponse(data: _postToMap(post)));
}

/// 获取博客文章列表
Future<Map<String, dynamic>> getPosts() async {
  final list = _getEffectivePosts();
  return _delay(apiResponse(data: list));
}

/// 根据 id 获取评论
Future<Map<String, dynamic>> getCommentById(String id) async {
  final comment = mockComments.cast<Comment?>().firstWhere(
    (c) => c?.id == id,
    orElse: () => null,
  );
  if (comment == null) {
    return _delay(apiResponse(code: 404, msg: '评论不存在', data: null));
  }
  return _delay(apiResponse(data: _commentToMap(comment)));
}

/// 根据文章 id 获取评论列表
Future<Map<String, dynamic>> getCommentsByPostId(String postId) async {
  final list = mockComments.map((c) => _commentToMap(c)).toList();
  return _delay(apiResponse(data: list));
}

/// 根据 id 获取数据（统一入口）
/// id 类型：'posts' | 'post_1' | 'post_2' | 'post_3' | 'comments' | 'comment_1' | 'comment_2' | 'profile' | 'categories'
Future<Map<String, dynamic>> getDataById(String id) async {
  if (id == 'profile') {
    return _delay(apiResponse(data: _profileToMap()));
  }
  if (id == 'categories') {
    try {
      final cats = await fetchCategoriesWithPosts();
      return _delay(apiResponse(data: cats.isNotEmpty ? cats : blogInfo['categories']));
    } catch (_) {
      return _delay(apiResponse(data: blogInfo['categories']));
    }
  }
  if (id == 'posts') {
    return getPosts();
  }
  if (id.startsWith('post_')) {
    return getPostById(id.replaceFirst('post_', ''));
  }
  if (id == 'comments') {
    return _delay(
      apiResponse(data: mockComments.map((c) => _commentToMap(c)).toList()),
    );
  }
  if (id.startsWith('comment_')) {
    return getCommentById(id.replaceFirst('comment_', ''));
  }
  return _delay(apiResponse(code: 404, msg: '资源不存在', data: null));
}

Map<String, dynamic> _postToMap(BlogPost post) => {
  'id': post.id,
  'authorId': post.authorId,
  'title': post.title,
  'excerpt': post.excerpt,
  'category': post.category,
  'date': post.date,
  'imageUrl': post.imageUrl,
  'content': post.content,
  'readMinutes': post.readMinutes,
  'tags': post.tags,
};

Map<String, dynamic> _commentToMap(Comment comment) => {
  'id': comment.id,
  'authorName': comment.authorName,
  'authorInitial': comment.authorInitial,
  'content': comment.content,
  'timeAgo': comment.timeAgo,
  'likeCount': comment.likeCount,
};

Map<String, dynamic> _profileToMap() => {
  'name': userInfo['name'],
  'subtitle': userInfo['subtitle'],
  'quote': userInfo['quote'],
  'avatarUrl': userInfo['avatarUrl'],
  'aboutAvatarUrl': userInfo['aboutAvatarUrl'],
  'aboutSubtitle': userInfo['aboutSubtitle'],
  'introParagraphs': userInfo['introParagraphs'],
  'skills': userInfo['skills'],
  'timeline': userInfo['timeline'],
};

/// ============================
///  模拟业务接口
/// ============================

/// 当前有效密码（修改密码后使用新密码，刷新后恢复 123456）
String _getEffectivePassword() => _localPasswordOverride ?? '123456';

/// /login 登录接口
/// 参数：username, password
/// 修改密码后需使用新密码登录，刷新应用后恢复默认 123456
Future<Map<String, dynamic>> login({
  required String username,
  required String password,
}) async {
  if (username == 'admin' && password == _getEffectivePassword()) {
    final user = {
      'id': '1',
      'username': username,
      'nickname': userInfo['name'],
      'avatarUrl': userInfo['avatarUrl'],
    };
    return _delay(apiResponse(data: user));
  }
  return _delay(apiResponse(code: 401, msg: '用户名或密码错误', data: null));
}

/// /blog 获取用户博客信息
/// 参数：userId
/// 这里不区分具体用户，返回全站博客 + 个人信息
Future<Map<String, dynamic>> getBlogByUserId(String userId) async {
  final data = {
    'user': {
      'id': userId,
      'nickname': userInfo['name'],
      'avatarUrl': userInfo['avatarUrl'],
      'subtitle': userInfo['subtitle'],
    },
    'posts': _getEffectivePosts(),
    'categories': blogInfo['categories'],
  };
  return _delay(apiResponse(data: data));
}

/// ============================
///  文章 CRUD 接口
/// ============================

/// /edit 获取文章详情（用于编辑）
/// 从 JSONPlaceholder 获取，本地已编辑的优先
Future<Map<String, dynamic>> editArticle(String id) async {
  if (_removedPostIds.contains(id)) {
    return _delay(apiResponse(code: 404, msg: '文章不存在', data: null));
  }
  final over = _savedPostOverrides[id];
  if (over != null) return _delay(apiResponse(data: over));
  final post = await BlogApi.fetchPostById(id);
  if (post == null) return _delay(apiResponse(code: 404, msg: '文章不存在', data: null));
  return _delay(apiResponse(data: _postToMap(post)));
}

/// /save 保存文章
/// 参数：文章 id、文章详情
/// 线上模式下用本地数据替换同 id 内容
Future<Map<String, dynamic>> saveArticle(
  String id,
  Map<String, dynamic> article,
) async {
  if (_removedPostIds.contains(id)) {
    return _delay(apiResponse(code: 404, msg: '文章不存在', data: null));
  }
  Map<String, dynamic>? existing = _savedPostOverrides[id];
  if (existing == null) {
    final post = await BlogApi.fetchPostById(id);
    if (post != null) existing = _postToMap(post);
  }
  if (existing == null) {
    return _delay(apiResponse(code: 404, msg: '文章不存在', data: null));
  }
  final merged = {
    'id': id,
    'title': article['title'] ?? existing['title'],
    'excerpt': article['excerpt'] ?? existing['excerpt'],
    'category': article['category'] ?? existing['category'],
    'date': article['date'] ?? existing['date'],
    'imageUrl': article['imageUrl'] ?? existing['imageUrl'],
    'content': article['content'] ?? existing['content'],
    'readMinutes': article['readMinutes'] ?? existing['readMinutes'],
    'tags': article['tags'] != null
        ? List<String>.from(article['tags'] as List)
        : List<String>.from(existing['tags'] as List),
  };
  _savedPostOverrides[id] = Map<String, dynamic>.from(merged);
  return _delay(apiResponse(msg: '保存成功', data: merged));
}

/// /remove 删除文章
/// 参数：文章 id
/// 线上模式下仅在本地移除，刷新后恢复
Future<Map<String, dynamic>> removeArticle(String id) async {
  if (_removedPostIds.contains(id)) {
    return _delay(apiResponse(code: 404, msg: '文章已删除', data: null));
  }
  final exists = _savedPostOverrides.containsKey(id) ||
      (await BlogApi.fetchPostById(id)) != null;
  if (!exists) {
    return _delay(apiResponse(code: 404, msg: '文章不存在', data: null));
  }
  _removedPostIds.add(id);
  _savedPostOverrides.remove(id);
  return _delay(apiResponse(msg: '删除成功', data: null));
}

/// /change_password 修改密码
/// 参数：userId, oldPassword, newPassword, newPassword2
/// 本地 overlay：修改后退出登录需用新密码登录，刷新应用后恢复默认 123456
Future<Map<String, dynamic>> changePassword({
  required String userId,
  required String oldPassword,
  required String newPassword,
  required String newPassword2,
}) async {
  // 校验新密码一致
  if (newPassword != newPassword2) {
    return _delay(apiResponse(code: 400, msg: '两次输入的新密码不一致', data: null));
  }

  // 校验旧密码（支持修改密码后的新密码作为旧密码）
  if (oldPassword != _getEffectivePassword()) {
    return _delay(apiResponse(code: 400, msg: '旧密码不正确', data: null));
  }

  _localPasswordOverride = newPassword;
  return _delay(apiResponse(msg: '密码修改成功', data: {'userId': userId}));
}

/// ============================
///  页面数据获取（供 UI 调用）
/// ============================

BlogPost _postFromMap(Map<String, dynamic> m) => BlogPost(
  id: m['id'] as String,
  authorId: m['authorId']?.toString() ?? 'u_1',
  title: m['title'] as String,
  excerpt: m['excerpt'] as String,
  category: m['category'] as String,
  date: m['date'] as String,
  imageUrl: m['imageUrl'] as String,
  content: m['content'] as String,
  readMinutes: m['readMinutes'] as int,
  tags: List<String>.from(m['tags'] as List),
);

Comment _commentFromMap(Map<String, dynamic> m) => Comment(
  id: m['id'] as String,
  authorName: m['authorName'] as String,
  authorInitial: m['authorInitial'] as String,
  content: m['content'] as String,
  timeAgo: m['timeAgo'] as String,
  likeCount: m['likeCount'] as int,
);

/// 从 fetchHomeData 返回的 Map 中解析 posts 列表（支持 BlogPost 或 Map）
List<BlogPost> parsePostsFromHomeData(Map<String, dynamic> data) {
  final raw = data['posts'] as List? ?? [];
  return raw.map((e) {
    if (e is BlogPost) return e;
    return _postFromMap(e as Map<String, dynamic>);
  }).toList();
}

/// 获取用户资料（首页 Hero、关于页）
/// 请求 /users/1，缺失字段用 Mock 补全
Future<Map<String, dynamic>> fetchProfile() async {
  try {
    final profile = await BlogApi.fetchUser('1');
    if (profile.isNotEmpty) {
      return {
        ...profile,
        'quote': profile['quote'] ?? userInfo['quote'],
        'introParagraphs':
            (profile['introParagraphs'] as List?)?.isNotEmpty == true
                ? profile['introParagraphs']
                : userInfo['introParagraphs'],
        'skills': (profile['skills'] as List?)?.isNotEmpty == true
            ? profile['skills']
            : userInfo['skills'],
        'timeline': (profile['timeline'] as List?)?.isNotEmpty == true
            ? profile['timeline']
            : userInfo['timeline'],
      };
    }
  } catch (_) {}
  final res = await getDataById('profile');
  return res['code'] == 200 ? res['data'] as Map<String, dynamic> : {};
}

/// 获取博客文章列表
/// 请求 JSONPlaceholder，本地 overlay：过滤已删除、替换已编辑
Future<List<BlogPost>> fetchPosts() async {
  try {
    final posts = await BlogApi.fetchPosts();
    if (posts.isNotEmpty) return _applyOverlayToPosts(posts);
  } catch (_) {}
  final res = await getPosts();
  if (res['code'] != 200 || res['data'] == null) return [];
  return (res['data'] as List)
      .map((e) => _postFromMap(e as Map<String, dynamic>))
      .toList();
}

/// 按分类获取文章列表
Future<List<BlogPost>> fetchPostsByCategory(String category) async {
  final posts = await fetchPosts();
  return posts.where((p) => p.category == category).toList();
}

/// 搜索文章（标题、摘要、内容、标签）
Future<List<BlogPost>> searchPosts(String keyword) async {
  if (keyword.trim().isEmpty) return fetchPosts();
  final posts = await fetchPosts();
  final k = keyword.trim().toLowerCase();
  return posts.where((p) {
    if (p.title.toLowerCase().contains(k)) return true;
    if (p.excerpt.toLowerCase().contains(k)) return true;
    if (p.content.toLowerCase().contains(k)) return true;
    if (p.tags.any((t) => t.toLowerCase().contains(k))) return true;
    return false;
  }).toList();
}

/// 获取分类列表
Future<List<String>> fetchCategories() async {
  final res = await getDataById('categories');
  if (res['code'] != 200 || res['data'] == null) return [];
  return List<String>.from(res['data'] as List);
}

/// 获取有文章的分类列表（从文章数据中提取）
Future<List<String>> fetchCategoriesWithPosts() async {
  final posts = await fetchPosts();
  final set = <String>{};
  for (final p in posts) {
    set.add(p.category);
  }
  return set.toList()..sort();
}

/// 添加本地发布的评论（插入到线上评论中，仅会话有效）
void addLocalComment(String postId, Comment comment) {
  _localCommentsByPostId.putIfAbsent(postId, () => []).add(comment);
}

/// 获取评论列表
/// 请求 /posts/{postId}/comments，本地发布的评论插入末尾
Future<List<Comment>> fetchComments(String postId) async {
  List<Comment> comments;
  try {
    comments = await BlogApi.fetchComments(postId);
  } catch (_) {
    final res = await getCommentsByPostId(postId);
    if (res['code'] != 200 || res['data'] == null) {
      return _localCommentsByPostId[postId] ?? [];
    }
    comments = (res['data'] as List)
        .map((e) => _commentFromMap(e as Map<String, dynamic>))
        .toList();
  }
  final local = _localCommentsByPostId[postId] ?? [];
  return [...comments, ...local];
}

/// 每页文章数
const int kPageSize = 10;

/// 获取博客首页数据（支持分页，每页 [kPageSize] 条）
/// [page] 从 1 开始，从 JSONPlaceholder 获取
Future<Map<String, dynamic>> fetchHomeData({int page = 1}) async {
  try {
    final posts = await BlogApi.fetchPostsPage(page, kPageSize);
    final allForCategories = await BlogApi.fetchPostsPage(1, 100);
    final categories =
        allForCategories.map((p) => p.category).toSet().toList()..sort();
    final userData = await BlogApi.fetchUser('1');
    return {
      'user': {
        'id': userData['name'] != null ? '1' : 'u_1',
        'nickname': userData['name'] ?? userInfo['name'],
        'avatarUrl': userData['avatarUrl'] ?? userInfo['avatarUrl'],
        'subtitle': userData['subtitle'] ?? userInfo['subtitle'],
      },
      'posts': _applyOverlayToPosts(posts),
      'categories': categories.isNotEmpty
          ? categories
          : blogInfo['categories'] as List<String>,
      'page': page,
      'totalCount': 100,
      'hasNext': posts.length >= kPageSize,
    };
  } catch (_) {
    return {
      'user': {},
      'posts': <BlogPost>[],
      'categories': <String>[],
      'page': 1,
      'totalCount': 0,
      'hasNext': false,
    };
  }
}
