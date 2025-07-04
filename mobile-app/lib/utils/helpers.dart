import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> filesToMarkdown(Challenge challenge, String editorText) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final challengeFiles = challenge.files;
  final bool moreThanOneFile = challengeFiles.length > 1;
  String markdownStr = '\n';

  for (var challengeFile in challengeFiles) {
    final fileName = moreThanOneFile
        ? '/* file: ${challengeFile.name}.${challengeFile.ext} */\n'
        : '';
    final fileType = challengeFile.ext.name;
    final fileContent =
        prefs.getString('${challenge.id}.${challengeFile.name}') ??
            challengeFile.contents;
    markdownStr += '```$fileType\n$fileName$fileContent\n```\n\n';
  }

  return markdownStr;
}

Future<String> getDeviceInfo(BuildContext context) async {
  final deviceInfoPlugin = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final deviceInfo = await deviceInfoPlugin.androidInfo;
    return '${deviceInfo.model} - Android ${deviceInfo.version.release} - Android SDK ${deviceInfo.version.sdkInt}';
  } else if (Platform.isIOS) {
    final deviceInfo = await deviceInfoPlugin.iosInfo;
    return '${deviceInfo.model} - ${deviceInfo.systemName}${deviceInfo.systemVersion}';
  } else {
    return context.t.unrecognized_device;
  }
}
