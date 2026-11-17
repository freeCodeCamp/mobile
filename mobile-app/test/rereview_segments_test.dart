import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/widgets/fcc_switch.dart';
import 'package:freecodecamp/widgets/segmented_tabs.dart';

import 'rereview_learn_fonts.dart';

Future<void> pumpControl(
  WidgetTester tester,
  Widget child,
  ThemeData theme, {
  double scale = 1.3,
}) => tester.pumpWidget(
  MaterialApp(
    theme: theme,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(scale)),
      child: child!,
    ),
    home: Scaffold(
      body: Center(child: SizedBox(width: 320, child: child)),
    ),
  ),
);

Finder pill(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(Material)).first;

void expectRing(ShapeBorder shape, Color color, {double radius = 8}) {
  const rect = Rect.fromLTWH(0, 0, 100, 44);
  expect(
    (Canvas canvas) =>
        shape.paint(canvas, rect, textDirection: TextDirection.ltr),
    paints..rrect(
      rrect: BorderRadius.circular(radius).toRRect(rect).inflate(3),
      color: color,
      strokeWidth: 2,
      style: PaintingStyle.stroke,
    ),
  );
}

void main() {
  setUpAll(loadLearningDesignFonts);
  for (final dark in [false, true]) {
    final theme = dark ? FccTheme.themeDark : FccTheme.themeLight;
    final mode = dark ? 'dark' : 'light';
    testWidgets('segment visual geometry and semantic targets $mode', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      var selected = 'system';
      var changes = 0;
      await pumpControl(
        tester,
        StatefulBuilder(
          builder: (context, setState) => SegmentedTabs<String>(
            tabs: const [
              (value: 'system', label: 'System', icon: null),
              (value: 'light', label: 'Light', icon: null),
              (value: 'dark', label: 'Dark', icon: null),
            ],
            selected: selected,
            onSelected: (value) => setState(() {
              changes++;
              selected = value;
            }),
          ),
        ),
        theme,
      );
      final track = tester.getRect(find.byType(SegmentedTabs<String>));
      final first = tester.getRect(pill('System'));
      final second = tester.getRect(pill('Light'));
      expect(track.height, 54);
      expect(first.height, 44);
      expect(first.left - track.left, 5);
      expect(first.top - track.top, 5);
      expect(second.left - first.right, 4);
      for (final label in ['System', 'Light', 'Dark']) {
        final node = tester.getSemantics(find.bySemanticsLabel(label));
        expect(node.rect.height, greaterThanOrEqualTo(48));
        expect(node.rect.width, greaterThanOrEqualTo(48));
        expect(node.flagsCollection.isButton, isTrue);
        expect(node.flagsCollection.isEnabled, Tristate.isTrue);
        expect(node.flagsCollection.isFocused, Tristate.isFalse);
      }
      // The top padding belongs to the individual segment's target.
      await tester.tapAt(Offset(second.center.dx, track.top + 2));
      await tester.pumpAndSettle();
      expect(selected, 'light');
      expect(changes, 1);
      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();
      final semantic = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.label == 'Light',
        ),
      );
      semantic.properties.onTap!();
      expect(changes, 1);
      expect(tester.takeException(), isNull);
      semantics.dispose();
    });

    testWidgets(
      'segments have keyboard focus rings and disabled states $mode',
      (tester) async {
        final semantics = tester.ensureSemantics();
        var chosen = '';
        Widget control({bool disabled = false}) => SegmentedTabs<String>(
          tabs: const [
            (value: 'public', label: 'Public', icon: Icons.public),
            (value: 'private', label: 'Private', icon: Icons.lock_outline),
          ],
          selected: 'public',
          onSelected: disabled ? null : (value) => chosen = value,
        );
        await pumpControl(tester, control(), theme);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        expectRing(
          tester.widget<Material>(pill('Public')).shape!,
          theme.colorScheme.onSurface,
        );
        expect(
          tester
              .getSemantics(find.bySemanticsLabel('Public'))
              .flagsCollection
              .isFocused,
          Tristate.isTrue,
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        expectRing(
          tester.widget<Material>(pill('Private')).shape!,
          theme.colorScheme.onSurface,
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pumpAndSettle();
        expect(chosen, 'private');

        await pumpControl(tester, control(disabled: true), theme);
        await tester.pumpAndSettle();
        for (final label in ['Public', 'Private']) {
          final material = tester.widget<Material>(pill(label));
          expect(material.color, theme.colorScheme.surfaceContainer);
          expect((material.shape! as OutlinedBorder).side, BorderSide.none);
          expect(
            (Canvas canvas) => material.shape!.paint(
              canvas,
              const Rect.fromLTWH(0, 0, 100, 44),
            ),
            paintsNothing,
          );
          expect(
            tester.widget<Text>(find.text(label)).style!.color,
            theme.colorScheme.outline,
          );
          final node = tester.getSemantics(find.bySemanticsLabel(label));
          expect(node.flagsCollection.isEnabled, Tristate.isFalse);
          expect(node.flagsCollection.isFocused, Tristate.none);
          expect(
            node.getSemanticsData().hasAction(SemanticsAction.tap),
            isFalse,
          );
        }
        expect(
          tester.widget<Icon>(find.byIcon(Icons.public)).color,
          theme.colorScheme.outline,
        );
        expect(tester.takeException(), isNull);
        semantics.dispose();
      },
    );

    testWidgets('off switch keyboard ring and focus survive toggles $mode', (
      tester,
    ) async {
      var enabled = false;
      await pumpControl(
        tester,
        StatefulBuilder(
          builder: (context, setState) => Center(
            child: FccSwitch(
              value: enabled,
              onChanged: (value) => setState(() => enabled = value),
              semanticLabel: 'Sound effects',
            ),
          ),
        ),
        theme,
      );
      Finder track() => find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints?.maxWidth == 48 &&
            widget.constraints?.maxHeight == 28,
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      final decoration =
          tester.widget<Container>(track()).foregroundDecoration!
              as ShapeDecoration;
      expectRing(decoration.shape, theme.colorScheme.onSurface, radius: 14);
      final focus = FocusManager.instance.primaryFocus;
      expect(focus, isNotNull);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(enabled, isTrue);
      expect(find.byType(Switch), findsOneWidget);
      expect(FocusManager.instance.primaryFocus, same(focus));
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(enabled, isFalse);
      expect(FocusManager.instance.primaryFocus, same(focus));
      expectRing(
        (tester.widget<Container>(track()).foregroundDecoration!
                as ShapeDecoration)
            .shape,
        theme.colorScheme.onSurface,
        radius: 14,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
