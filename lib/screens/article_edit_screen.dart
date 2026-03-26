/// 文章编辑页
///
/// 1:1 复刻 stitch 设计，支持 /edit 获取、/save 保存
/// 使用 flutter_quill 实现富文本编辑（加粗、斜体等）
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../constants/color.dart';
import '../core/app_typography.dart';
import '../repositories/blog_repository.dart';
import '../models/blog_post.dart';
import '../services/blog_service.dart';
import '../services/permission_service.dart';
import '../utils/toast_util.dart';
import '../routes/app_router.dart';
import '../controllers/home_controller.dart';

/// 从字符串创建 Quill Document（支持 Delta JSON 或纯文本）
/// flutter_quill 要求 Document 最后一个节点必须以 \n 结尾
Document _documentFromContent(String content) {
  final trimmed = content.trim();
  if (trimmed.startsWith('[')) {
    try {
      final list = jsonDecode(trimmed) as List;
      final normalized = _normalizeDeltaForQuill(list);
      return Document.fromJson(normalized);
    } catch (_) {
      // 解析失败则按纯文本处理
    }
  }
  final plain = content.isEmpty ? '\n' : (content.endsWith('\n') ? content : content + '\n');
  return Document.fromJson([{'insert': plain}]);
}

/// 确保 Delta 最后一个 insert 以 \n 结尾（满足 flutter_quill 要求）
List<Map<String, dynamic>> _normalizeDeltaForQuill(List<dynamic> ops) {
  if (ops.isEmpty) return [{'insert': '\n'}];
  final list = ops.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  final last = list.last;
  final insert = last['insert'];
  if (insert is String) {
    if (!insert.endsWith('\n')) {
      list[list.length - 1] = {...last, 'insert': insert + '\n'};
    }
  } else {
    list.add({'insert': '\n'});
  }
  return list;
}

/// 将 Quill Document 转为存储字符串（Delta JSON）
String _contentFromDocument(Document doc) {
  final delta = doc.toDelta().toJson();
  return jsonEncode(delta);
}

class ArticleEditScreen extends StatefulWidget {
  const ArticleEditScreen({
    super.key,
    required this.postId,
    this.isNew = false,
    this.initialPost,
  });

  final String postId;
  final bool isNew;
  final BlogPost? initialPost;

  @override
  State<ArticleEditScreen> createState() => _ArticleEditScreenState();
}

class _ArticleEditScreenState extends State<ArticleEditScreen> {
  late Future<BlogPost?> _postFuture;

  @override
  void initState() {
    super.initState();
    if (widget.isNew) {
      final authorId = PermissionService.currentUserId() ?? '';
      _postFuture = Future.value(
        widget.initialPost ??
            BlogPost(
              id: 'new',
              authorId: authorId,
              title: '',
              excerpt: '',
              category: '未分类',
              date: '',
              imageUrl: '',
              content: '',
              readMinutes: 5,
              tags: const [],
            ),
      );
    } else {
      _postFuture = BlogService.getArticleForEdit(widget.postId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder<BlogPost?>(
        future: _postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '加载失败',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('返回'),
                  ),
                ],
              ),
            );
          }
          final post = snapshot.data!;
          return _ArticleEditForm(post: post, postId: widget.postId);
        },
      ),
    );
  }
}

class _ArticleEditForm extends StatefulWidget {
  const _ArticleEditForm({required this.post, required this.postId});

  final BlogPost post;
  final String postId;

  @override
  State<_ArticleEditForm> createState() => _ArticleEditFormState();
}

class _ArticleEditFormState extends State<_ArticleEditForm> {
  late final TextEditingController _titleController;
  late final QuillController _quillController;
  late final TextEditingController _excerptController;
  late String _category;
  late List<String> _tags;
  late String _imageUrl;
  late Future<List<String>> _categoriesFuture;
  bool _saving = false;
  String? _createdPostId;

  void _refreshHome() {
    final container = ProviderScope.containerOf(context, listen: false);
    container.read(homeControllerProvider.notifier).refresh();
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _quillController = QuillController(
      document: _documentFromContent(widget.post.content),
      selection: const TextSelection.collapsed(offset: 0),
    );
    _excerptController = TextEditingController(text: widget.post.excerpt);
    _category = widget.post.category;
    _tags = List.from(widget.post.tags);
    _imageUrl = widget.post.imageUrl;
    _categoriesFuture = BlogRepository.instance.getCategoriesWithPosts();
  }

