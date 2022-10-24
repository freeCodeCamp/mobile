import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class BlockBuilderModel extends BaseViewModel {
  Future<bool> getBlockOpenState(Block block) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(block.blockName) ?? false;
  }
}
