import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:stacked/stacked.dart';

class ReviewViewmodel extends BaseViewModel {
  List<bool> _assignmentsStatus = [];
  List<bool> get assignmentsStatus => _assignmentsStatus;

  final LearnService learnService = locator<LearnService>();

  set setAssignmentsStatus(List<bool> status) {
    _assignmentsStatus = status;
    notifyListeners();
  }

  void setAssignmentStatus(int index) {
    setAssignmentsStatus = List<bool>.from(_assignmentsStatus)
      ..[index] = !_assignmentsStatus[index];
    notifyListeners();
  }

  void initChallenge(Challenge challenge) {
    setAssignmentsStatus = List.filled(
      challenge.assignments?.length ?? 0,
      false,
    );
  }
}
