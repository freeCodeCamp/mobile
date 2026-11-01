import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/learn/ui/widgets/learning_website.dart';

void main() {
  group('learningWebsiteUri', () {
    test('should build the superblock URL when no block is given', () {
      final uri = learningWebsiteUri('javascript-v9');

      expect(
        uri.toString(),
        'https://www.freecodecamp.org/learn/javascript-v9/',
      );
    });

    test('should repeat the block segment for an exam block', () {
      final uri = learningWebsiteUri(
        'responsive-web-design-v9',
        block: 'exam-responsive-web-design-certification',
      );

      expect(
        uri.toString(),
        'https://www.freecodecamp.org/learn/responsive-web-design-v9/'
        'exam-responsive-web-design-certification/'
        'exam-responsive-web-design-certification',
      );
    });
  });
}
