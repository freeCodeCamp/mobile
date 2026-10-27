import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/ui/landing/learning_resume.dart';

const course = SuperBlockSummary(
  dashedName: 'course',
  title: 'Course',
  isPublic: true,
);
Block block(String name, {bool disabled = false}) => Block(
  superBlock: 'course',
  dashedName: name,
  name: name,
  layout: BlockLayout.challengeGrid,
  label: BlockLabel.workshop,
  description: [],
  challenges: [
    for (var i = 1; i <= 3; i++)
      ChallengeOrder(id: '$name-$i', title: 'Step $i'),
  ],
  isDisabledByOverride: disabled,
);
FccUserModel user({String? current, List<String> completed = const []}) =>
    FccUserModel(
      id: 'camper',
      email: 'example@example.com',
      username: 'camper',
      joinDate: DateTime(2020),
      currentChallengeId: current,
      completedChallenges: [
        for (final id in completed)
          CompletedChallenge(
            id: id,
            completedDate: DateTime(
              2026,
            ).add(Duration(minutes: completed.indexOf(id))),
          ),
      ],
    );
void main() {
  final courses = [
    (course, SuperBlock.blocks([block('a'), block('b')])),
  ];
  test('new learner opens first step directly', () {
    final result = resolveLearningResume(courses, null)!;
    expect(result.challenge.id, 'a-1');
    expect(result.step, 1);
  });
  test('current unfinished challenge takes precedence', () {
    final result = resolveLearningResume(
      courses,
      user(current: 'b-2', completed: ['a-1']),
    )!;
    expect(result.challenge.id, 'b-2');
    expect(result.isReturning, isTrue);
  });
  test('completed current step advances without losing block', () {
    final result = resolveLearningResume(
      courses,
      user(current: 'b-1', completed: ['b-1']),
    )!;
    expect(result.challenge.id, 'b-2');
    expect(result.isReturning, isTrue);
    expect(result.completed, 1);
  });
  test('most recent completion resumes its course', () {
    expect(
      resolveLearningResume(
        courses,
        user(completed: ['a-1', 'b-1']),
      )!.challenge.id,
      'b-2',
    );
  });
  test('finished block moves to next block', () {
    expect(
      resolveLearningResume(
        courses,
        user(current: 'a-3', completed: ['a-1', 'a-2', 'a-3']),
      )!.challenge.id,
      'b-1',
    );
  });
  test('disabled blocks are never offered', () {
    final data = [
      (
        course,
        SuperBlock.blocks([
          block('disabled', disabled: true),
          block('available'),
        ]),
      ),
    ];
    expect(
      resolveLearningResume(
        data,
        user(current: 'disabled-1'),
      )!.block.dashedName,
      'available',
    );
  });
  test('completed curriculum does not reopen a completed step', () {
    expect(
      resolveLearningResume(
        courses,
        user(completed: ['a-1', 'a-2', 'a-3', 'b-1', 'b-2', 'b-3']),
      ),
      isNull,
    );
  });
  test('exam and coming-soon chapters cannot become resume targets', () {
    final data = [
      (
        course,
        SuperBlock.chapters([
          Chapter(
            dashedName: 'future',
            name: 'Future',
            comingSoon: true,
            modules: [
              Module(
                dashedName: 'future',
                name: 'Future',
                blocks: [block('future')],
              ),
            ],
          ),
          Chapter(
            dashedName: 'responsive-web-design-certification-exam',
            name: 'Exam',
            modules: [
              Module(dashedName: 'exam', name: 'Exam', blocks: [block('exam')]),
            ],
          ),
          Chapter(
            dashedName: 'available',
            name: 'Available',
            modules: [
              Module(
                dashedName: 'available',
                name: 'Available',
                blocks: [block('available')],
              ),
            ],
          ),
        ]),
      ),
    ];
    expect(
      resolveLearningResume(data, user(current: 'exam-1'))!.block.dashedName,
      'available',
    );
  });
}
