import 'dart:developer';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/main/profile_ui_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication_service.dart';
import 'package:freecodecamp/service/learn_service.dart';
import 'package:stacked/stacked.dart';

class SettingsModel extends BaseViewModel {
  late Map<String, dynamic>? profile;

  final AuthenticationService _auth = locator<AuthenticationService>();
  final LearnService _learnService = locator<LearnService>();

  set setProfile(Map<String, dynamic> ui) {
    profile = ui;
    notifyListeners();
  }

  void init() async {
    await _auth.init();
    FccUserModel? user = await _auth.userModel;

    setProfile = ProfileUI.toMap(user!.profileUI);
  }

  void setNewValue(String flag, bool value) {
    List<String> profileKeys = profile!.keys.toList();

    Map<String, dynamic> scopedProfile = profile!;

    if (profileKeys.contains(flag)) {
      flag != 'isLocked'
          ? scopedProfile[flag] = value
          : scopedProfile[flag] = !value;

      setProfile = scopedProfile;
    }
  }

  save() {
    log(profile.toString());
    _learnService.updateMyProfileUI(profile!);
  }
}
