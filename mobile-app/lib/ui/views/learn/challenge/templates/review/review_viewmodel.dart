import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class ReviewViewmodel extends BaseViewModel {
  List<bool> _assignmentsStatus = [];
  List<bool> get assignmentsStatus => _assignmentsStatus;

  final LearnService learnService = locator<LearnService>();

  List<Widget> _parsedInstructions = [];
  List<Widget> get parsedInstructions => _parsedInstructions;

  List<Widget> _parsedDescription = [];
  List<Widget> get parsedDescription => _parsedDescription;

  set setParsedInstructions(List<Widget> widgets) {
    _parsedInstructions = widgets;
    notifyListeners();
  }

  set setParsedDescription(List<Widget> widgets) {
    _parsedDescription = widgets;
    notifyListeners();
  }

  set setAssignmentsStatus(List<bool> status) {
    _assignmentsStatus = status;
    notifyListeners();
  }

  void setAssignmentStatus(int index) {
    setAssignmentsStatus = List<bool>.from(_assignmentsStatus)
      ..[index] = !_assignmentsStatus[index];
    notifyListeners();
  }

  void initChallenge(Challenge challenge, BuildContext context) {
    final parser = HTMLParser(context: context);

    setAssignmentsStatus = List.filled(
      challenge.assignments?.length ?? 0,
      false,
    );

    setParsedInstructions = parser.parse(
      challenge.instructions,
      customStyles: {
        '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)': Style(
          color: FccColors.gray05,
        ),
      },
    );

    setParsedDescription = parser.parse(
      challenge.description,
      customStyles: {
        '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)': Style(
          color: FccColors.gray05,
        ),
      },
    );
  }
}
