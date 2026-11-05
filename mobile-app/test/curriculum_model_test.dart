import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';

Block _block(String dashedName, BlockLabel label) => Block(
  superBlock: 'responsive-web-design-v9',
  dashedName: dashedName,
  name: dashedName,
  layout: BlockLayout.challengeList,
  label: label,
  description: const [],
  challenges: const [],
);

void main() {
  group('ChapterExam.examBlock', () {
    test('should return the exam block when a module holds it', () {
      final chapter = Chapter(
        dashedName: 'responsive-web-design-certification-exam',
        name: 'Certification Exam',
        modules: [
          Module(
            dashedName: 'responsive-web-design-certification-exam',
            name: 'Exam',
            blocks: [
              _block('intro', BlockLabel.lecture),
              _block(
                'exam-responsive-web-design-certification',
                BlockLabel.exam,
              ),
            ],
          ),
        ],
      );

      expect(
        chapter.examBlock?.dashedName,
        'exam-responsive-web-design-certification',
      );
    });

    test('should return null when no block is labelled as an exam', () {
      final chapter = Chapter(
        dashedName: 'chapter',
        name: 'Chapter',
        modules: [
          Module(
            dashedName: 'module',
            name: 'Module',
            blocks: [_block('lesson', BlockLabel.lecture)],
          ),
        ],
      );

      expect(chapter.examBlock, isNull);
    });
  });
}
