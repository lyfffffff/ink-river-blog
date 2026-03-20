# JSONPlaceholder API 映射说明

> 以下接口从 JSONPlaceholder 获取数据

---

## 一、接口与数据映射

### 1. 文章列表

| 项目 | 说明 |
|------|------|
| 接口 | `GET /posts` |
| 映射 | `id`→id, `title`→title, `body`→excerpt/content |
| 补全 | category=示例, date=2024, imageUrl=picsum, readMinutes=5, tags=[示例] |

### 2. 单篇文章（编辑用）

| 项目 | 说明 |
|------|------|
| 接口 | `GET /posts/{id}` |
| 映射 | 同文章列表 |
| 触发 | 文章管理 → 编辑文章 |

### 3. 文章评论

| 项目 | 说明 |
|------|------|
| 接口 | `GET /posts/{postId}/comments` |
| 映射 | `name`→authorName, `body`→content |
| 补全 | authorInitial=name[0], timeAgo=recently, likeCount=0 |

### 4. 用户信息

| 项目 | 说明 |
|------|------|
| 接口 | `GET /users/{userId}` |
| 映射 | `name`→name, `company.name`→subtitle, `email`→aboutSubtitle |
| 补全 | avatarUrl=pravatar.cc, introParagraphs/skills/timeline 不足时用 Mock |

---

## 二、保留 Mock 的接口

- **用户登录** `login`：无密码接口
- **修改密码** `changePassword`：无密码接口
- **保存文章** `saveArticle`：JSONPlaceholder 的 POST 不持久化
- **删除文章** `removeArticle`：同上

---

## 三、文件结构

```
lib/api/
├── api_config.dart   # 端点配置
├── api_client.dart   # HTTP 客户端
└── blog_api.dart     # 数据映射与请求
```

---

## 四、数据获取

`mock_api_data.dart` 中以下函数从 JSONPlaceholder 获取数据：

- `fetchPosts` / `fetchHomeData`
- `fetchProfile`
- `fetchComments`
- `editArticle`（通过 BlogService.getArticleForEdit）
