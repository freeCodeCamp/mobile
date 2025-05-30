import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:stacked/stacked.dart';

class ReviewViewmodel extends BaseViewModel {
  List<bool> _assignmentStatus = [];
  List<bool> get assignmentStatus => _assignmentStatus;

  final LearnService learnService = locator<LearnService>();

  void setAssignmentStatus(int ind) {
    _assignmentStatus = List<bool>.from(_assignmentStatus)
      ..[ind] = !_assignmentStatus[ind];
    notifyListeners();
  }

  void initChallenge(Challenge challenge) {
    _assignmentStatus = List.filled(
      challenge.assignments?.length ?? 0,
      false,
    );
  }
}
