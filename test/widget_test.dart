import 'package:flutter_test/flutter_test.dart';
import 'package:ilaalo_engine/main.dart';

void main() {
  testWidgets('Ilaalo Engine app loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const IlaaloEngineApp());

    expect(find.text('Ilaalo Engine VIP'), findsOneWidget);
    expect(find.text('10 Maalmood Free Trial'), findsOneWidget);
    expect(find.text('\$10 / Bishiiba'), findsOneWidget);
  });
}
