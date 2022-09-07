import 'package:freecodecamp/models/main/profile_ui_model.dart';
import 'package:stacked/stacked.dart';

class SettingsModel extends BaseViewModel {
  Map<String, dynamic>? profile;

  set setProfile(Map<String, dynamic> ui) {
    profile = ui;
    notifyListeners();
  }

  void init(ProfileUI profile) {
    setProfile = ProfileUI.toMap(profile);
  }

  void setNewValue(String flag, bool value) {
    List<String> profileKeys = profile!.keys.toList();

    Map<String, dynamic> scopedProfile = profile!;

    if (profileKeys.contains(flag)) {
      scopedProfile[flag] = value;

      setProfile = scopedProfile;
    }
  }
}
