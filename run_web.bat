@echo off
REM 以 Web 模式运行（Chrome）。
REM Flutter 3.10+ 已移除 HTML 渲染器，使用默认 CanvasKit/Skwasm 渲染器。
REM 网络受限环境请设置环境变量 FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
flutter run -d chrome
