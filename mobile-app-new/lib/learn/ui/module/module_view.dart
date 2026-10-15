import 'package:mobile_app_new/widgets/app_bottom_navigation.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/learn/controllers/curriculum_controller.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/widgets/block_card.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';

class ModuleView extends ConsumerWidget {
  const ModuleView({super.key, required this.superBlock, required this.module});
  final String superBlock;
  final String module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = superBlockProvider(superBlock);
    final curriculum = ref.watch(provider);
    final fullCourseTitle = ref.watch(
      curriculumStagesProvider.select(
        (s) => s.value
            ?.expand((stage) => stage.superBlocks)
            .firstWhereOrNull((sb) => sb.dashedName == superBlock)
            ?.title,
      ),
    );
    final courseTitle = fullCourseTitle?.replaceFirst(
      RegExp(r'\s+Certification$', caseSensitive: false),
      '',
    );
    return Scaffold(
      bottomNavigationBar: const AppNavigationFooter(
        selected: AppDestination.learn,
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: FccDesignColors.of(context).accentText,
        toolbarHeight: 56 + MediaQuery.textScalerOf(context).scale(18) - 18,
        leadingWidth: 40,
        titleSpacing: 0,
        leading: IconButton(
          tooltip: 'Back to ${courseTitle ?? 'course'}',
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              LearnSuperBlockRoute(superBlock: superBlock).go(context);
            }
          },
        ),
        title: Text(
          courseTitle ?? 'Course',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: FccDesignColors.of(context).accentText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: curriculum.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorRetry(
          message: 'Something went wrong!',
          onRetry: () => ref.invalidate(provider),
        ),
        data: (curriculum) {
          final chapter = switch (curriculum) {
            ChapterSuperBlock(:final chapters) => chapters.firstWhereOrNull(
              (c) => c.modules.any((m) => m.dashedName == module),
            ),
            BlockSuperBlock() => null,
          };
          final found = chapter?.modules.firstWhereOrNull(
            (m) => m.dashedName == module,
          );
          if (found == null) {
            return const ErrorRetry(message: 'No blocks available right now.');
          }
          return BlockList(
            blocks: found.blocks,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            header: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${courseTitle ?? 'Course'} · ${chapter!.name}'
                        .toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      height: 1.4,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    found.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
