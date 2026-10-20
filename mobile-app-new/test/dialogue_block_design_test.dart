import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart' hide Block;
import 'package:mobile_app_new/auth/models/user_model.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/challenge_viewmodel.dart';
import 'package:mobile_app_new/learn/ui/widgets/block_card.dart';
import 'package:mobile_app_new/learn/ui/widgets/dialogue_block_card.dart';
import 'package:mobile_app_new/services/auth_service.dart';

const _counts = [33, 61, 35, 23, 19];
const _titles = [
  'Dialogue 1: Maria Introduces Herself to Tom',
  'Dialogue 2: Tom Meets the Coworker Next to Him',
  'Dialogue 3: Tom and Sophie Take a Lunch Break',
  'Dialogue 4: Maria Describes Her Work',
  'Dialogue 5: Tom Finishes His First Day',
];

final _block = Block(
  superBlock: 'a2-english',
  dashedName: 'learn-greetings-in-your-first-day-at-the-office',
  name: 'Learn Greetings in your First Day at the Office',
  layout: BlockLayout.challengeDialogue,
  label: BlockLabel.learn,
  description: const ['Legacy description should not appear in this card.'],
  challenges: [
    for (var group = 0, task = 1; group < _counts.length; group++) ...[
      ChallengeOrder(id: 'dialogue-${group + 1}', title: _titles[group]),
      for (var i = 0; i < _counts[group]; i++, task++)
        ChallengeOrder(id: 'task-$task', title: 'Task $task'),
    ],
  ],
);

FccUserModel _user(Set<String> completed) => FccUserModel(
  id: 'dialogue-camper',
  email: 'camper@example.com',
  username: 'camper',
  joinDate: DateTime(2020),
  completedChallenges: [
    for (final id in completed)
      CompletedChallenge(id: id, completedDate: DateTime(2026, 10, 15)),
  ],
);

class _Auth extends AuthNotifier {
  _Auth(this.user);
  final FccUserModel user;
  @override
  Future<FccUserModel?> build() async => user;
  @override
  Future<void> refresh() async {}
  void complete(Set<String> ids) => state = AsyncData(_user(ids));
}

final _capture = GlobalKey();

