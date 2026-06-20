import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/main.dart';

void main() {
  testWidgets('MedLink app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MedLinkApp());
    await tester.pumpAndSettle();
    // Splash screen should show app name
    expect(find.text('MedLink'), findsOneWidget);
  });
}
