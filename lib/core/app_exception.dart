/// 应用统一异常
///
/// 携带面向用户的友好消息，便于 UI 层直接展示。
/// 网络层/数据层抛出本异常，由 Controller 捕获后转为错误态。
library;

/// 应用异常
class AppException implements Exception {
  const AppException(this.message, {this.cause});

  /// 面向用户的友好消息
  final String message;

  /// 原始异常/原因（用于日志，不直接展示给用户）
  final Object? cause;

  @override
  String toString() => message;
}
