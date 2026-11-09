import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safetyquest_mobile/features/home/home_shell.dart';
import 'widget_test.dart' show FakeApi;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets(
    'random alert appears once and can be dismissed without a score',
    (tester) async {
      final api = FakeApi()..empty = true;
      addTearDown(api.dispose);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          ),
          home: HomeShell(api: api, onSignedOut: () async {}),
        ),
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(minutes: 5));
      await tester.pumpAndSettle();
      expect(find.text('Practice emergency alert'), findsOneWidget);
      expect(find.textContaining('SIMULATION ONLY'), findsOneWidget);
      await tester.tap(find.text('Later'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(minutes: 6));
      expect(find.text('Practice emergency alert'), findsNothing);
      expect(api.calls, ['state']);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('alert waits while another page is open', (tester) async {
    final api = FakeApi()..empty = true;
    addTearDown(api.dispose);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: child!,
        ),
        navigatorKey: nav,
        home: HomeShell(api: api, onSignedOut: () async {}),
      ),
    );
    await tester.pumpAndSettle();
    nav.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('Lesson in progress')),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(minutes: 5));
    expect(find.text('Practice emergency alert'), findsNothing);
    nav.currentState!.pop();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(minutes: 5));
    await tester.pumpAndSettle();
    expect(find.text('Practice emergency alert'), findsOneWidget);
    await tester.tap(find.text('Start drill'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Practice emergency drill'), findsOneWidget);
    expect(api.calls, ['state']);
    await tester.pumpWidget(const SizedBox());
  });
}
