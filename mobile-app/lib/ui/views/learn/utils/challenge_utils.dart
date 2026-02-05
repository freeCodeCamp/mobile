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

// Takes a DateTime and returns a formatted string like "January 2025"
String formatMonthFromDate(DateTime date) {
  const monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return '${monthNames[date.month - 1]} ${date.year}';
}

// Parses a month-year string like "January 2025" into a DateTime object
DateTime parseMonthYear(String monthYear) {
  List<String> parts = monthYear.split(' ');
  String monthName = parts[0];
  int year = int.parse(parts[1]);

  const monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  int month = monthNames.indexOf(monthName) + 1;
  return DateTime(year, month, 1);
}

// Formats a DateTime as YYYY-MM-DD
String formatChallengeDate(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String parseSyntaxError(String errorMessage) {
  final syntaxErrorRegex = RegExp(r'SyntaxError:.*?\((\d+):(\d+)\)');
  final match = syntaxErrorRegex.firstMatch(errorMessage);

  if (match != null) {
    final line = int.parse(match.group(1)!) - 1;
    return 'There is a syntax error on line $line. Please check for missing brackets, quotes, or other syntax issues.';
  }

  if (errorMessage.contains('Babel transpilation failed')) {
    return 'There is a syntax error in your code. Please check for missing brackets, quotes, or other syntax issues.';
  }

  return errorMessage;
}
