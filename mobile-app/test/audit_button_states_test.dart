import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/ui/widgets/profile_form.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_button.dart';

Material buttonMaterial(WidgetTester tester, Finder button) =>
    tester.widget<Material>(
      find.descendant(of: button, matching: find.byType(Material)).first,
    );

void main() {
  for (final dark in [false, true]) {
    final theme = dark ? FccTheme.themeDark : FccTheme.themeLight;
    testWidgets(
      'Rendered button states and compact targets (${dark ? 'dark' : 'light'})',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: Column(
                children: [
                  ChallengeButton(label: 'Check', onPressed: () {}),
                  const ChallengeButton(
                    label: 'Previous',
                    secondary: true,
                    onPressed: null,
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                  ProfileFormError(message: 'Save failed', onDismiss: () {}),
                ],
              ),
            ),
          ),
        );
        final primary = find.widgetWithText(FilledButton, 'Check');
        expect(
          buttonMaterial(tester, primary).color,
          theme.colorScheme.secondary,
        );
        final gesture = await tester.startGesture(tester.getCenter(primary));
        await tester.pumpAndSettle();
        expect(
          buttonMaterial(tester, primary).color,
          theme.extension<FccDesignColors>()!.primaryPressed,
        );
        await gesture.up();
        await tester.pumpAndSettle();
        final disabled = find.widgetWithText(FilledButton, 'Previous');
        expect(
          buttonMaterial(tester, disabled).color,
          theme.colorScheme.surfaceContainer,
        );
        expect(
          DefaultTextStyle.of(
            tester.element(find.text('Previous')),
          ).style.color,
          theme.colorScheme.outline,
        );
        final disabledShape =
            buttonMaterial(tester, disabled).shape! as OutlinedBorder;
        expect(disabledShape.side, BorderSide.none);
        expect(
          tester.getSize(find.widgetWithIcon(IconButton, Icons.add)),
          const Size(44, 44),
        );
        final dismiss = tester.getSize(find.byTooltip('Dismiss error'));
        expect(dismiss.width, greaterThanOrEqualTo(44));
        expect(dismiss.height, greaterThanOrEqualTo(44));
        expect(theme.textTheme.labelLarge!.color, theme.colorScheme.onSurface);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Choice chips render selected and idle typography (${dark ? 'dark' : 'light'})',
      (tester) async {
        var selected = false;
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: StatefulBuilder(
              builder: (context, setState) => Scaffold(
                body: Center(
                  child: ChoiceChip(
                    label: const Text('Downloaded'),
                    selected: selected,
                    onSelected: (value) => setState(() => selected = value),
                  ),
                ),
              ),
            ),
          ),
        );
        TextStyle label() =>
            DefaultTextStyle.of(tester.element(find.text('Downloaded'))).style;
        expect(label().fontSize, 14);
        expect(label().fontWeight, FontWeight.w700);
        expect(label().color, theme.colorScheme.onSurfaceVariant);
        await tester.tap(find.byType(ChoiceChip));
        await tester.pumpAndSettle();
        expect(label().fontWeight, FontWeight.w900);
        expect(label().color, theme.colorScheme.onSurface);
        expect(
          tester.widget<RawChip>(find.byType(RawChip)).showCheckmark,
          isTrue,
        );
      },
    );
  }
}
