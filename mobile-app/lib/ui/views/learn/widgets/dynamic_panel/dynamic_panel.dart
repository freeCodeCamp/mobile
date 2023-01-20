import 'package:flutter/material.dart';
import 'package:flutter_code_editor/editor/editor.dart';
import 'package:freecodecamp/enums/panel_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_view/challenge_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/description/description_widget_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/hint/hint_widget_view.dart';
import 'package:freecodecamp/ui/views/learn/widgets/pass/pass_widget_view.dart';

class DynamicPanel extends StatelessWidget {
  const DynamicPanel({
    Key? key,
    required this.challenge,
    required this.model,
    required this.panel,
    required this.maxChallenges,
    required this.challengesCompleted,
    required this.editor,
  }) : super(key: key);

  final Challenge challenge;
  final ChallengeModel model;
  final PanelType panel;
  final int maxChallenges;
  final int challengesCompleted;

  final Editor editor;

  Widget panelHandler(PanelType panel) {
    switch (panel) {
      case PanelType.instruction:
        return DescriptionView(
          description: challenge.description,
          instructions: challenge.instructions,
          challengeModel: model,
          editorText: model.editorText,
          maxChallenges: maxChallenges,
          title: challenge.title,
        );
      case PanelType.pass:
        return PassWidgetView(
          challengeModel: model,
          challengesCompleted: challengesCompleted,
          maxChallenges: maxChallenges,
        );
      case PanelType.hint:
        return HintWidgetView(
          hint: model.hint,
          challengeModel: model,
          editor: editor,
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      color: const Color(0xFF0a0a23),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: panelHandler(panel),
      ),
    );
  }
}
