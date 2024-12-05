import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/views/learn/superblock/superblock_view.dart';
import 'package:stacked/stacked.dart';

class EnglishViewModel extends BaseViewModel {
  final LearnOfflineService learnOfflineService =
      locator<LearnOfflineService>();

  final LearnService learnService = locator<LearnService>();
  void updateProgressOnPop(BuildContext context, Block block) async {
    learnOfflineService.hasInternet().then(
          (value) => Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: Duration.zero,
              pageBuilder: (
                context,
                animation1,
                animation2,
              ) =>
                  SuperBlockView(
                superBlockDashedName: block.superBlock.dashedName,
                superBlockName: block.superBlock.name,
                hasInternet: value,
              ),
            ),
          ),
        );
  }
}
