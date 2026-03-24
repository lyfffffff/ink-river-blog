# 测试与工程规范计划（草案）

## 目标
- 建立可持续的测试与规范
- 降低回归风险与协作成本

## 当前问题
- 缺少单元/组件/集成测试
- 代码规范与结构缺少约束

## 改进方案
- 基础单元测试覆盖核心逻辑
- 关键页面 Widget 测试
- CI 中加入 lint + test

## 落地步骤
1. 增加 lint 规则与格式化约定
2. 建立基础单元测试（Repository/Permission）
3. 为 Home/Detail 添加 Widget 测试
4. 配置 CI（GitHub Actions）
