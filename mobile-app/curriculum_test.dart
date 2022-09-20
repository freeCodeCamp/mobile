import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';

void main() async {
  final dio = Dio();

  var superBlocksFile = File('curriculum-data/available-superblocks.json');
  superBlocksFile.createSync(recursive: true);
  await dio.download(
      'https://freecodecamp.dev/curriculum-data/v1/available-superblocks.json',
      superBlocksFile.path);

  List<SuperBlockButton> superBlockButtons = [];

  List superBlocksRes =
      jsonDecode(superBlocksFile.readAsStringSync())['superblocks'];

  for (int i = 0; i < superBlocksRes.length; i++) {
    if (!superBlocksRes[i]['public']) continue;
    superBlockButtons.add(SuperBlockButton(
      path: superBlocksRes[i]['dashedName'],
      name: superBlocksRes[i]['title'],
      public: superBlocksRes[i]['public'],
    ));
  }

  for (int i = 0; i < superBlockButtons.length; i++) {
    var superBlockFile =
        File('curriculum-data/${superBlockButtons[i].path}/main.json');
    superBlockFile.createSync(recursive: true);
    await dio.download(
        'https://freecodecamp.dev/curriculum-data/v1/${superBlockButtons[i].path}.json',
        superBlockFile.path);

    var currSuperBlock =
        SuperBlock.fromJson(jsonDecode(superBlockFile.readAsStringSync()));
    for (Block currBlock in currSuperBlock.blocks) {
      for (var currChallenge in currBlock.challenges) {
        var currChallengeName =
            currChallenge.name.toLowerCase().replaceAll(' ', '-');
        String baseUrl = 'https://freecodecamp.dev/page-data/learn';
        String challengeUrl =
            '$baseUrl/${currBlock.superBlock}/${currBlock.dashedName}/$currChallengeName/page-data.json';
        print(challengeUrl);
        var challengeFile = File(
            'curriculum-data/${currBlock.superBlock}/${currBlock.dashedName}/$currChallengeName.json');
        challengeFile.createSync(recursive: true);
        await dio.download(challengeUrl, challengeFile.path);
      }
    }
  }
}
