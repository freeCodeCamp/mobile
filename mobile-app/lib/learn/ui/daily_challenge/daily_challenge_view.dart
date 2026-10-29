import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          dailyChallengeNumber: daily.challengeNumber,
          challenge: ref
              .watch(learnDailyChallengeServiceProvider)
              .toChallenge(daily, language),
          selector: DailyChallengeLanguageSelector(
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

class DailyChallengeLanguageSelector extends StatelessWidget {
  const DailyChallengeLanguageSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final DailyChallengeLanguage selected;
  final ValueChanged<DailyChallengeLanguage> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: SegmentedButton<DailyChallengeLanguage>(
        expandedInsets: EdgeInsets.zero,
        showSelectedIcon: false,
        selected: {selected},
        segments: [
          for (final language in DailyChallengeLanguage.values)
            ButtonSegment(value: language, label: Text(language.label)),
        ],
        onSelectionChanged: (languages) => onSelected(languages.single),
      ),
    );
  }
}
