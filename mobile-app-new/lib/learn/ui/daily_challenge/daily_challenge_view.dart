import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/daily_challenge_model.dart';
import 'package:mobile_app_new/learn/services/daily_challenge_service.dart';
import 'package:mobile_app_new/learn/ui/daily_challenge/daily_challenge_viewmodel.dart';
import 'package:mobile_app_new/learn/ui/editor_challenge/editor_challenge_view.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';

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
    Text label(DailyChallengeLanguage language) => Text(
      language.label,
      style: TextStyle(
        color: language == selected ? FccColors.blue50 : Colors.white,
        fontWeight: language == selected ? FontWeight.bold : FontWeight.normal,
      ),
    );

    return DropdownButton<DailyChallengeLanguage>(
      isExpanded: true,
      dropdownColor: FccColors.gray85,
      underline: const SizedBox.shrink(),
      value: selected,
      items: [
        for (final language in DailyChallengeLanguage.values)
          DropdownMenuItem(value: language, child: label(language)),
      ],
      selectedItemBuilder: (_) => [
        for (final language in DailyChallengeLanguage.values)
          Center(child: label(language)),
      ],
      onChanged: (language) {
        if (language != null) onSelected(language);
      },
    );
  }
}
