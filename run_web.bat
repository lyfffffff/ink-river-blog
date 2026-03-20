@echo off
REM 使用 HTML 渲染器运行，避免加载 CanvasKit 和 Google 字体（解决网络受限问题）
flutter run -d chrome --web-renderer=html
