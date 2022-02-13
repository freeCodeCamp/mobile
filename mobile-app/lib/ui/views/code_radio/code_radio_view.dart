import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freecodecamp/models/code-radio/code_radio_model.dart';
import 'package:freecodecamp/ui/views/code_radio/code_radio_viemodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class CodeRadioView extends StatelessWidget {
  const CodeRadioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CodeRadioViewModel>.reactive(
        onModelReady: (model) {
          model.audioService.initAppStateObserver();
        },
        onDispose: (model) => {model.audioService.removeAppStateObserver()},
        viewModelBuilder: () => CodeRadioViewModel(),
        builder: (context, model, child) => Scaffold(
            backgroundColor: const Color(0xFF0a0a23),
            appBar: AppBar(
              title: const Text('CODE RADIO'),
            ),
            drawer: const DrawerWidgetView(),
            body: template(context, model)));
  }

  Widget template(BuildContext ctxt, CodeRadioViewModel model) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          StreamBuilder(
              stream: model.channel.stream,
              builder: (context, snapshot) {
                dev.log('REICEVED NEW DATA FROM WEBSOCKET');
                if (snapshot.hasData) {
                  CodeRadio radio =
                      CodeRadio.fromJson(jsonDecode(snapshot.data.toString()));

                  if (!model.audioService.player.playing &&
                      !model.stoppedManually) {
                    model.toggleRadio(radio);
                  }

                  model.setAndGetLastId(radio);

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        albumArt(ctxt, radio),
                        playingSong(radio, model),
                        nextSong(radio),
                        playPauseButton(model, ctxt)
                      ],
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              }),
        ],
      ),
    );
  }

  Widget albumArt(BuildContext ctxt, CodeRadio? radio) {
    var album = MediaQuery.of(ctxt).size;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            constraints: BoxConstraints(
                minHeight: album.height * 0.45,
                minWidth: album.width,
                maxHeight: album.height * 0.45,
                maxWidth: album.width),
            color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            child: Image.network(
              radio!.nowPlaying.artUrl,
              fit: BoxFit.cover,
            )),
        Text(
          radio.totalListeners.toString() + '\n' + 'Listening',
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Color.fromRGBO(1, 1, 1, 0.5),
              fontSize: 48,
              fontWeight: FontWeight.w800),
        )
      ],
    );
  }

  StreamBuilder<bool> playPauseButton(
      CodeRadioViewModel model, BuildContext ctxt) {
    return StreamBuilder(
        stream: model.audioService.player.playingStream,
        builder: (context, snapshot) {
          return Container(
            width: MediaQuery.of(ctxt).size.width,
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)),
                ),
                onPressed: () {
                  model.pauseUnpauseRadio();
                },
                icon: Icon(!model.audioService.player.playing
                    ? Icons.play_arrow
                    : Icons.pause),
                label: Text(
                    !model.audioService.player.playing ? 'PLAY' : 'PAUSE')),
          );
        });
  }

  Widget nextSong(CodeRadio? radio) {
    return ListTile(
      title: const Text('Next'),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              radio!.nextPlaying.title + '\n' + radio.nextPlaying.album,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      tileColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
      isThreeLine: true,
      leading: Image.network(radio.nextPlaying.artUrl),
    );
  }

  Widget playingSong(CodeRadio? radio, CodeRadioViewModel model) {
    if (model.timer != null) {
      model.timer!.cancel();
    }

    model.startProgressBar(radio!.elapsed, radio.duration);

    return Container(
      padding: const EdgeInsets.all(8),
      color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
      child: Column(
        children: [
          Text(
            radio.nowPlaying.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, height: 1.5),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  radio.nextPlaying.artist,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: StreamBuilder(
                stream: model.controller.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return LinearProgressIndicator(
                        value: radio.duration != 0
                            ? double.parse(snapshot.data.toString()) /
                                radio.duration
                            : 1);
                  }

                  return const LinearProgressIndicator(
                    value: 0,
                  );
                }),
          )
        ],
      ),
    );
  }
}
