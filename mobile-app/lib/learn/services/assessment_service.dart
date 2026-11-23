import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/question_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'assessment_service.g.dart';

@riverpod
LearnAssessmentService learnAssessmentService(Ref ref) =>
    const LearnAssessmentService();

class LearnAssessmentService {
  const LearnAssessmentService();

  List<QuestionItem> lessonQuestions(Challenge challenge) =>
      challenge.questions.map(questionItem).toList();

  bool assignmentsComplete(List<bool> assignments) =>
      assignments.every((done) => done);

  bool hasAnswers(List<String> answers) =>
      answers.every((answer) => answer.trim().isNotEmpty);

  ({List<bool> results, bool passed, String feedback}) checkBlanks(
    List<Blank> blanks,
    List<String> answers,
  ) {
    final results = [
      for (final (index, blank) in blanks.indexed)
        answers[index].trim().toLowerCase() == blank.answer.toLowerCase(),
    ];
    final firstWrong = results.indexOf(false);
    return (
      results: results,
      passed: firstWrong == -1,
      feedback: firstWrong == -1 ? '' : blanks[firstWrong].feedback,
    );
  }

  List<bool> checkLessonAnswers(
    List<QuestionItem> questions,
    List<int?> selected,
    List<bool> checked,
  ) => [
    for (final (index, question) in questions.indexed)
      checked[index] && selected[index] == question.solution,
  ];

  bool lessonPassed(List<bool> results) => results.every((correct) => correct);

  int firstPendingQuestion(List<bool> results) {
    final pending = results.indexOf(false);
    return pending < 0 ? 0 : pending;
  }

  bool canCompleteReading(
    Challenge challenge,
    List<bool> assignments,
    bool reviewed,
  ) =>
      assignmentsComplete(assignments) &&
      (challenge.challengeType != 31 || assignments.isNotEmpty || reviewed);

  String? projectLinkError(String link) {
    final uri = Uri.tryParse(link);
    if (uri == null ||
        uri.host.isEmpty ||
        !['https', 'http'].contains(uri.scheme)) {
      return 'Please enter a valid HTTPS link.';
    }
    final host = uri.host.toLowerCase();
    if (host == 'localhost' ||
        host.endsWith('.localhost') ||
        host == '127.0.0.1' ||
        host == '::1') {
      return 'Remember to submit a publicly visible app URL.';
    }
    if (uri.scheme != 'https') return 'Please use a secure (https) URL.';
    if (host == 'freecodecamp.org' ||
        host.endsWith('.freecodecamp.org') ||
        host == 'freecodecamp.rocks' ||
        host.endsWith('.freecodecamp.rocks') ||
        (['github.com', 'codepen.io'].contains(host) &&
            uri.pathSegments.firstOrNull?.toLowerCase() == 'freecodecamp')) {
      return 'Remember to submit your own work.';
    }
    return null;
  }
}
