import 'package:flutter/material.dart';
import 'package:freecodecamp/models/code-radio/code_radio_model.dart';
import 'package:freecodecamp/ui/views/code_radio/code_radio_viemodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class CodeRadioView extends StatelessWidget {
  const CodeRadioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CodeRadioViewModel>.reactive(
        viewModelBuilder: () => CodeRadioViewModel(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: const Color(0xFF0a0a23),
              appBar: AppBar(
                title: const Text('CODE RADIO'),
              ),
              drawer: const DrawerWidgetView(),
              body: FutureBuilder<CodeRadio>(
                future: model.initRadio(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    CodeRadio? radio = snapshot.data;

                    return template(context, model, radio);
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ));
  }

  Widget template(
      BuildContext ctxt, CodeRadioViewModel model, CodeRadio? radio) {
    double artSize = MediaQuery.of(ctxt).size.width * 0.75;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
                minHeight: artSize,
                minWidth: artSize,
                maxHeight: artSize,
                maxWidth: artSize),
            color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            child: Image.network(
              radio!.nowPlaying.artUrl,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            radio.nowPlaying.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, height: 2),
          ),
          Row(
            children: [
              Text(
                radio.nextPlaying.artist,
                style: const TextStyle(fontSize: 24),
              )
            ],
          ),
          StreamBuilder(
              stream: model.player.positionStream,
              builder: (context, snapshot) {
                model.desyncListener(
                    model.player.position.inSeconds, radio.elapsed);
                if (model.player.position.inSeconds == radio.duration) {
                  model.getNextSong();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: LinearProgressIndicator(
                      value: model.player.position.inSeconds /
                          (radio.duration == 0 ? 1 : radio.duration - 10)),
                );
              }),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ListTile(
              title: const Text('Next'),
              subtitle: Row(
                children: [
                  Expanded(
                    child: Text(
                      radio.nextPlaying.title + "\n" + radio.nextPlaying.album,
                    ),
                  ),
                ],
              ),
              tileColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              isThreeLine: true,
              leading: Image.network(radio.nextPlaying.artUrl),
            ),
          ),
          Container(
            width: MediaQuery.of(ctxt).size.width,
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)),
                ),
                onPressed: () {
                  model.pauseUnpauseRadio(radio);
                },
                icon:
                    Icon(model.player.playing ? Icons.play_arrow : Icons.pause),
                label: const Text('PAUSE')),
          )
        ],
      ),
    );
  }
}
