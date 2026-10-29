import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/ui/challenge/challenge_viewmodel.dart';
import 'package:freecodecamp/services/analytics_service.dart';
import 'package:freecodecamp/services/auth_service.dart';

import '../../../helpers/fake_analytics.dart';

class _SignedOut extends AuthNotifier {
  @override
  Future<FccUserModel?> build() async => null;
}

Challenge _challenge(int challengeType) => Challenge(
  id: 'c1',
  block: 'basic-html',
  superBlock: 'responsive-web-design-v9',
  title: 'Step 1',
  dashedName: 'step-1',
  challengeType: challengeType,
);

void main() {
  late FakeAnalyticsSink sink;
  late ProviderContainer container;

  setUp(() async {
    sink = FakeAnalyticsSink();
    container = ProviderContainer(
      overrides: [
        analyticsProvider.overrideWithValue(AnalyticsService(sink)),
        authProvider.overrideWith(_SignedOut.new),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authProvider.future);
  });

  Future<bool> submit(Challenge challenge) => container
      .read(challengeSubmitProvider(challenge.id).notifier)
      .submit(challenge);

  test(
    'a signed-out user completing a challenge logs challenge_completed',
    () async {
      expect(await submit(_challenge(0)), isTrue);
      expect(sink.logged, [
        [
          'challenge_completed',
          {
            'superblock': 'responsive-web-design-v9',
            'block': 'basic-html',
            'challenge_type': 0,
          },
        ],
      ]);
    },
  );

  test(
    'a daily challenge logs daily_challenge_completed with its language',
    () async {
      await submit(_challenge(28));
      await submit(_challenge(29));
      expect(sink.logged, [
        [
          'daily_challenge_completed',
          {'language': 'javascript'},
        ],
        [
          'daily_challenge_completed',
          {'language': 'python'},
        ],
      ]);
    },
  );
}
