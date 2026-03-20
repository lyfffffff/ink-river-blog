# 墨色山河 - 个人博客应用

一款基于 Flutter 开发的个人博客应用，使用线上开源 API（https://jsonplaceholder.typicode.com） 作为数据源，提供文章浏览、搜索、分类、编辑、评论等完整功能。

---

## 功能特性

### 核心功能

| 功能 | 说明 |
|------|------|
| **首页** | 文章列表分页展示（每页 10 条），支持下拉刷新、翻页 |
| **分类** | 按分类筛选文章，默认选中第一个分类 |
| **搜索** | 关键词搜索（标题、摘要、内容、标签），默认显示第一页数据 |
| **关于** | 个人简介、技能、时间线展示 |
| **文章详情** | 富文本/纯文本展示，上一篇/下一篇导航（支持跨页加载） |
| **评论** | 评论列表分页、写评论弹窗、本地发布（会话内有效） |
| **分享** | 复制文章链接到剪贴板 |

### 管理功能（需登录）

| 功能 | 说明 |
|------|------|
| **登录态持久化** | 勾选「记住登录状态」后，应用重启仍保持登录；设置页根据登录态显示「登录」或「退出登录」 |
| **文章管理** | 查看、编辑、删除文章（需先登录） |
| **编辑文章** | 富文本编辑（加粗、斜体、列表、引用等），封面、分类、标签配置 |
| **设置** | 深色模式、字体大小、消息免打扰、修改密码、隐私政策 |

### 数据与配置

- **数据源**：使用 JSONPlaceholder 线上 API，获取博客、评论、用户数据
- **本地 Overlay**：编辑保存、删除、发布评论在会话内生效，刷新后恢复线上数据
- **主题**：支持浅色/深色模式，思源黑体字体

---

## 技术栈

| 技术 | 用途 |
|------|------|
| Flutter 3.x | 跨平台 UI 框架 |
| Dart 3.11+ | 开发语言 |
| flutter_quill | 富文本编辑与展示 |
| http | 网络请求 |
| shared_preferences | 本地持久化（主题、字体、设置） |

---

## 项目结构

```
lib/
├── main.dart                 # 应用入口
├── app.dart                  # 根 Widget、主题配置
├── api/
│   ├── api_config.dart       # API 配置（baseUrl）
│   ├── api_client.dart       # HTTP 客户端封装
│   └── blog_api.dart         # 博客 API（JSONPlaceholder 映射）
├── components/               # 通用组件
│   ├── app-bar.dart
│   ├── article_card.dart
│   ├── article_action_sheet.dart
│   └── ...
├── constants/
│   ├── app_constants.dart    # 应用常量（品牌名等）
│   └── color.dart            # 主题色
├── core/
│   └── app_typography.dart   # 排版样式
├── data/
│   ├── mock_data.dart        # 静态 Mock 数据（分类、标签等）
│   └── mock_api_data.dart   # Mock API、数据获取、本地 overlay
├── models/
│   ├── blog_post.dart        # 文章模型
│   └── comment.dart         # 评论模型
├── screens/                  # 页面
│   ├── main_shell.dart       # 底部导航壳
│   ├── home_screen.dart      # 首页
│   ├── category_screen.dart # 分类页
│   ├── search_screen.dart   # 搜索页
│   ├── about_screen.dart    # 关于页
│   ├── article_detail_screen.dart  # 文章详情
│   ├── article_edit_screen.dart    # 文章编辑
│   ├── article_management_screen.dart  # 文章管理
│   ├── setting_screen.dart  # 设置页
│   ├── login_screen.dart    # 登录
│   └── ...
├── services/
│   ├── auth_service.dart     # 登录态管理（持久化）
│   └── blog_service.dart     # 文章服务（edit/save/remove）
└── theme/
    ├── app_theme.dart        # 主题管理
    └── app_settings.dart     # 设置管理（字体、免打扰）
```

---

## 快速开始

### 环境要求

- Flutter SDK ^3.11.1
- Dart ^3.11.1

### 安装依赖

```bash
flutter pub get
```

### 运行应用

```bash
# Web（Chrome）
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios
```

### 修改 API 地址

```dart
static String baseUrl = 'https://jsonplaceholder.typicode.com';
```

---

## API 说明

### 线上模式（JSONPlaceholder）

| 接口 | 说明 |
|------|------|
| `GET /posts?_page=&_limit=` | 文章列表分页 |
| `GET /posts/{id}` | 单篇文章 |
| `GET /posts/{postId}/comments` | 文章评论 |
| `GET /users/{userId}` | 用户信息 |

JSONPlaceholder 返回格式与内部模型不同，`blog_api.dart` 已做映射（如 `body` → `content`，随机分配分类和标签）。

### Mock 模式

- 编辑、保存、删除、评论等通过 `mock_api_data.dart` 模拟
- 登录：`admin` / `123456`
- 本地 overlay 仅会话有效，不持久化

---

## 配置说明

### 字体

项目使用思源黑体，字体文件位于 `fonts/`：

- `SourceHanSansSC-Regular.otf`
- `SourceHanSansSC-Bold.otf`

### 主题色

在 `lib/constants/color.dart` 中定义 `AppColors.primary` 等。

---

## 开发说明

### 文章详情上一篇/下一篇

- 从首页进入时传入 `page`、`hasNext`、`totalCount`，支持跨页加载
- 从分类、搜索、文章管理进入时基于当前列表，不跨页

### 富文本（flutter_quill）

- Document 最后一个节点必须以 `\n` 结尾
- 已对 API 返回内容做 `_normalizeDeltaForQuill` 处理，避免断言失败

### 分页

- 首页：`kPageSize = 10`，`fetchHomeData(page)` 获取分页数据
- 搜索页：默认显示第一页
- 分类页：展示完整分类列表，无分页

---
