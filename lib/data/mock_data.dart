/// Mock 数据
///
/// 聚合管理：用户信息(userInfo)、博客信息(blogInfo)
library;

import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

// ============================================================
// 用户信息 userInfo
// ============================================================

const String _userName = appName;
const String _userSubtitle = '生活记录者，技术探索者';
const String _userQuote = '"行到水穷处，坐看云起时"';
const String _userAboutSubtitle = '生活记录员 / 技术探索者 / 摄影爱好者';
const String _userAvatarUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBq-eq6gefg_3lWtmkNidS11pMhp0vYUbxA-OUAiqV3FwTRTIG2BCthnhI6ZjCkeNwOvvKi_yFoaPFrnj73Q7lj5k7Q9VGaE0FIKDjg3VyfiGMyKN1jdcLtDMvNSNh7O6_k94TG-cFpEgnOCtlppNOvxfnG65VH3-jAd0P7gUJ46i673SowNVv8XSiRtHATIF36XFJA88emGFIOrLpIgb-aFFWvLV2VFx1Ys3x6wiaa-Aaa7o5TeIAL1VMm1ob2oseOvsE8JB0J0reC';
const String _userAboutAvatarUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuDvYztcoWLQ_hLutCQcq30ov949jbX8G6DjBcQVt4VT5dvN3drPGaNoq45DPi7Pj_bTjkqMFMMzKgH-9X18hCImyR2kM2DbsNEFe4-0SkyXCtbnI59NfMm6FIVUC-zdKFYaKuZydH4osS5o_OKYv9XM2VE4GjitI1niDS-H2Jk0M28NEasJa8lWpmjym9FmASN1z36fdP7ocXhM8IRa14CGJg0O_ZCbGU4yMBJMPBlxNu7whTcQ4nm6Du9iu2WpIORQ4tNy-M8ONvnP';

const List<String> _userIntroParagraphs = [
  '你好，我是墨色山河。一名穿梭于代码与光影之间的记录者。',
  '作为一名『生活记录员』，我喜欢捕捉城市角落里那些稍纵即逝的诗意瞬间；作为一名『技术探索者』，我热衷于用极简的代码勾勒复杂的数字世界。我始终相信，优秀的设计与纯粹的技术应当如同中国水墨画一般，既有留白的艺术，又有深邃的内涵。',
  '在这里，我分享对前沿技术的思考，也记录生活中的平凡与不凡。欢迎来到我的精神家园。',
];

const List<Map<String, dynamic>> _userSkills = [
  {'icon': Icons.camera_enhance_rounded, 'label': '摄影记录'},
  {'icon': Icons.terminal_rounded, 'label': '全栈开发'},
  {'icon': Icons.palette_rounded, 'label': 'UI 设计'},
  {'icon': Icons.auto_stories_rounded, 'label': '哲学思考'},
];

const List<Map<String, dynamic>> _userTimeline = [
  {
    'period': '2023 - 至今',
    'title': '创立"墨色山河"个人品牌',
    'desc': '开始系统性地输出技术博文与摄影作品，探索极简主义数字美学。',
    'isPrimary': true,
  },
  {
    'period': '2020 - 2022',
    'title': '高级前端工程师',
    'desc': '深耕 UI 组件库与前端工程化，参与多个大型项目。',
    'isPrimary': false,
  },
  {
    'period': '2018',
    'title': '第一台相机与第一行代码',
    'desc': '开启了对世界不同的观察视角，决定投身于创造性的数字领域。',
    'isPrimary': false,
  },
];

/// 用户信息（聚合）
const Map<String, dynamic> userInfo = {
  'username': 'admin',
  'password': '123456',
  'name': _userName,
  'subtitle': _userSubtitle,
  'quote': _userQuote,
  'aboutSubtitle': _userAboutSubtitle,
  'avatarUrl': _userAvatarUrl,
  'aboutAvatarUrl': _userAboutAvatarUrl,
  'introParagraphs': _userIntroParagraphs,
  'skills': _userSkills,
  'timeline': _userTimeline,
};

// ============================================================
// 博客信息 blogInfo
// ============================================================
// 文章、评论统一使用线上 API，由 mock_api_data 提供空列表

/// 固定分类列表（用于线上数据随机分配，支持分类筛选）
const List<String> categoryList = [
  '生活',
  '技术',
  '摄影',
  '随笔',
  '读书',
  '旅行',
];

/// 固定标签列表（用于线上数据随机分配 1-3 个标签）
const List<String> tagsList = [
  '生活',
  '技术',
  '摄影',
  '随笔',
  '读书',
  '旅行',
  '极简主义',
  '生产力',
  '审美',
  '传统文化',
  'UI设计',
];

/// 分类 fallback（API 返回空时使用，与 categoryList 一致）
const List<String> _fallbackCategories = categoryList;

/// 博客信息（聚合）
final Map<String, dynamic> blogInfo = {
  'categories': _fallbackCategories,
};
