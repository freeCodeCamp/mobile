import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/constants/curriculum.dart';
import 'package:freecodecamp/learn/controllers/curriculum_controller.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/ui/widgets/block_card.dart';
import 'package:freecodecamp/learn/ui/widgets/learn_presentation.dart';
import 'package:freecodecamp/learn/ui/widgets/learning_website.dart';
import 'package:freecodecamp/routing/learn.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/error_retry.dart';

class SuperBlockView extends ConsumerStatefulWidget {
  const SuperBlockView({super.key, required this.dashedName});
  final String dashedName;

  @override
  ConsumerState<SuperBlockView> createState() => _SuperBlockViewState();
}

class _SuperBlockViewState extends ConsumerState<SuperBlockView> {
  @override
  void initState() {
    super.initState();
    unawaited(ref.read(authProvider.notifier).refresh());
  }

  @override
  Widget build(BuildContext context) {
    final provider = superBlockProvider(widget.dashedName);
    final superBlock = ref.watch(provider);
    final title = ref.watch(
      curriculumStagesProvider.select(
        (s) => s.value
            ?.expand((stage) => stage.superBlocks)
            .firstWhereOrNull((sb) => sb.dashedName == widget.dashedName)
            ?.title,
      ),
    );
    return Scaffold(
      bottomNavigationBar: const AppNavigationFooter(
        selected: AppDestination.learn,
      ),
      appBar: AppBar(
        leadingWidth: 44,
        titleSpacing: 0,
        leading: IconButton(
          tooltip: 'Back to Courses',
          icon: Icon(
            Icons.chevron_left,
            color: FccDesignColors.of(context).accentText,
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              const LearnLandingRoute().go(context);
            }
          },
        ),
        title: Text(
          'Courses',
          style: TextStyle(
            color: FccDesignColors.of(context).accentText,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: superBlock.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorRetry(
          message: 'Something went wrong!',
          onRetry: () => ref.invalidate(provider),
        ),
        data: (superBlock) => RefreshIndicator(
          onRefresh: () =>
              ref.refresh(provider.future).then((_) {}, onError: (_) {}),
          child: switch (superBlock) {
            BlockSuperBlock(:final blocks) => BlockList(
              blocks: blocks,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              header: _CourseHero(title: title ?? 'Course', blocks: blocks),
            ),
            ChapterSuperBlock(:final chapters) => _Chapters(
              title: title ?? 'Course',
              superBlock: widget.dashedName,
              chapters: chapters,
            ),
          },
        ),
      ),
    );
  }
}

bool _locked(Chapter chapter) =>
    chapter.comingSoon ||
    (devOnlyChapters.contains(chapter.dashedName) &&
        !(dotenv.isInitialized &&
            dotenv.getBool('DEVELOPMENT_MODE', fallback: false)));

class _Chapters extends ConsumerWidget {
  const _Chapters({
    required this.title,
    required this.superBlock,
    required this.chapters,
  });
  final String title;
  final String superBlock;
  final List<Chapter> chapters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exams = this.chapters
        .where((c) => hiddenExamChapters.contains(c.dashedName))
        .toList();
    final chapters = this.chapters
        .where((c) => !hiddenExamChapters.contains(c.dashedName))
        .toList();
    final completed = ref.watch(
      authProvider.select(
        (s) => {...?s.value?.completedChallenges.map((c) => c.id)},
      ),
    );
    final available = chapters.where((c) => !_locked(c));
    final blocks = available
        .expand((c) => c.modules.where((m) => !m.comingSoon))
        .expand((m) => m.blocks)
        .toList();
    final active = available.firstWhereOrNull(
      (c) => c.modules
          .where((m) => !m.comingSoon)
          .expand((m) => m.blocks)
          .expand((b) => b.challenges)
          .any((ch) => !completed.contains(ch.id)),
    );
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        _CourseHero(title: title, blocks: blocks, chapters: this.chapters),
        if (chapters.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text('No chapters available right now.'),
          ),
        for (final (index, chapter) in chapters.indexed)
          _ChapterCard(
            key: ValueKey(chapter.dashedName),
            superBlock: superBlock,
            chapter: chapter,
            number: index + 1,
            active: chapter == active,
            isLocked: _locked(chapter),
          ),
        for (final exam in exams)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.emoji_events_outlined,
                          color: FccDesignColors.of(context).accentText,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LearnEyebrow(
                              'Chapter ${this.chapters.indexOf(exam) + 1}',
                            ),
                            const Text(
                              'Certification Exam',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _locked(exam)
                              ? 'This exam is coming soon.'
                              : "Take it on the website when you're ready.",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 44),
                        ),
                        onPressed: _locked(exam)
                            ? null
                            : () => openLearningWebsite(
                                context,
                                superBlock,
                                chapter: exam.dashedName,
                              ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Open',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                decoration: _locked(exam)
                                    ? TextDecoration.none
                                    : TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.open_in_new, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _CourseHero extends ConsumerWidget {
  const _CourseHero({required this.title, required this.blocks, this.chapters});
  final String title;
  final List<Block> blocks;
  final List<Chapter>? chapters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completed = ref.watch(
      authProvider.select(
        (s) => {...?s.value?.completedChallenges.map((c) => c.id)},
      ),
    );
    final available = blocks.where((b) => !b.isDisabledByOverride);
    final challenges = available.expand((b) => b.challenges).toList();
    final done = challenges.where((c) => completed.contains(c.id)).length;
    final nextBlock = available.firstWhereOrNull(
      (b) => b.challenges.any((c) => !completed.contains(c.id)),
    );
    final nextBlockDone =
        nextBlock?.challenges.where((c) => completed.contains(c.id)).length ??
        0;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FccDesignColors.of(context).hero,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title.replaceFirst(
              RegExp(r'\s+Certification$', caseSensitive: false),
              '',
            ),
            style: TextStyle(
              color: FccDesignColors.of(context).heroForeground,
              fontSize: 26,
              height: 1.2,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          if (chapters != null && chapters!.isNotEmpty)
            LayoutBuilder(
              builder: (context, constraints) {
                final widths = _segmentWidths([
                  for (final chapter in chapters!) _chapterWeight(chapter),
                ], constraints.maxWidth);
                return Row(
                  children: [
                    for (final (index, chapter) in chapters!.indexed) ...[
                      if (index > 0) const SizedBox(width: _segmentGap),
                      SizedBox(
                        width: widths[index],
                        child: _ChapterProgress(
                          chapter: chapter,
                          completed: completed,
                        ),
                      ),
                    ],
                  ],
                );
              },
            )
          else
            LearnProgress(
              done: done,
              total: challenges.length,
              color: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: .22),
            ),
          if (nextBlock != null) ...[
            const SizedBox(height: 14),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                textStyle: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              onPressed: () => LearnChallengeRoute(
                superBlock: nextBlock.superBlock,
                block: nextBlock.dashedName,
                challengeId: nextBlock.challenges
                    .firstWhere((c) => !completed.contains(c.id))
                    .id,
              ).push<void>(context),
              icon: const Icon(Icons.arrow_forward, size: 18),
              iconAlignment: IconAlignment.end,
              label: Text(nextBlockDone > 0 ? 'Continue' : 'Start'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChapterCard extends ConsumerStatefulWidget {
  const _ChapterCard({
    super.key,
    required this.superBlock,
    required this.chapter,
    required this.number,
    required this.active,
    required this.isLocked,
  });
  final String superBlock;
  final Chapter chapter;
  final int number;
  final bool active;
  final bool isLocked;

  @override
  ConsumerState<_ChapterCard> createState() => _ChapterCardState();
}

class _ChapterCardState extends ConsumerState<_ChapterCard> {
  bool? _expanded;
  @override
  Widget build(BuildContext context) {
    final chapter = widget.chapter;
    final active = widget.active;
    final isLocked = widget.isLocked;
    final number = widget.number;
    final superBlock = widget.superBlock;
    final expanded = _expanded ?? (active && !isLocked);

    final colors = Theme.of(context).colorScheme;
    final completed = ref.watch(
      authProvider.select(
        (s) => {...?s.value?.completedChallenges.map((c) => c.id)},
      ),
    );
    final modules = chapter.modules.where((m) => !m.comingSoon).toList();
    final current = modules.firstWhereOrNull(
      (m) => m.blocks
          .expand((b) => b.challenges)
          .any((c) => !completed.contains(c.id)),
    );
    bool moduleComplete(Module module) {
      final challenges = module.blocks.expand((b) => b.challenges).toList();
      return challenges.isNotEmpty &&
          challenges.every((c) => completed.contains(c.id));
    }

    final doneModules = modules.where(moduleComplete).length;
    final complete = modules.isNotEmpty && doneModules == modules.length;
    final hasProgress = modules
        .expand((m) => m.blocks)
        .expand((b) => b.challenges)
        .any((c) => completed.contains(c.id));
    final design = FccDesignColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.outlineVariant),
        ),
        child: ExpansionTile(
          onExpansionChanged: (value) => setState(() => _expanded = value),
          key: PageStorageKey(chapter.dashedName),
          initiallyExpanded: active && !isLocked,
          enabled: !isLocked,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
          shape: const Border(),
          collapsedShape: const Border(),
          iconColor: design.accentText,
          collapsedIconColor: design.accentText,
          leading: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: complete ? design.success : colors.primaryContainer,
              borderRadius: BorderRadius.circular(14),
              border: expanded
                  ? Border.all(color: design.accentText, width: 1.5)
                  : null,
            ),
            child: complete
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  )
                : Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: design.accentText,
                    ),
                  ),
          ),
          title: Text(
            chapter.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          subtitle: isLocked
              ? Text(
                  'Coming soon',
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.onSurfaceVariant,
                  ),
                )
              : expanded
              ? null
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasProgress) ...[
                      const SizedBox(height: 6),
                      Text(
                        complete
                            ? 'Done'
                            : '$doneModules of ${modules.length} modules',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: complete
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: complete
                              ? design.success
                              : colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        for (final module in modules)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: moduleComplete(module)
                                  ? design.success
                                  : design.hero,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
          children: [
            Stack(
              children: [
                if (modules.length > 1)
                  Positioned(
                    left: 25,
                    top: 28,
                    bottom: 28,
                    child: Container(width: 3, color: design.hero),
                  ),
                Column(
                  children: [
                    for (final module in modules)
                      _ModuleButton(
                        superBlock: superBlock,
                        module: module,
                        active: module == current,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleButton extends ConsumerWidget {
  const _ModuleButton({
    required this.superBlock,
    required this.module,
    required this.active,
  });
  final String superBlock;
  final Module module;
  final bool active;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final blocks = module.blocks;
    final challenges = blocks.expand((b) => b.challenges).toList();
    final completed = ref.watch(
      authProvider.select(
        (s) => {...?s.value?.completedChallenges.map((c) => c.id)},
      ),
    );
    final done = challenges.where((c) => completed.contains(c.id)).length;
    final complete = challenges.isNotEmpty && done == challenges.length;
    final isReview = blocks.firstOrNull?.label == BlockLabel.review;
    final completedBlocks = blocks
        .where(
          (b) =>
              b.challenges.isNotEmpty &&
              b.challenges.every((c) => completed.contains(c.id)),
        )
        .length;
    final subtitle = module.moduleType == ModuleType.certProject
        ? 'Certification project'
        : active
        ? '$completedBlocks of ${blocks.length} blocks'
        : null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: active ? colors.primaryContainer : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: active
                ? FccDesignColors.of(context).accentText
                : Colors.transparent,
            width: active ? 1.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: challenges.isEmpty
              ? null
              : () {
                  if (challenges.length == 1) {
                    final block = blocks.firstWhere(
                      (b) => b.challenges.isNotEmpty,
                    );
                    LearnChallengeRoute(
                      superBlock: superBlock,
                      block: block.dashedName,
                      challengeId: challenges.first.id,
                    ).push<void>(context);
                  } else {
                    LearnModuleRoute(
                      superBlock: superBlock,
                      module: module.dashedName,
                    ).push<void>(context);
                  }
                },
          child: Container(
            constraints: const BoxConstraints(minHeight: 60),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                LearnStatus(
                  complete: complete,
                  active: active,
                  module: true,
                  icon: module.moduleType == ModuleType.certProject
                      ? Icons.flag_outlined
                      : isReview || module.moduleType == ModuleType.review
                      ? Icons.loop
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: active
                                ? FccDesignColors.of(context).accentText
                                : colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (active) ...[
                        const SizedBox(height: 6),
                        LearnProgress(
                          done: done,
                          total: challenges.length,
                          backgroundColor: colors.primaryContainer,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const _segmentGap = 3.0;
const _segmentMinWidth = 14.0;

int _chapterWeight(Chapter chapter) {
  final modules = chapter.modules.where((m) => !m.comingSoon).length;
  return modules < 1 ? 1 : modules;
}

List<double> _segmentWidths(List<int> weights, double maxWidth) {
  final available = maxWidth - _segmentGap * (weights.length - 1);
  final pinned = <int>{};
  var changed = true;
  while (changed) {
    changed = false;
    final free = [
      for (var i = 0; i < weights.length; i++)
        if (!pinned.contains(i)) i,
    ];
    final totalWeight = free.fold<int>(0, (sum, i) => sum + weights[i]);
    final remaining = available - _segmentMinWidth * pinned.length;
    for (final i in free) {
      if (remaining * weights[i] / totalWeight < _segmentMinWidth) {
        pinned.add(i);
        changed = true;
      }
    }
  }
  final freeWeight = [
    for (var i = 0; i < weights.length; i++)
      if (!pinned.contains(i)) weights[i],
  ].fold<int>(0, (sum, w) => sum + w);
  final remaining = available - _segmentMinWidth * pinned.length;
  return [
    for (var i = 0; i < weights.length; i++)
      pinned.contains(i)
          ? _segmentMinWidth
          : remaining * weights[i] / freeWeight,
  ];
}

class _ChapterProgress extends StatelessWidget {
  const _ChapterProgress({required this.chapter, required this.completed});
  final Chapter chapter;
  final Set<String> completed;
  @override
  Widget build(BuildContext context) {
    final challenges = chapter.modules
        .expand((m) => m.blocks)
        .expand((b) => b.challenges)
        .toList();
    final done = challenges.where((c) => completed.contains(c.id)).length;
    return LinearProgressIndicator(
      value: challenges.isEmpty ? 0 : done / challenges.length,
      minHeight: 10,
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      backgroundColor: Colors.white.withValues(alpha: .22),
      semanticsLabel: '${chapter.name}: $done of ${challenges.length} complete',
    );
  }
}
