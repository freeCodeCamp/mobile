import 'dart:async';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/main/profile_ui_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication_service.dart';
import 'package:freecodecamp/service/learn_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SettingsModel extends BaseViewModel {
  late Map<String, dynamic>? profile;

  final AuthenticationService auth = locator<AuthenticationService>();
  final LearnService _learnService = locator<LearnService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();

  Future<FccUserModel>? userFuture;

  String? helperText;
  String? errorText;

  Timer? usernameSearchCoolDown;

  set setProfile(Map<String, dynamic> ui) {
    profile = ui;
    notifyListeners();
  }

  set setUserFuture(Future<FccUserModel> userLoaded) {
    userFuture = userLoaded;
    notifyListeners();
  }

  set setHelperText(String? text) {
    helperText = text;
    notifyListeners();
  }

  set setErrorText(String? text) {
    errorText = text;
    notifyListeners();
  }

  void init() async {
    await auth.init();

    setUserFuture = auth.userModel!;

    FccUserModel? user = await userFuture!;

    setProfile = ProfileUI.toMap(user.profileUI);
  }

  String? getDescriptions(String flag) {
    switch (flag) {
      case 'isLocked':
        return '''Your certifications will be disabled, if set to private.''';
      case 'showName':
        return '''Your name will not appear on your certifications, if this is set to private.''';
      case 'showCerts':
        return '''Your certifications will be disabled, if set to private.''';
    }

    return null;
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

  void save() async {
    bool updated =
        await _learnService.updateMyProfileUI({'profileUI': profile!});

    if (updated) {
      _snackbarService.showSnackbar(
          title: 'updated settings successfully', message: '');
    } else {
      _snackbarService.showSnackbar(title: 'something went wrong', message: '');
    }
  }

  void searchUsername(String username) {
    void searchUsername() async {
      bool isUsernameTaken =
          await _learnService.checkIfUsernameIsTaken(username);

      if (isUsernameTaken) {
        setHelperText = null;
        setErrorText = 'username is taken';
      } else {
        setErrorText = null;
        setHelperText = 'username is available';
      }
    }

    if (usernameSearchCoolDown == null) {
      setHelperText = 'searching..';
      setErrorText = null;
      usernameSearchCoolDown =
          Timer(const Duration(seconds: 2), searchUsername);
    } else if (!usernameSearchCoolDown!.isActive) {
      setErrorText = null;
      setHelperText = 'searching..';
      usernameSearchCoolDown =
          Timer(const Duration(seconds: 2), searchUsername);
    }
  }
}
