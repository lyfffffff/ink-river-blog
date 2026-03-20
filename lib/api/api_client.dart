/// HTTP 客户端封装
///
/// 统一处理 GET/POST、超时、错误、JSON 解析
library;

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

/// API 响应结构（与 mock 保持一致）
typedef ApiResponse = Map<String, dynamic>;

/// HTTP 客户端
class ApiClient {
  ApiClient._();

  static final ApiClient _instance = ApiClient._();
  static ApiClient get instance => _instance;

  final _client = http.Client();
  static const _timeout = Duration(seconds: 10);

  /// GET 请求
  /// [path] 完整 URL 或相对路径
  /// 返回 { code, msg, data } 或抛出异常
  Future<ApiResponse> get(String path) async {
    final uri = path.startsWith('http') ? Uri.parse(path) : Uri.parse('${ApiConfig.baseUrl}$path');
    try {
      final response = await _client.get(uri).timeout(_timeout);
      return _parseResponse(response);
    } catch (e) {
      return {
        'code': -1,
        'msg': '网络请求失败: $e',
        'data': null,
      };
    }
  }

  /// POST 请求
  Future<ApiResponse> post(String path, {Map<String, dynamic>? body}) async {
    final uri = path.startsWith('http') ? Uri.parse(path) : Uri.parse('${ApiConfig.baseUrl}$path');
    try {
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      return _parseResponse(response);
    } catch (e) {
      return {
        'code': -1,
        'msg': '网络请求失败: $e',
        'data': null,
      };
    }
  }

  /// 解析 HTTP 响应为统一格式
  ApiResponse _parseResponse(http.Response response) {
    final body = response.body;
    if (body.isEmpty) {
      return {
        'code': response.statusCode,
        'msg': '响应为空',
        'data': null,
      };
    }
    try {
      final json = jsonDecode(body);
      if (json is Map<String, dynamic>) {
        if (json.containsKey('code')) {
          return json;
        }
        return {
          'code': response.statusCode >= 200 && response.statusCode < 300 ? 200 : response.statusCode,
          'msg': json['msg'] ?? (response.statusCode == 200 ? '成功' : '请求失败'),
          'data': json['data'] ?? json,
        };
      }
      if (json is List) {
        return {
          'code': response.statusCode >= 200 && response.statusCode < 300 ? 200 : response.statusCode,
          'msg': '成功',
          'data': json,
        };
      }
      return {'code': 200, 'msg': '成功', 'data': json};
    } catch (e) {
      return {
        'code': -2,
        'msg': '解析失败: $e',
        'data': null,
      };
    }
  }
}
