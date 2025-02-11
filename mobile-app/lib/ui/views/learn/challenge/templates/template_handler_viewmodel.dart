import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:stacked/stacked.dart';

class HandleTemplateModel extends BaseViewModel {
  Future<Challenge>? _challenge;
  Future<Challenge>? get challenge => _challenge;
}
