import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safetyquest_mobile/features/home/emergency_call_card.dart';

void main() {
  testWidgets('emergency button opens tel:911 only after confirming', (
    tester,
  ) async {
    final calls = <Uri>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmergencyCallCard(
            openDialer: (uri) async {
              calls.add(uri);
              return true;
            },
          ),
        ),
      ),
    );
    await tester.tap(find.text('Emergency — Call 911'));
    await tester.pumpAndSettle();
    expect(calls, isEmpty);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(calls, isEmpty);
    await tester.tap(find.text('Emergency — Call 911'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open phone — 911'));
    await tester.pumpAndSettle();
    expect(calls.map((uri) => uri.toString()), ['tel:911']);
  });

  testWidgets('phone app failure leaves the number available', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: EmergencyCallCard(openDialer: (_) async => false)),
      ),
    );
    await tester.tap(find.text('Emergency — Call 911'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open phone — 911'));
    await tester.pumpAndSettle();
    expect(
      find.text('Could not open the phone app. Dial 911 on your phone.'),
      findsOneWidget,
    );
  });
}
