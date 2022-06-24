import 'dart:io';

dynamic main() {
  final commitFile = File('../.git/COMMIT_EDITMSG');
  final commitMessage = commitFile.readAsStringSync();

  final regExp = RegExp(
    r'(fix|feat|wip|none|chore|refactor|docs|style|test)\:.+',
  );

  final valid = regExp.hasMatch(commitMessage);
  if (!valid) {
    print('''👎 Bad commit message! A correct one would be: 
        docs: correct spelling of CHANGELOG''');
    exitCode = 1;
  } else {
    print('''👍 Nice commit message dude!''');
  }
}
