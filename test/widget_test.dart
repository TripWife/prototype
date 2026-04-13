import 'package:flutter_test/flutter_test.dart';
import 'package:tripwife/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const TripWifeApp());
  });
}
