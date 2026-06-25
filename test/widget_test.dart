import 'package:flutter_test/flutter_test.dart';
import 'package:bargenie/main.dart';

void main() {
  testWidgets('BarGenie app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BarGenieApp());
    expect(find.text('BarGenie'), findsWidgets);
  });
}
