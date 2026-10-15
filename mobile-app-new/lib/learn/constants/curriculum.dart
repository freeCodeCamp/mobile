import 'package:flutter_dotenv/flutter_dotenv.dart';

const _prodUrl = 'https://www.freecodecamp.org/curriculum-data/v2';
const _devUrl = 'https://www.freecodecamp.dev/curriculum-data/v2';

String get curriculumDataUrl =>
    dotenv.getBool('DEVELOPMENT_MODE', fallback: false) ? _devUrl : _prodUrl;

const chapterBasedSuperBlocks = [
  'responsive-web-design-v9',
  'javascript-v9',
  'a1-professional-spanish',
  'python-v9',
];

// NOTE: available-superblocks.json stages shown, in order. `legacy` is deliberately absent.
const stageTitles = {
  'core': 'Recommended curriculum',
  'english': 'Learn English for Developers:',
  'spanish': 'Learn Professional Spanish:',
  'chinese': 'Learn Professional Chinese:',
  'extra': 'Prepare for the developer interview job search:',
  'professional': 'Professional certifications:',
};

const hiddenExamChapters = [
  'responsive-web-design-certification-exam',
  'javascript-certification-exam',
  'python-certification-exam',
];

// NOTE: Hidden unless DEVELOPMENT_MODE is on.
const devOnlyChapters = ['frontend-libraries'];

const _assets = 'assets/learn';
const defaultSuperBlockIcon = '$_assets/graduation.svg';

const superBlockIcons = {
  'responsive-web-design-v9': '$_assets/responsive-design.svg',
  'javascript-v9': '$_assets/javascript.svg',
  'front-end-development-libraries-v9': '$_assets/react.svg',
  'python-v9': '$_assets/python.svg',
  'relational-databases-v9': '$_assets/database.svg',
  'back-end-development-and-apis-v9': '$_assets/api.svg',
  '2022/responsive-web-design': '$_assets/responsive-design.svg',
  'responsive-web-design': '$_assets/responsive-design.svg',
  'javascript-algorithms-and-data-structures': '$_assets/javascript.svg',
  'javascript-algorithms-and-data-structures-v8': '$_assets/javascript.svg',
  'front-end-development-libraries': '$_assets/react.svg',
  'data-visualization': '$_assets/d3.svg',
  'back-end-development-and-apis': '$_assets/api.svg',
  'relational-database': '$_assets/database.svg',
  'quality-assurance': '$_assets/clipboard.svg',
  'scientific-computing-with-python': '$_assets/python.svg',
  'data-analysis-with-python': '$_assets/analytics.svg',
  'information-security': '$_assets/shield.svg',
  'machine-learning-with-python': '$_assets/tensorflow.svg',
  'coding-interview-prep': '$_assets/algorithm.svg',
  'the-odin-project': '$_assets/viking-helmet.svg',
  'project-euler': '$_assets/graduation.svg',
  'college-algebra-with-python': '$_assets/college-algebra.svg',
  'foundational-c-sharp-with-microsoft': '$_assets/c-sharp.svg',
  'a2-english-for-developers': '$_assets/a2-english.svg',
  'b1-english-for-developers': '$_assets/b1-english.svg',
  'a1-professional-spanish': '$_assets/a1-spanish.svg',
  'a1-professional-chinese': '$_assets/a1-chinese.svg',
  'rosetta-code': '$_assets/rosetta-code.svg',
  'python-for-everybody': '$_assets/python.svg',
  'dev-playground': '$_assets/code.svg',
};
