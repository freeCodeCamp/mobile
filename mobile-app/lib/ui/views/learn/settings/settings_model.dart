import 'dart:async';
import 'dart:developer';

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

  String? username;

  Timer? requestCooldonwTimer;

  String? helperText;
  String? errorText;

  Map<String, dynamic>? userInfo;

  set setProfile(Map<String, dynamic> ui) {
    profile = ui;
    notifyListeners();
  }

  set setUserInfo(Map<String, dynamic> data) {
    userInfo = data;
    notifyListeners();
  }

  set setUserFuture(Future<FccUserModel> userLoaded) {
    userFuture = userLoaded;
    notifyListeners();
  }

  set setUsername(String name) {
    username = name;
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

    setUserInfo = {
      'name': user.name,
      'location': user.location,
      'picture': user.picture,
      'about': user.about,
    };
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

  save() async {
    bool updated =
        await _learnService.updateMyProfileUI({'profileUI': profile!});

    if (updated) {
      _snackbarService.showSnackbar(
          title: 'updated settings successfully', message: '');
      auth.init();
    } else {
      _snackbarService.showSnackbar(title: 'something went wrong', message: '');
    }
  }

  void updateUsername(String username) async {
    if (await _learnService.updateUsername(username)) {
      _snackbarService.showSnackbar(
          title: 'username updated successfully', message: '');
      init();
      auth.init();
    } else {
      _snackbarService.showSnackbar(title: 'something went wrong', message: '');
    }
  }

  Future<bool> validateUsername(String username, String currName) async {
    log(username);
    RegExp validChars =
        RegExp(r'^[a-zA-Z0-9\-_+]*$', multiLine: true, unicode: true);

    int? intUsername = int.tryParse(username);

    if (username.length <= 2 || username.isEmpty) {
      setErrorText = 'name is too short';
      return false;
    }

    if (currName == username) {
      setErrorText = 'this already is your username';
      return false;
    }

    if (!validChars.hasMatch(username)) {
      setErrorText = 'contains invalid characters';
      return false;
    }

    if (intUsername != null) {
      if (intUsername >= 100 && intUsername <= 599) {
        setErrorText = '$username is a reserved error code';
        return false;
      }
    }

    return true;
  }

  void searchUsername(String username, String currentName) {
    void search() async {
      bool usernameIsValid = await validateUsername(username, currentName);

      if (usernameIsValid) {
        if (await _learnService.checkIfUsernameIsTaken(username)) {
          setErrorText = 'username is already taken';
          return;
        } else {
          setHelperText = 'username is available';
          setErrorText = null;
        }
      }
    }

    if (requestCooldonwTimer == null) {
      log('timer was not set to begin with');
      requestCooldonwTimer = Timer(const Duration(seconds: 1), search);
    } else if (!requestCooldonwTimer!.isActive) {
      requestCooldonwTimer = Timer(const Duration(seconds: 1), search);
    } else {
      requestCooldonwTimer!.cancel();
      requestCooldonwTimer = Timer(const Duration(seconds: 1), search);
    }

    setHelperText = 'searching..';
    setErrorText = null;
  }

  saveAbout() async {
    if (userInfo != null) {
      bool complete = await _learnService.updateMyAbout(userInfo!);

      if (complete) {
        _snackbarService.showSnackbar(
            title: 'info updated successfully', message: '');
        auth.init();
      } else {
        _snackbarService.showSnackbar(
            title: 'something went wrong', message: '');
      }
    }
  }

  upateMyAbout(String flag, String value) {
    if (userInfo != null) {
      Map<String, dynamic> localUserInfo = userInfo!;

      List<String> possibleFlags = ['location', 'about', 'picture', 'name'];

      if (possibleFlags.contains(flag)) {
        localUserInfo[flag] = value;
        setUserInfo = localUserInfo;
      }
    }
  }
}
