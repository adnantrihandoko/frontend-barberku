import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barberku_app/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BarberKuApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('BarberKu'), findsOneWidget);
  });
}
