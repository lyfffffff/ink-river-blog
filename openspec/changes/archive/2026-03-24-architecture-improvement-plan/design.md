## Context

当前 Flutter 博客应用以 JSONPlaceholder 为只读数据源，写操作通过会话级内存 overlay 实现；状态主要由页面内 `setState/FutureBuilder` 管理；路由权限只在 UI 层零散判断。目标是形成可执行的架构改进方案：本地持久化数据层、统一全局状态管理、集中路由与权限控制。

前置假设：
- 远端数据源仅用于只读拉取（无真实写接口）
- 写操作通过本地持久化实现（Local-first）
- 不引入复杂后端或账户系统

## Goals / Non-Goals

**Goals:**
- 建立 Local-first 数据架构（Isar + RemoteDataSource + Repository 合并策略）。
- 建立 Riverpod 统一状态管理方案与 Controller 组织方式。
- 建立 Guest/User/Owner 权限模型与 GoRouter 守卫策略。
- 形成“痛点 → 方案 → 落地”的可执行文档。

**Non-Goals:**
- 不实施具体代码改动（本次仅文档与方案）。
- 不引入复杂后端或真实账户系统。
- 不完成错误处理、性能、测试等后续优化（仅入待办）。

## Decisions

1. **数据层采用 Isar（Local-first）**
   - 选择理由：比 Hive 更适合搜索/分类等查询；比 Drift 更轻量，学习成本更低。
   - 备选方案：Hive（更简单但查询弱）、Drift（更强但成本高）。

2. **状态管理采用 flutter_riverpod**
   - 选择理由：类型安全、可组合、易测试、适合全局状态与业务 Controller。
   - 备选方案：Provider/BLoC；继续用 setState（仅适合局部状态）。

3. **权限模型采用 Guest/User/Owner**
   - 选择理由：满足“游客浏览、登录评论收藏、作者管理自己文章”的最小权限需求。
   - 备选方案：更复杂角色系统（管理员/编辑等）暂不引入。

4. **路由守卫集中在 GoRouter**
   - 选择理由：防止通过深链访问管理/编辑页面；统一权限处理。

## Risks / Trade-offs

- **引入 Isar 增加依赖与迁移成本** → Mitigation：分阶段替换，先做本地持久化与读取，后做合并策略。
- **状态管理迁移工作量大** → Mitigation：从 Home/ArticleDetail 试点，逐步替换。
- **权限模型需要补充 authorId 数据** → Mitigation：本地 overlay 补齐字段，远端拉取后默认映射。

## Migration Plan

实施优先级：
1. 数据结构层（Isar + Repository 重构）
2. 状态管理（Riverpod 迁移）
3. 路由与权限（统一守卫 + 权限矩阵）
4. 待办问题池逐步推进

执行步骤：
1. 输出完整方案文档（本次变更目标）。
2. 数据层重构：引入 Isar，拆分 DataSource/Repository。
3. 状态管理迁移：Riverpod Controller 试点（Home → Detail → 其他）。
4. 路由权限落地：GoRouter 守卫 + 业务层权限校验。

文档更新策略：
- 每完成一个模块，补充“落地结果 + 对应代码路径 + 风险/下一步”。

## Open Questions

- Isar 的具体表结构与索引策略如何设计？
- 文章 authorId 的生成与映射规则是否需产品确认？
- 是否需要在文档中加入数据同步/冲突处理的详细流程图？
