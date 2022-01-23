import 'package:flutter/cupertino.dart';
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
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Image.network(
            radio!.nowPlaying.artUrl,
            width: 400,
            height: 400,
          ),
          Row(
            children: [
              Text(
                radio.nowPlaying.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 32, fontWeight: FontWeight.bold, height: 2),
              )
            ],
          ),
          Row(
            children: [
              Text(
                radio.nextPlaying.artist,
                style: const TextStyle(fontSize: 24),
              )
            ],
          ),
          // StreamBuilder(builder: ).
          const Expanded(
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Coming up:', style: TextStyle(fontSize: 24)))),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                title: Text(radio.nextPlaying.title),
                subtitle: Text(radio.nextPlaying.artist),
                tileColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                trailing: Image.network(radio.nextPlaying.artUrl),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  model.pauseUnpauseRadio();
                },
                icon: const Icon(Icons.play_arrow),
                iconSize: 50,
              ),
              IconButton(
                onPressed: () {
                  model.pauseUnpauseRadio();
                },
                icon: const Icon(Icons.pause),
                iconSize: 50,
              )
            ],
          )
        ],
      ),
    );
  }
}
