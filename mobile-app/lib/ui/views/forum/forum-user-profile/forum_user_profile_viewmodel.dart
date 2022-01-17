import 'dart:convert';
import 'dart:developer' as dev;
import 'package:dio/dio.dart' as dio;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:freecodecamp/models/forum/forum_user_model.dart';
import 'package:freecodecamp/ui/views/forum/forum_connect.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import 'package:stacked_services/stacked_services.dart';

class ForumUserProfileViewModel extends BaseViewModel {
  late User _user;
  User get user => _user;

  late String _baseUrl;
  String get baseUrl => _baseUrl;

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
    _baseUrl = await ForumConnect.getCurrentUrl();
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
            "We will send an email to your current address. Please follow the confirmation instructions.",
        data: DialogType.authform);

    if (response!.confirmed) {
      String email = response.data;
      changeEmail(email);
    }
  }

  Future<void> changeProfilePicture() async {
    DialogResponse? response = await _dialogService.showCustomDialog(
        variant: DialogType.buttonForm,
        title: 'Change profile picture',
        description: 'please choose gallery or camera',
        mainButtonTitle: 'Gallery',
        secondaryButtonTitle: 'Camera',
        data: DialogType.buttonForm);

    if (response!.confirmed) {
      if (response.data == 'gallery') {
        final image = await ImagePicker().pickImage(
            source: ImageSource.gallery, maxHeight: 300, maxWidth: 300);
        sendNewProfilePicture(image!.path);
      } else if (response.data == 'camera') {
        final photo = await ImagePicker().pickImage(
            source: ImageSource.camera, maxWidth: 300, maxHeight: 300);
        sendNewProfilePicture(photo!.path);
      } else {
        changeProfilePicture();
      }
    }
  }

  // dio has to be used for the image transfer, atleast it makes it easier.

  Future<void> sendNewProfilePicture(String cachePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await dotenv.load(fileName: ".env");

    dio.Response response;

    var dioInstnace = dio.Dio();

    dioInstnace.options.baseUrl = await ForumConnect.getCurrentUrl();

    dio.FormData formData = dio.FormData.fromMap({
      "type": "avatar",
      "user_id": _user.userId,
      "files[]": await dio.MultipartFile.fromFile(cachePath)
    });

    Map<String, dynamic> headers = await ForumConnect.setHeaderValues();

    try {
      response = await dioInstnace.post(
        "/uploads.json",
        data: formData,
        options: dio.Options(
          headers: headers,
        ),
        onSendProgress: (int sent, int total) {
          dev.log('$sent $total');
        },
      );

      if (response.statusCode == 200) {
        var uploadId = response.data["id"];
        refreshAvatar(uploadId);
      }
    } on dio.DioError catch (e) {
      if (e.response != null) {
        dev.log(e.response!.data.toString());
      } else {
        dev.log(e.message);
      }
    }
  }

  Future<void> refreshAvatar(int uploadId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiUsername = prefs.getString('username') as String;

    Map<String, dynamic> body = {
      "upload_id": uploadId.toString(),
      "type": "gravatar"
    };

    final response = await ForumConnect.connectAndPut(
        '/users/$apiUsername/preferences/avatar/pick', body);
    if (response.statusCode == 200) {
      initState();
      dev.log('avatar refreshed');
    } else {
      dev.log('an error occured');
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
