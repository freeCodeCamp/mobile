import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/widgets/error_retry.dart';

void main() {
  testWidgets('error card preserves the error and invokes its retry action', (
    tester,
  ) async {
    var retries = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: FccTheme.themeDark,
        home: Scaffold(
          body: ErrorRetry(
            message: 'Unable to search articles.',
            onRetry: () => retries++,
          ),
        ),
      ),
    );

    expect(find.byType(Card), findsOneWidget);
    final title = tester.widget<Text>(find.text('Unable to search articles.'));
    expect(title.style?.fontSize, 20);
    expect(title.style?.fontWeight, FontWeight.w900);
    final circle = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration! as BoxDecoration).shape == BoxShape.circle,
    );
    expect(tester.getSize(circle), const Size(72, 72));
    expect(find.text('Retry'), findsNothing);
    expect(find.text('Try again'), findsOneWidget);
    final button = find.byType(FilledButton);
    expect(tester.getSize(button).height, greaterThanOrEqualTo(44));
    final buttonSurface = tester.widget<Material>(
      find.descendant(of: button, matching: find.byType(Material)),
    );
    expect(buttonSurface.color, const Color(0xffffc83d));

    await tester.tap(button);
    expect(retries, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a state without a retry action does not offer an inert button', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FccTheme.themeDark,
        home: const Scaffold(
          body: ErrorRetry(message: 'No blocks available right now.'),
        ),
      ),
    );

    expect(find.text('No blocks available right now.'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final theme in [FccTheme.themeDark, FccTheme.themeLight]) {
    testWidgets(
      '${theme.brightness.name} error card fits 360dp at 1.3 text scale',
      (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1.3)),
              child: child!,
            ),
            home: Scaffold(
              body: ErrorRetry(
                message: 'Unable to load Code Radio.\nPlease try again.',
                onRetry: () {},
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        final cardRect = tester.getRect(find.byType(Card));
        expect(cardRect.left, greaterThanOrEqualTo(0));
        expect(cardRect.right, lessThanOrEqualTo(360));
        expect(find.byType(FilledButton).hitTestable(), findsOneWidget);
      },
    );
  }

  testWidgets('retry stays reachable when the available height is short', (
    tester,
  ) async {
    var retries = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: FccTheme.themeDark,
        home: Scaffold(
          body: SizedBox(
            height: 100,
            child: ErrorRetry(
              message: 'Unable to load more episodes.',
              onRetry: () => retries++,
            ),
          ),
        ),
      ),
    );

    await tester.ensureVisible(find.byType(FilledButton));
    await tester.tap(find.byType(FilledButton));
    expect(retries, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('error card supports the existing sliver and list parents', (
    tester,
  ) async {
    for (final content in [
      CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: ErrorRetry(
              message: 'Unable to load Code Radio.\nPlease try again.',
              onRetry: () {},
            ),
          ),
        ],
      ),
      ListView(
        children: [
          ErrorRetry(
            message: 'Unable to refresh your account.',
            onRetry: () {},
          ),
        ],
      ),
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: FccTheme.themeDark,
          home: Scaffold(body: content),
        ),
      );
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(FilledButton).hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
