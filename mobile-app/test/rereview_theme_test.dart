import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/chip_surface.dart';
import 'package:freecodecamp/widgets/dialog/confirm_dialog.dart';
import 'package:freecodecamp/widgets/error_retry.dart';
import 'package:freecodecamp/widgets/fcc_switch.dart';
import 'package:freecodecamp/widgets/html_handler/code_block.dart';
import 'package:freecodecamp/widgets/segmented_tabs.dart';

import 'rereview_learn_fonts.dart';

Future<void> pump(
  WidgetTester tester,
  Widget child, {
  bool dark = true,
  double scale = 1,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: Scaffold(body: child),
    ),
  );
  await tester.pump();
}

List<TextStyle?> allStyles(TextTheme theme) => [
  theme.displayLarge,
  theme.displayMedium,
  theme.displaySmall,
  theme.headlineLarge,
  theme.headlineMedium,
  theme.headlineSmall,
  theme.titleLarge,
  theme.titleMedium,
  theme.titleSmall,
  theme.bodyLarge,
  theme.bodyMedium,
  theme.bodySmall,
  theme.labelLarge,
  theme.labelMedium,
  theme.labelSmall,
];

TextStyle renderedStyle(WidgetTester tester, Finder label) => tester
    .widget<RichText>(
      find.descendant(of: label, matching: find.byType(RichText)).first,
    )
    .text
    .style!;

