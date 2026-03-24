# 墨色山河 - 改进方案文档（阶段一）

> 目标：把我们已讨论的问题与改进方案沉淀为可执行文档。
> 范围：数据结构层、状态管理、路由权限为“完整闭环方案”（痛点 → 方案 → 落地）。
> 其他问题先进入待办池，后续再优化。

---

## 一、当前结论与前置假设

- **数据结构层**：采用 **Isar**（本地数据库，作为 Local-first 数据源）。
- **状态管理**：采用 **flutter_riverpod**。
- **路由与权限**：建立 Guest / User / Owner 权限模型，GoRouter 统一守卫。
- **数据源现状**：远端为 JSONPlaceholder（只读），写操作通过本地 overlay 实现。

---

## 二、数据结构层（Isar）

### 1. 痛点

- 目前写操作仅 **会话级内存**，应用重启即失效。
- `mock_api_data` 混合了“数据获取 + 业务逻辑 + 本地覆盖”，职责过重。
- 缺少统一的本地缓存与合并策略，导致数据一致性不可控。

### 2. 解决方案

**Local-first + 可持久化 + 可合并**

- 远端 API 只负责 **只读拉取**。
- 所有写操作统一落 **本地 Isar**。
- 使用 **变更日志/补丁表** 记录编辑、删除、评论等操作，保证可回放与合并。
- Repository 负责合并策略（本地优先、删除覆盖等）。

### 3. 落地方案（MVP）

**数据分层结构**

- `RemoteDataSource`：仅负责 JSONPlaceholder 拉取。
- `LocalDataSource`：仅负责 Isar 读写。
- `Repository`：负责合并策略、缓存策略、错误兜底。

**建议的数据表（Isar）**

- `PostEntity`（文章）
- `CommentEntity`（评论）
- `FavoriteEntity`（收藏）
- `UserEntity`（用户/作者）
- `LocalChangeEntity`（本地变更记录：create/update/delete）

**合并策略（优先级）**

1. 本地删除优先于远端数据
2. 本地编辑覆盖远端字段
3. 本地新建插入列表顶部
4. 本地评论追加到评论列表末尾

**实施步骤（可执行）**

1. 引入 Isar 并建立实体模型
2. 将当前 `mock_api_data` 拆分为 Remote/Local
3. Repository 统一读写（先 Local，后 Remote 刷新）
4. 将“编辑/删除/评论/收藏”改为本地持久化
5. 添加首次同步逻辑：启动时拉远端并写入 Isar

**验收标准**

- 应用重启后，编辑/删除/评论/收藏仍保留
- 断网时仍能打开首页与文章详情
- 数据刷新后本地修改不丢失

---

## 三、状态管理（Riverpod）

### 1. 痛点

- 状态分散在页面内部，`setState + FutureBuilder` 难复用
- 加载/错误/空状态不统一
- 跨页面共享数据需重复加载或手动传参

### 2. 解决方案

**Riverpod + Controller 分治**

- 每个功能模块建立 `Controller/State`
- 统一使用 `AsyncValue` 处理 loading/error/success
- UI 只订阅状态、触发事件

### 3. 落地方案（MVP）

**建议的 Controller 拆分**

- `HomeController`：分页、刷新
- `SearchController`：关键词、搜索结果
- `CategoryController`：分类列表与筛选结果
- `ArticleDetailController`：详情、评论、收藏
- `AuthController`：登录态
- `FavoritesController`：收藏
- `SettingsController`：主题/字体/免打扰

**状态结构示例（约定）**

- `HomeState`：`items/page/hasNext/isRefreshing/error`
- `SearchState`：`keyword/results/loading/error`
- `ArticleDetailState`：`post/comments/isFav/loading/error`

**实施步骤（可执行）**

1. 引入 Riverpod 基础依赖
2. 从 HomeScreen 试点迁移（最小改动）
3. 迁移 ArticleDetail（评论+收藏）
4. 统一全局状态（Auth/Theme/Settings）
5. 删除页面内过多 `setState`

**验收标准**

- UI 逻辑简化，页面仅负责渲染
- 所有加载/错误/空态统一展示
- 跨页面共享数据不再重复拉取

---

## 四、路由与权限

### 1. 痛点

- 路由守卫仅对 `/` 生效
- 管理/编辑页面可被直接访问
- 文章详情依赖 `extra`，深链失败
- 登录后无法回跳目标页面

### 2. 解决方案

**权限模型：Guest / User / Owner**

- Guest：只浏览、搜索
- User：可收藏、评论
- Owner：可管理/编辑/删除自己的文章

**路由守卫集中化（GoRouter）**

- 对管理类路由统一拦截
- 登录后自动回跳

### 3. 落地方案（MVP）

**受保护路由清单**

- `/article-management`
- `/article/:id/edit`

**动作权限校验（业务层）**

- 收藏、评论、删除等操作在 Service/Repository 层二次校验
- 文章模型增加 `authorId`，校验 `post.authorId == userId`

**深链支持**

- `/article/:id` 在无 `extra` 时，通过 id 拉取详情

**验收标准**

- 未登录无法访问管理/编辑
- 登录后回跳目标页面
- 文章详情支持分享/深链

---

## 五、待办问题池（后续优化）

> 这些模块先列入待办，不作为当前阶段重点

1. **错误处理与稳定性**
   - 统一错误模型、网络重试、弱网兜底
2. **性能与体验**
   - 图片缓存、离线体验、列表性能优化
3. **测试与工程规范**
   - 单元/Widget/集成测试、Lint 规则、CI
4. **整体架构分层**
   - Domain 层完善、DTO/Model 分离、统一 Result 类型

---

## 六、实施优先级（建议顺序）

1. 数据结构层（Isar + Repository 重构）
2. 状态管理（Riverpod 迁移）
3. 路由与权限（统一守卫 + 权限矩阵）
4. 待办问题池逐步推进

---

**文档更新策略**

- 每完成一个模块，补充“落地结果 + 对应代码路径 + 风险/下一步”。