  Future<void> _save({bool publish = false}) async {
    if (_saving) return;
    setState(() => _saving = true);
    final contentStr = _contentFromDocument(_quillController.document);
    final authorId =
        PermissionService.currentUserId() ?? widget.post.authorId;
    final payload = {
      'title': _titleController.text.trim(),
      'content': contentStr,
      'excerpt': _excerptController.text.trim(),
      'category': _category,
      'tags': _tags,
      'imageUrl': _imageUrl.isNotEmpty ? _imageUrl : null,
      'authorId': authorId,
    };
    if (widget.post.id == 'new') {
      if (_createdPostId == null) {
        final newId = await BlogService.createArticle(payload);
        if (newId == null) {
          if (mounted) setState(() => _saving = false);
          if (mounted) showTopError(context, '发布失败');
          return;
        }
        _createdPostId = newId;
        if (!mounted) return;
        setState(() => _saving = false);
        final created = BlogPost(
          id: newId,
          authorId: authorId,
          title: _titleController.text.trim(),
          excerpt: _excerptController.text.trim(),
          category: _category,
          date: DateTime.now().year.toString(),
          imageUrl: _imageUrl.isNotEmpty
              ? _imageUrl
              : 'https://via.placeholder.com/400x225',
          content: contentStr,
          readMinutes: 5,
          tags: _tags,
        );
        if (publish) {
          showTopMessage(context, '已发布');
          _refreshHome();
          context.go(AppRoutes.main);
        } else {
          showTopMessage(context, '已保存草稿');
          context.pop(true);
        }
        return;
      }
      final ok = await BlogService.saveArticle(_createdPostId!, payload);
      if (mounted) setState(() => _saving = false);
      if (!mounted) return;
      if (ok) {
        if (publish) {
          showTopMessage(context, '已发布');
          _refreshHome();
          context.go(AppRoutes.main);
        } else {
          showTopMessage(context, '已保存草稿');
        }
      } else {
        showTopError(context, '保存失败');
      }
      return;
    }
    final ok = await BlogService.saveArticle(widget.postId, payload);
    setState(() => _saving = false);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(publish ? '已发布' : '已保存草稿')),
      );
      if (publish) context.pop(true);
    } else {
      showTopError(context, '保存失败');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    _excerptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleInput(),
                const SizedBox(height: 24),
                _buildToolbar(),
                const SizedBox(height: 16),
                _buildEditorArea(),
                const SizedBox(height: 24),
                _buildSidebar(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliverAppBar(
      pinned: true,
      backgroundColor: colorScheme.surface.withValues(alpha: 0.95),
      leading: IconButton(
        icon: const Icon(Icons.close_rounded),
        onPressed: () => Navigator.pop(context),
        color: colorScheme.onSurface,
      ),
      title: Row(
        children: [
          Text(
            '$appName / ',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            widget.post.id.isEmpty || widget.post.id == 'new'
                ? '新建文章'
                : '编辑文章',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text(
            '预览',
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
          ),
        ),
        TextButton(
          onPressed: _saving ? null : () => _save(publish: false),
          child: Text(
            '保存草稿',
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: FilledButton(
            onPressed: _saving ? null : () => _save(publish: true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            child: const Text('发布', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleInput() {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: _titleController,
      style: AppTypography.displayMedium(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: '请输入文章标题',
        hintStyle: TextStyle(color: colorScheme.outline),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildToolbar() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: QuillSimpleToolbar(
        controller: _quillController,
        config: QuillSimpleToolbarConfig(
          showFontFamily: false,
          showFontSize: false,
          showBoldButton: true,
          showItalicButton: true,
          showUnderLineButton: true,
          showStrikeThrough: true,
          showListBullets: true,
          showListNumbers: true,
          showQuote: true,
          showCodeBlock: true,
          showLink: true,
          showUndo: true,
          showRedo: true,
          color: colorScheme.surface,
        ),
      ),
    );
  }

  Widget _buildEditorArea() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(minHeight: 400),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: const Icon(Icons.person, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                '在这笔墨间，书写你的山河...',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          QuillEditor.basic(
            controller: _quillController,
            config: QuillEditorConfig(
              placeholder: '点击这里开始创作...',
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCoverSection(),
        const SizedBox(height: 16),
        _buildCategorySection(),
        const SizedBox(height: 16),
        _buildTagsSection(),
      ],
    );
  }

  Widget _buildCoverSection() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.image_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '文章封面',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              if (_imageUrl.isEmpty) {
                setState(() => _imageUrl = 'https://via.placeholder.com/400x225');
              }
            },
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
              child: _imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(_imageUrl, fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 40,
                          color: colorScheme.outline,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '点击上传图片',
                          style: TextStyle(fontSize: 12, color: colorScheme.outline),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.folder_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '分类',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<String>>(
            future: _categoriesFuture,
            builder: (context, catSnap) {
              final cats = catSnap.data ?? [];
              final options = cats.contains(_category)
                  ? cats
                  : [_category, ...cats];
              return DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                ),
                items: options
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v ?? _category),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.label_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '标签',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._tags.map(
                (t) => Chip(
                  label: Text(t),
                  deleteIcon: const Icon(Icons.close, size: 14),
                  onDeleted: () => setState(() => _tags.remove(t)),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
