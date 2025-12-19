import 'package:flutter_test/flutter_test.dart';
import 'package:remote_mouse/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const RemoteMouseApp());

    // Verify that the app title is displayed
    expect(find.text('Remote Mouse'), findsOneWidget);

    // Verify that the connect button exists
    expect(find.text('Connect'), findsOneWidget);

    // Verify that the scan button exists
    expect(find.text('Scan'), findsOneWidget);
  });
}
