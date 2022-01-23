import 'dart:convert';

import 'package:freecodecamp/models/code-radio/code_radio_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class CodeRadioViewModel extends BaseViewModel {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<CodeRadio> initRadio() async {
    final http.Response response = await http.get(Uri.parse(
        'https://coderadio-admin.freecodecamp.org/api/live/nowplaying/coderadio'));

    if (response.statusCode == 200) {
      return CodeRadio.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}
