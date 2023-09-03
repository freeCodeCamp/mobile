import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/code-radio/code_radio_model.dart';
import 'package:freecodecamp/ui/views/code_radio/code_radio_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class CodeRadioView extends StatelessWidget {
  const CodeRadioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CodeRadioViewModel>.reactive(
      viewModelBuilder: () => CodeRadioViewModel(),
      onViewModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFF0a0a23),
        appBar: AppBar(
          title: const Text('CODE RADIO'),
        ),
        drawer: const DrawerWidgetView(),
        body: template(context, model),
      ),
    );
  }

  Widget template(BuildContext ctxt, CodeRadioViewModel model) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          StreamBuilder(
            stream: model.webSocketController.stream.where(
                (event) => event != {} && jsonDecode(event).containsKey('pub')),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = jsonDecode(snapshot.data.toString());

                CodeRadio radio = CodeRadio.fromJson(data['pub']['data']['np']);

                if (!model.audioService.isPlaying('coderadio') &&
                    !model.stoppedManually) {
                  model.toggleRadio(radio);
                }

                model.setAndGetLastId(radio);

                return Expanded(
                  child: Column(
                    children: [
                      albumArt(ctxt, radio),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: playingSong(radio, model),
                      ),
                      if (MediaQuery.of(context).size.height > 600)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: nextSong(radio, ctxt),
                        ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: playPauseButton(model, ctxt),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    context.t.coderadio_unable_to_load,
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
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
          ),
        ),
        Text(
          ctxt.t.coderadio_listening(
            radio.totalListeners.toString(),
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromRGBO(1, 1, 1, 0.5),
            fontSize: 36,
            fontWeight: FontWeight.w800,
          ),
        )
      ],
    );
  }

  StreamBuilder playPauseButton(CodeRadioViewModel model, BuildContext ctxt) {
    return StreamBuilder(
      stream: model.audioService.playbackState.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if(!snapshot.data.playing) {
            model.stoppedManually = true;
          }
          return ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)),
            ),
            onPressed: () {
              model.pauseUnpauseRadio();
            },
            icon: Icon(!snapshot.data.playing ? Icons.play_arrow : Icons.pause),
            label: Text(
              !snapshot.data.playing
                  ? ctxt.t.coderadio_play
                  : ctxt.t.coderadio_pause,
            ),
          );
        }
        return ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)),
          ),
          onPressed: () {
            model.pauseUnpauseRadio();
          },
          icon: Icon(model.stoppedManually ? Icons.play_arrow : Icons.pause),
          label: Text(
            model.stoppedManually
                ? ctxt.t.coderadio_play
                : ctxt.t.coderadio_pause,
          ),
        );
      },
    );
  }

  Widget nextSong(CodeRadio? radio, BuildContext ctxt) {
    return ListTile(
      title: Text(ctxt.t.coderadio_next_song),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              '${radio!.nextPlaying.title}\n${radio.nextPlaying.album}',
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
              stream: model.audioStateController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return LinearProgressIndicator(
                    value: radio.duration != 0
                        ? double.parse(snapshot.data.toString()) /
                            radio.duration
                        : 1,
                  );
                }

                return const LinearProgressIndicator(
                  value: 0,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
