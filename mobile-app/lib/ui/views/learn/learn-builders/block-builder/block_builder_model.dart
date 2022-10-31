import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class BlockBuilderModel extends BaseViewModel {
  // This provides the state when a new instance of a block is created
  // if the cache is empty it will return false

  Future<bool> getBlockOpenState(Block block) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(block.blockName) ?? false;
  }
}
