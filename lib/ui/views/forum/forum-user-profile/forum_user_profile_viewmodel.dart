import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:freecodecamp/models/forum_user_model.dart';
import 'package:freecodecamp/ui/views/forum/forum_connect.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import 'package:stacked_services/stacked_services.dart';

class ForumUserProfileViewModel extends BaseViewModel {
  late User _user;
  User get user => _user;

  late String _username;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final _dialogService = locator<DialogService>();

  bool _userLoaded = false;
  bool get userLoaded => _userLoaded;

  void initState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') as String;
    _username = username;
    _user = await fetchUser(username);
    notifyListeners();
  }

  Future<User> fetchUser(String? username) async {
    final response = await ForumConnect.connectAndGet('/u/$username');

    if (response.statusCode == 200) {
      _userLoaded = true;
      notifyListeners();
      return User.fromJson(jsonDecode(response.body));
    }
    throw Exception('could not load user data: ' + response.body.toString());
  }

  Future showEmailDialog() async {
    DialogResponse? response = await _dialogService.showCustomDialog(
        variant: DialogType.inputForm,
        title: 'Change Email',
        mainButtonTitle: 'Change Email',
        description:
            "We will send an email to that address. Please follow the confirmation instructions.",
        data: DialogType.authform);

    if (response!.confirmed) {
      String email = response.data;
      changeEmail(email);
    }
  }

  Future<void> changeProfilePicture() async {
    final ImagePicker _picker = ImagePicker();

    DialogResponse? response = await _dialogService.showCustomDialog(
        variant: DialogType.buttonForm,
        title: 'Change profile picture',
        description: 'please choose gallery or camera',
        mainButtonTitle: 'Gallery',
        secondaryButtonTitle: 'Camera',
        data: DialogType.buttonForm);

    if (response!.confirmed) {
      if (response.data == 'gallery') {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        final byteData = image?.readAsBytes();
        sendNewProfilePicture(byteData);
      } else if (response.data == 'camera') {
        final photo = await ImagePicker().pickImage(
            source: ImageSource.camera, maxWidth: 100, maxHeight: 100);
        Uint8List byteData = await File(photo!.path).readAsBytes();
        sendNewProfilePicture(byteData);
      } else {
        changeProfilePicture();
      }
    }
  }

  Future<void> sendNewProfilePicture(png) async {
    Map<String, dynamic> body = {
      "type": "avatar",
      "user_id": _user.userId,
      "files[]": png
    };

    dev.log('I got  called!!!');
    dev.log(body.toString());

    final response = await ForumConnect.connectAndPost('/uploads', {}, body);

    if (response.statusCode == 200) {
      dev.log("avatar successfully changed!");
      dev.log(response.body.toString());
    } else {
      dev.log(response.body.toString());
    }
  }

  Future<void> changeEmail(email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') as String;

    Map<String, dynamic> body = {"email": email};

    final response = await ForumConnect.connectAndPut(
        '/u/$username/preferences/email', body);

    if (response.statusCode == 200) {
      dev.log(response.body);
    } else {
      showEmailDialog();
      dev.log(response.body.toString());
    }
  }

  Future showNameDialog() async {
    DialogResponse? response = await _dialogService.showCustomDialog(
        variant: DialogType.inputForm,
        title: 'Change Name',
        mainButtonTitle: 'Change Name',
        description: "Your full name (optional)",
        data: DialogType.authform);

    if (response!.confirmed) {
      String name = response.data;
      changeName(name);
    }
  }

  Future<void> changeName(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') as String;

    Map<String, dynamic> body = {"name": name};

    final response = await ForumConnect.connectAndPut('/u/$username', body);

    if (response.statusCode == 200) {
      dev.log(response.body.toString());
      initState();
    } else {
      showEmailDialog();
      dev.log(response.body.toString());
    }
  }
}
