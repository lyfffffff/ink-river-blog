# 架构分层完善计划（草案）

## 目标
- 明确分层边界（UI/State/Domain/Data）
- 降低耦合，提高可维护性

## 当前问题
- 页面逻辑与数据逻辑混杂
- DTO/Domain/Entity 未分层

## 改进方案
- 引入 Domain 层（业务规则与用例）
- 区分 DTO / Entity / Domain Model
- Repository 统一数据入口

## 落地步骤
1. 建立 domain/ 目录与用例结构
2. 拆分 BlogPost 为 DTO + Domain
3. 在 Repository 层完成转换
4. UI 仅依赖 Domain 模型