void main() {
  setUpAll(loadLearningDesignFonts);
  for (final dark in [true, false]) {
    testWidgets(
      'localized theme and components keep Lato and zero spacing ($dark)',
      (tester) async {
        late ThemeData theme;
        await pump(
          tester,
          Builder(
            builder: (context) {
              theme = Theme.of(context);
              return Column(
                children: [
                  const TextField(
                    controller: null,
                    decoration: InputDecoration(hintText: 'Email address'),
                  ),
                  const ListTile(title: Text('Settings')),
                  ChipSurface(
                    child: ChoiceChip(
                      label: const Text('All articles'),
                      selected: false,
                      onSelected: (_) {},
                    ),
                  ),
                ],
              );
            },
          ),
          dark: dark,
        );
        for (final style in [
          ...allStyles(theme.textTheme),
          ...allStyles(theme.primaryTextTheme),
        ]) {
          expect(style!.fontFamily, 'Lato');
          expect(style.letterSpacing, 0);
        }
        expect(
          tester
              .widget<EditableText>(find.byType(EditableText))
              .style
              .letterSpacing,
          0,
        );
        for (final label in ['Settings', 'All articles', 'Email address']) {
          final style = renderedStyle(tester, find.text(label));
          expect(style.fontFamily, 'Lato');
          expect(style.letterSpacing, 0);
        }
        final chipMaterial = tester.widget<PhysicalShape>(
          find
              .descendant(
                of: find.byType(RawChip),
                matching: find.byType(PhysicalShape),
              )
              .first,
        );
        expect(chipMaterial.color, Colors.transparent);
        final ink = tester.widget<Ink>(
          find
              .descendant(of: find.byType(RawChip), matching: find.byType(Ink))
              .first,
        );
        expect((ink.decoration! as ShapeDecoration).color, Colors.transparent);
        expect(
          tester.getSize(find.byType(RawChip)).height,
          greaterThanOrEqualTo(44),
        );
      },
    );

    testWidgets('code Copy follows compact button metrics ($dark)', (
      tester,
    ) async {
      await pump(
        tester,
        const FccCodeBlock(code: '<div>\n  Hello\n</div>', language: 'html'),
        dark: dark,
      );
      await tester.pumpAndSettle();
      final button = find.widgetWithText(TextButton, 'Copy');
      final material = find.descendant(
        of: button,
        matching: find.byType(Material),
      );
      expect(tester.getSize(material).height, 44);
      expect(tester.getSize(button).height, greaterThanOrEqualTo(48));
      final style = renderedStyle(tester, find.text('Copy'));
      expect(style.fontFamily, 'Lato');
      expect(style.fontSize, 14);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.letterSpacing, 0);
    });

    testWidgets(
      'theme buttons render Lato and preserve disabled paint ($dark)',
      (tester) async {
        await pump(
          tester,
          Column(
            children: [
              FilledButton(onPressed: () {}, child: const Text('Filled')),
              ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
              OutlinedButton(onPressed: () {}, child: const Text('Outline')),
              TextButton(onPressed: () {}, child: const Text('Text')),
              const FilledButton(onPressed: null, child: Text('Disabled')),
            ],
          ),
          dark: dark,
        );
        for (final label in [
          'Filled',
          'Elevated',
          'Outline',
          'Text',
          'Disabled',
        ]) {
          expect(renderedStyle(tester, find.text(label)).fontFamily, 'Lato');
          expect(renderedStyle(tester, find.text(label)).letterSpacing, 0);
        }
        final theme = Theme.of(tester.element(find.text('Disabled')));
        final surface = tester.widget<Material>(
          find.descendant(
            of: find.widgetWithText(FilledButton, 'Disabled'),
            matching: find.byType(Material),
          ),
        );
        expect(surface.color, theme.colorScheme.surfaceContainer);
        expect(
          renderedStyle(tester, find.text('Disabled')).color,
          theme.colorScheme.outline,
        );
      },
    );
  }

  testWidgets('switch dimensions, semantics, activation and themed on state', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var value = false;
    await pump(
      tester,
      StatefulBuilder(
        builder: (context, setState) => FccSwitch(
          value: value,
          onChanged: (next) => setState(() => value = next),
          semanticLabel: 'Daily challenge reminder',
        ),
      ),
    );
    final track = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.constraints?.maxWidth == 48 &&
          widget.constraints?.maxHeight == 28,
    );
    final thumb = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.constraints?.maxWidth == 22 &&
          widget.constraints?.maxHeight == 22,
    );
    expect(tester.getSize(track), const Size(48, 28));
    expect(tester.getSize(thumb), const Size(22, 22));
    final decoration =
        tester
                .widget<Container>(
                  find
                      .descendant(of: track, matching: find.byType(Container))
                      .first,
                )
                .decoration!
            as BoxDecoration;
    expect(decoration.color, const Color(0xff3f3557));
    expect(
      (decoration.border! as Border).top,
      const BorderSide(color: Color(0xff7d709d)),
    );
    expect(
      (tester.widget<Container>(thumb).decoration! as BoxDecoration).color,
      const Color(0xffcabeea),
    );
    expect(
      tester.getSize(find.byType(FccSwitch)).height,
      greaterThanOrEqualTo(48),
    );
    expect(
      tester.getSemantics(find.byType(FccSwitch)).flagsCollection.isToggled,
      Tristate.isFalse,
    );
    await tester.tap(find.byType(FccSwitch));
    await tester.pumpAndSettle();
    expect(value, isTrue);
    expect(
      tester.getSemantics(find.byType(FccSwitch)).flagsCollection.isToggled,
      Tristate.isTrue,
    );
    expect(find.byType(Switch), findsNothing);
    final onTheme = Theme.of(
      tester.element(find.byType(FccSwitch)),
    ).switchTheme;
    expect(
      (tester
                  .widget<Container>(
                    find
                        .descendant(of: track, matching: find.byType(Container))
                        .first,
                  )
                  .decoration!
              as BoxDecoration)
          .color,
      onTheme.trackColor!.resolve({WidgetState.selected}),
    );
    expect(
      (tester.widget<Container>(thumb).decoration! as BoxDecoration).color,
      onTheme.thumbColor!.resolve({WidgetState.selected}),
    );
    semantics.dispose();
  });

  testWidgets('switch thumb slides between states instead of jumping', (
    tester,
  ) async {
    var value = false;
    await pump(
      tester,
      StatefulBuilder(
        builder: (context, setState) => FccSwitch(
          value: value,
          onChanged: (next) => setState(() => value = next),
          semanticLabel: 'Sound effects',
        ),
      ),
    );
    final thumb = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.constraints?.maxWidth == 22 &&
          widget.constraints?.maxHeight == 22,
    );
    final start = tester.getCenter(thumb).dx;
    await tester.tap(find.byType(FccSwitch));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final middle = tester.getCenter(thumb).dx;
    await tester.pumpAndSettle();
    final end = tester.getCenter(thumb).dx;
    expect(middle, greaterThan(start));
    expect(middle, lessThan(end));
  });

  testWidgets('segments share track, pill and accessible targets at1.3scale', (
    tester,
  ) async {
    String? chosen;
    await pump(
      tester,
      SegmentedTabs<String>(
        tabs: const [
          (value: 'js', label: 'JavaScript', icon: null),
          (value: 'py', label: 'Python', icon: null),
        ],
        selected: 'js',
        onSelected: (value) => chosen = value,
        fontFamily: 'JetBrains Mono',
        fontSize: 14,
        selectedWeight: FontWeight.w700,
        unselectedWeight: FontWeight.w600,
      ),
      scale: 1.3,
    );
    final outer = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(SegmentedTabs<String>),
            matching: find.byType(Container),
          )
          .first,
    );
    final decoration = outer.decoration! as BoxDecoration;
    expect(decoration.color, const Color(0xff2b2140));
    expect(decoration.borderRadius, BorderRadius.circular(12));
    final selected = tester.widget<Material>(
      find
          .ancestor(
            of: find.text('JavaScript'),
            matching: find.byType(Material),
          )
          .first,
    );
    final shape = selected.shape! as RoundedRectangleBorder;
    expect(selected.color, const Color(0xff29216c));
    expect(shape.borderRadius, BorderRadius.circular(8));
    expect(shape.side, const BorderSide(color: Color(0xffbbbfff), width: 1.5));
    expect(
      renderedStyle(tester, find.text('JavaScript')).fontWeight,
      FontWeight.w700,
    );
    expect(
      renderedStyle(tester, find.text('Python')).fontWeight,
      FontWeight.w600,
    );
    final track = tester.getRect(find.byType(SegmentedTabs<String>));
    expect(track.height, 54);
    final firstPill = tester.getRect(
      find
          .ancestor(
            of: find.text('JavaScript'),
            matching: find.byType(Material),
          )
          .first,
    );
    final secondPill = tester.getRect(
      find
          .ancestor(of: find.text('Python'), matching: find.byType(Material))
          .first,
    );
    expect(firstPill.top - track.top, 5);
    expect(firstPill.left - track.left, 5);
    expect(firstPill.height, 44);
    expect(secondPill.left - firstPill.right, 4);
    await tester.tapAt(Offset(track.right - 40, track.top + 2));
    expect(chosen, 'py');
    expect(tester.takeException(), isNull);
  });

  testWidgets('reset dialog actions measure50 and use17px labels', (
    tester,
  ) async {
    await pump(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showConfirmDialog(
            context,
            title: 'Reset app data?',
            description: 'Clear local data.',
            confirmLabel: 'Reset',
            destructive: true,
          ),
          child: const Text('Open dialog'),
        ),
      ),
    );
    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();
    for (final label in ['Reset', 'Cancel']) {
      final type = label == 'Reset' ? FilledButton : OutlinedButton;
      final button = find.widgetWithText(type, label);
      expect(tester.getSize(button).height, 50);
      expect(renderedStyle(tester, find.text(label)).fontSize, 17);
      expect(
        renderedStyle(tester, find.text(label)).fontWeight,
        label == 'Reset' ? FontWeight.w900 : FontWeight.w700,
      );
    }
  });

  testWidgets('error card matches all measurements and retains detail', (
    tester,
  ) async {
    await pump(
      tester,
      ErrorRetry(
        message: 'Something went wrong',
        detail: 'Your progress is safe.',
        onRetry: () {},
      ),
    );
    final card = tester.widget<Card>(find.byType(Card));
    final shape = card.shape! as RoundedRectangleBorder;
    expect(tester.getRect(find.byType(Card)).left, 16);
    expect(tester.getSize(find.byType(Card)).width, 358);
    expect(shape.borderRadius, BorderRadius.circular(20));
    expect(shape.side, const BorderSide(color: Color(0xff4c4066)));
    final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
    expect(icon.size, 34);
    expect(icon.color, const Color(0xffcabeea));
    expect(find.text('Your progress is safe.'), findsOneWidget);
    expect(
      tester.getSize(find.widgetWithText(FilledButton, 'Try again')).height,
      50,
    );
    expect(renderedStyle(tester, find.text('Try again')).fontSize, 17);
  });

  testWidgets('navigation border stays behind Donate on a transparent bar', (
    tester,
  ) async {
    await pump(
      tester,
      const AppBottomNavigation(selected: AppDestination.learn),
    );
    final box = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(AppBottomNavigation),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    expect(box.position, DecorationPosition.background);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).backgroundColor,
      Colors.transparent,
    );
    expect(
      ((box.decoration as BoxDecoration).border! as Border).top,
      const BorderSide(color: Color(0xff4c4066)),
    );
  });
}
