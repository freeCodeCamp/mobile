import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('setLastVisitedChallenge saves correct data to SharedPreferences',
      () async {
    SharedPreferences.setMockInitialValues({});

    final prefs = await SharedPreferences.getInstance();

    final LearnService service = LearnService();

    final block = Block(
      name: 'Learn Greetings in Your First Day at the Office',
      dashedName: 'learn-greetings-in-your-first-day-at-the-office',
      description: ['block description'],
      isStepBased: true,
      challenges: [],
      challengeTiles: [],
      superBlock: SuperBlock(
        dashedName: 'a2-english-for-developers',
        name: 'A2 English for Developers',
      ),
    );

    service.setLastVisitedChallenge(
        'https://www.freecodecamp.dev/curriculum-data/v2/challenges/a2-english-for-developers/learn-greetings-in-your-first-day-at-the-office/6543aa3df5f028dba112f275.json',
        block);

    final result = prefs.getStringList('lastVisitedChallenge');

    expect(result, [
      'https://www.freecodecamp.dev/curriculum-data/v2/challenges/a2-english-for-developers/learn-greetings-in-your-first-day-at-the-office/6543aa3df5f028dba112f275.json',
      'a2-english-for-developers',
      'A2 English for Developers',
      'learn-greetings-in-your-first-day-at-the-office',
    ]);
  });
}