Future<({GoRouter router, ProviderContainer container})> _pump(
  WidgetTester tester, {
  bool dark = false,
  double scale = 1,
  Set<String> completed = const {'dialogue-1', 'task-1', 'task-2', 'task-3'},
  List<String>? metadataLoads,
  Block? blockOverride,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(scale == 1 ? 390 : 320, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  final container = ProviderContainer(
    overrides: [
      authProvider.overrideWith(() => _Auth(_user(completed))),
      for (var i = 1; i <= _counts.length; i++)
        challengeScreenProvider(
          _block.superBlock,
          _block.dashedName,
          'dialogue-$i',
        ).overrideWith((ref) async {
          final id = 'dialogue-$i';
          metadataLoads?.add(id);
          throw StateError(
            'Scene metadata should only load on the challenge screen.',
          );
        }),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authProvider.future);
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: BlockCard(
              block: blockOverride ?? _block,
              isOpen: false,
              onToggle: () =>
                  fail('Dialogue blocks have no legacy outer toggle.'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/learn/:course/:block/:id',
        builder: (_, state) => Scaffold(body: Text(state.uri.path)),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: RepaintBoundary(
        key: _capture,
        child: MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          theme: dark ? FccTheme.themeDark : FccTheme.themeLight,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return (router: router, container: container);
}

Finder _tile(int number) => find.widgetWithText(TextButton, '$number');

Finder _header(int index) => find
    .ancestor(of: find.text(_titles[index]), matching: find.byType(InkWell))
    .first;

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void _expectExpanded(WidgetTester tester, int index, bool expanded) {
  final node = tester.getSemantics(_header(index));
  expect(
    node.flagsCollection.isExpanded,
    expanded ? ui.Tristate.isTrue : ui.Tristate.isFalse,
  );
}

Future<void> _screenshot(WidgetTester tester, String name) async {
  const directory = String.fromEnvironment('UI_SCREENSHOT_DIR');
  if (directory.isEmpty) {
    return;
  }
  await tester.runAsync(() async {
    final boundary =
        _capture.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('$directory/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final fonts = FontLoader('Lato');
    for (final weight in ['Regular', 'Bold', 'ExtraBold', 'Black']) {
      fonts.addFont(rootBundle.load('assets/fonts/Lato-$weight.ttf'));
    }
    await fonts.load();
    for (final font in {
      'monospace': 'assets/fonts/Hack-Regular.ttf',
      'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
    }.entries) {
      await (FontLoader(font.key)..addFont(rootBundle.load(font.value))).load();
    }
  });

  for (final dark in [false, true]) {
    for (final scale in [1.0, 2.0]) {
      final name = '${dark ? 'dark' : 'light'}-text${(scale * 100).toInt()}';
      testWidgets(
        'dialogue card groups numbered tasks and expands accessibly $name',
        (tester) async {
          final loads = <String>[];
          await _pump(tester, dark: dark, scale: scale, metadataLoads: loads);
          expect(find.byType(DialogueBlockCard), findsOneWidget);
          expect(find.text('5 DIALOGUES · 171 TASKS'), findsNothing);
          expect(find.text('5 dialogues · 171 tasks'), findsNothing);
          expect(find.text(_block.name), findsOneWidget);
          expect(find.text(_block.description.single), findsNothing);
          expect(find.byType(LinearProgressIndicator), findsNothing);
          expect(find.byType(FilledButton), findsNothing);
          for (final title in _titles) {
            expect(find.text(title), findsOneWidget);
          }
          expect(find.text('3 of 33 tasks'), findsOneWidget);
          expect(find.text('61 tasks'), findsOneWidget);
          expect(find.textContaining('with captions'), findsNothing);
          expect(find.text('Watch and listen'), findsNothing);
          expect(find.text('Watched'), findsOneWidget);
          expect(loads, isEmpty);
          _expectExpanded(tester, 0, true);
          _expectExpanded(tester, 1, false);
          expect(_tile(12), findsOneWidget);
          expect(_tile(13), findsNothing);
          final theme = dark ? FccTheme.themeDark : FccTheme.themeLight;
          final colors = theme.colorScheme;
          for (var i = 1; i <= 12; i++) {
            final size = tester.getSize(_tile(i));
            expect(size.width, closeTo(size.height, .01));
            expect(size.width, greaterThanOrEqualTo(44));
            expect(
              find.descendant(of: _tile(i), matching: find.text('$i')),
              findsOneWidget,
            );
          }
          final done = tester.widget<TextButton>(_tile(1));
          expect(
            done.style!.backgroundColor!.resolve({}),
            dark ? const Color(0xFF013B1B) : const Color(0xFFCBFBD7),
          );
          expect(
            done.style!.foregroundColor!.resolve({}),
            dark ? const Color(0xFF8DDBA3) : const Color(0xFF02743B),
          );
          final doneShape =
              done.style!.shape!.resolve({})! as RoundedRectangleBorder;
          expect(
            doneShape.side.style,
            dark ? BorderStyle.solid : BorderStyle.none,
          );
          expect(doneShape.side.width, dark ? 1.5 : 0);
          if (dark) {
            expect(doneShape.side.color, const Color(0xFF8DDBA3));
          }
          expect(
            find.descendant(of: _tile(1), matching: find.byIcon(Icons.check)),
            findsNothing,
          );
          final current = tester.widget<TextButton>(_tile(4));
          final shape =
              current.style!.shape!.resolve({})! as RoundedRectangleBorder;
          expect(shape.side.width, 2);
          expect(shape.side.color, colors.primary);
          expect(current.style!.backgroundColor!.resolve({}), colors.surface);
          expect(current.style!.foregroundColor!.resolve({}), colors.onSurface);
          final pending = tester.widget<TextButton>(_tile(5));
          final pendingShape =
              pending.style!.shape!.resolve({})! as RoundedRectangleBorder;
          expect(pendingShape.side.color, colors.outlineVariant);
          expect(pendingShape.side.width, 1);
          expect(pending.style!.backgroundColor!.resolve({}), colors.surface);
          expect(pending.style!.foregroundColor!.resolve({}), colors.onSurface);
          expect(find.bySemanticsLabel('Task 1, completed'), findsOneWidget);
          expect(find.bySemanticsLabel('Task 4, current'), findsOneWidget);
          expect(
            tester
                .getSemantics(find.bySemanticsLabel('Task 4, current'))
                .getSemanticsData()
                .hasAction(ui.SemanticsAction.tap),
            isTrue,
          );
          await _screenshot(tester, 'dialogue-block-$name');

          final showAll = find.widgetWithText(TextButton, 'Show all 33 tasks');
          expect(tester.getSemantics(showAll).flagsCollection.isButton, isTrue);
          await _tap(tester, showAll);
          expect(_tile(33), findsOneWidget);
          expect(_tile(34), findsNothing);
          expect(find.text('5 DIALOGUES · 171 TASKS'), findsNothing);
          await _tap(
            tester,
            find.widgetWithText(TextButton, 'Show fewer tasks'),
          );
          expect(_tile(12), findsOneWidget);
          expect(_tile(13), findsNothing);
          await _tap(tester, _header(0));
          _expectExpanded(tester, 0, false);
          expect(find.text('Watch the dialogue'), findsNothing);
          expect(_tile(1), findsNothing);
          await _tap(tester, _header(1));
          _expectExpanded(tester, 1, true);
          expect(_tile(34), findsOneWidget);
          expect(loads, isEmpty);
          expect(find.text('Watched'), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets(
    'watch and numbered task actions route to their actual challenge ids',
    (tester) async {
      final loads = <String>[];
      final (:router, :container) = await _pump(tester, metadataLoads: loads);
      await _tap(tester, find.text('Watch the dialogue'));
      expect(
        find.text(
          '/learn/${_block.superBlock}/${_block.dashedName}/dialogue-1',
        ),
        findsOneWidget,
      );
      router.pop();
      await tester.pumpAndSettle();
      await _tap(tester, _tile(4));
      expect(
        find.text('/learn/${_block.superBlock}/${_block.dashedName}/task-4'),
        findsOneWidget,
      );
      expect(
        container.read(authProvider).value!.completedChallenges,
        hasLength(4),
      );
      expect(loads, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('first incomplete dialogue opens initially', (tester) async {
    await _pump(
      tester,
      completed: {'dialogue-1', for (var i = 1; i <= 33; i++) 'task-$i'},
    );
    _expectExpanded(tester, 0, false);
    _expectExpanded(tester, 1, true);
    expect(_tile(34), findsOneWidget);
    expect(_tile(1), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('completed blocks open the first dialogue', (tester) async {
    await _pump(tester, completed: _block.challenges.map((c) => c.id).toSet());
    _expectExpanded(tester, 0, true);
    _expectExpanded(tester, 1, false);
    expect(find.text('33 of 33 tasks'), findsOneWidget);
    expect(find.text('Watched'), findsOneWidget);
    expect(_tile(1), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'noncontiguous completion keeps numbers and marks the first gap',
    (tester) async {
      await _pump(tester, completed: {'dialogue-1', 'task-1', 'task-3'});
      expect(find.text('2 of 33 tasks'), findsOneWidget);
      expect(find.bySemanticsLabel('Task 1, completed'), findsOneWidget);
      expect(find.bySemanticsLabel('Task 3, completed'), findsOneWidget);
      expect(find.bySemanticsLabel('Task 2, current'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      final current = tester.widget<TextButton>(_tile(2));
      expect(
        (current.style!.shape!.resolve({})! as RoundedRectangleBorder)
            .side
            .width,
        2,
      );
      expect(tester.takeException(), isNull);
    },
  );

  for (final disabled in [false, true]) {
    testWidgets(
      '${disabled ? 'disabled' : 'empty'} dialogue block has no actions',
      (tester) async {
        final loads = <String>[];
        await _pump(
          tester,
          metadataLoads: loads,
          blockOverride: disabled
              ? _block.copyWith(isDisabledByOverride: true)
              : _block.copyWith(challenges: []),
        );
        expect(
          find.text(
            disabled
                ? 'Temporarily unavailable, come back soon.'
                : 'No dialogues available right now.',
          ),
          findsOneWidget,
        );
        expect(find.text('Watch the dialogue'), findsNothing);
        expect(find.byType(TextButton), findsNothing);
        expect(find.byType(FilledButton), findsNothing);
        expect(loads, isEmpty);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'watched status tracks header completion independently of tasks',
    (tester) async {
      final (:container, router: _) = await _pump(
        tester,
        completed: {'task-1', 'task-2', 'task-3'},
      );
      expect(find.text('3 of 33 tasks'), findsOneWidget);
      expect(find.text('Watched'), findsNothing);
      (container.read(authProvider.notifier) as _Auth).complete({
        'dialogue-1',
        'task-1',
        'task-2',
        'task-3',
      });
      await tester.pumpAndSettle();
      expect(find.text('Watched'), findsOneWidget);
      expect(find.text('3 of 33 tasks'), findsOneWidget);
      expect(find.text('5 DIALOGUES · 171 TASKS'), findsNothing);
    },
  );

  testWidgets('watch action stays available without scene metadata', (
    tester,
  ) async {
    final loads = <String>[];
    await _pump(tester, metadataLoads: loads);
    expect(find.text('Watch and listen'), findsNothing);
    expect(find.textContaining('with captions'), findsNothing);
    expect(_tile(4), findsOneWidget);
    await _tap(tester, find.text('Watch the dialogue'));
    expect(
      find.text('/learn/${_block.superBlock}/${_block.dashedName}/dialogue-1'),
      findsOneWidget,
    );
    expect(loads, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
