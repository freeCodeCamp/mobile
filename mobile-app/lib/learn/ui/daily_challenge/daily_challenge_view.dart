import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/daily_challenge_model.dart';
import 'package:freecodecamp/learn/services/daily_challenge_service.dart';
import 'package:freecodecamp/learn/ui/daily_challenge/daily_challenge_viewmodel.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_challenge_view.dart';
import 'package:freecodecamp/widgets/error_retry.dart';

class DailyChallengeView extends ConsumerWidget {
  const DailyChallengeView({super.key, required this.day});

  final String day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenge = ref.watch(dailyChallengeProvider(day));
    final language = ref.watch(dailyChallengeLanguageProvider);

    return switch ((challenge, language)) {
      (AsyncData(value: final daily), AsyncData(value: final language)) =>
        EditorChallengeView(
          challenge: ref
              .watch(learnDailyChallengeServiceProvider)
              .toChallenge(daily, language),
          selector: _LanguageSelector(
            selected: language,
            onSelected: (language) => ref
                .read(dailyChallengeLanguageProvider.notifier)
                .select(language),
          ),
        ),
      (AsyncError(), _) || (_, AsyncError()) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: ErrorRetry(
            message: 'Something went wrong!',
            onRetry: () => ref
              ..invalidate(dailyChallengeProvider(day))
              ..invalidate(dailyChallengeLanguageProvider),
          ),
        ),
      ),
      _ => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
    };
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({required this.selected, required this.onSelected});

  final DailyChallengeLanguage selected;
  final ValueChanged<DailyChallengeLanguage> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    Text label(DailyChallengeLanguage language) => Text(
      language.label,
      style: TextStyle(
        fontSize: 16,
        color: language == selected
            ? FccDesignColors.of(context).accentText
            : colors.onSurface,
        fontWeight: language == selected ? FontWeight.w700 : FontWeight.w400,
      ),
    );

    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: DropdownButton<DailyChallengeLanguage>(
        isExpanded: true,
        isDense: true,
        itemHeight: null,
        alignment: Alignment.centerLeft,
        dropdownColor: colors.surface,
        borderRadius: BorderRadius.circular(12),
        icon: Icon(Icons.expand_more, color: colors.onSurfaceVariant),
        underline: const SizedBox.shrink(),
        value: selected,
        items: [
          for (final language in DailyChallengeLanguage.values)
            DropdownMenuItem(
              value: language,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: label(language),
              ),
            ),
        ],
        selectedItemBuilder: (_) => [
          for (final language in DailyChallengeLanguage.values)
            Align(alignment: Alignment.centerLeft, child: label(language)),
        ],
        onChanged: (language) {
          if (language != null) onSelected(language);
        },
      ),
    );
  }
}
