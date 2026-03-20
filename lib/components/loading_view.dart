/// 统一加载态
library;

import 'package:flutter/material.dart';

/// 全屏加载
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
