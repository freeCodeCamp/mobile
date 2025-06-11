import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';

String handleChallengeTitle(Challenge challenge, Block block) {
  if (block.challenges.length == 1 || challenge.title.contains('Dialogue')) {
    return '';
  }

  int numberOfDialogueHeaders = block.challenges
      .where((challenge) => challenge.title.contains('Dialogue'))
      .length;

  // English challenges have titles like "Task 1", "Task 2", etc.
  // The number of tasks = total challenges - number of dialogue headers
  if (challenge.title.contains('Task')) {
    return '${challenge.title} of ${block.challenges.length - numberOfDialogueHeaders}';
  } else if (challenge.title.contains('Step')) {
    // Other challenges have titles like "Step 1", "Step 2", etc.
    // The number of steps = total challenges
    return 'Step ${challenge.title} of ${block.challenges.length}';
  } else {
    int challengeStepNumber =
        block.challenges.indexWhere((c) => c.id == challenge.id) + 1;

    return 'Step $challengeStepNumber of ${block.challenges.length}';
  }
}
