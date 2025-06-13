import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';

String handleChallengeTitle(Challenge challenge, Block block) {
  if (block.challenges.length == 1 ||
      challenge.title.contains('Dialogue') ||
      challenge.title.contains('Step')) {
    return '';
  }

  int numberOfDialogueHeaders = block.challenges
      .where((challenge) => challenge.title.contains('Dialogue'))
      .length;

  // English challenges have titles like "Task 1", "Task 2", etc.
  // The number of tasks = total challenges - number of dialogue headers
  if (challenge.title.contains('Task')) {
    return '${challenge.title} of ${block.challenges.length - numberOfDialogueHeaders}';
  } else {
    int challengeStepNumber =
        block.challenges.indexWhere((c) => c.id == challenge.id) + 1;

    return 'Step $challengeStepNumber of ${block.challenges.length}';
  }
}
