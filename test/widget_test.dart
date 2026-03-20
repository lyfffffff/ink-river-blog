import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/app.dart';

void main() {
  testWidgets('墨色山河 app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('墨色山河'), findsWidgets);
    expect(find.text('最新文章'), findsOneWidget);
    expect(find.text('首页'), findsOneWidget);
  });
}
