
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

import 'episode_viewmodel.dart';

class EpisodeView extends StatelessWidget {
  final Episode episode;
  const EpisodeView({Key? key, required this.episode}) : super(key: key);

  final TextStyle _titleStyle =
      const TextStyle(color: Colors.white, fontSize: 20);

  final TextStyle _subTitleStyle =
      const TextStyle(color: Colors.white, fontSize: 14);

  final TextStyle _textStyle =
      const TextStyle(color: Colors.white, fontSize: 16);

  String _parseDuration(Duration dur) {
    if (dur.inMinutes > 59) {
      return '${episode.duration!.inMinutes ~/ 60} hr ${episode.duration!.inMinutes % 60} min';
    } else {
      return '${episode.duration!.inMinutes % 60} min';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EpisodeViewModel>.reactive(
      viewModelBuilder: () => EpisodeViewModel(episode),
      onModelReady: (model) => model.init(episode.contentUrl!),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0a0a23),
        ),
        backgroundColor: const Color(0xFF0a0a23),
        body: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.network(
                  'https://ssl-static.libsyn.com/p/assets/2/f/f/7/2ff7cc8aa33fe438/freecodecamp-square-logo-large-1400.jpg',
                  height: 250,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  episode.title,
                  style: _titleStyle,
                ),
                const SizedBox(
                  height: 7.5,
                ),
                Text(
                  DateFormat.yMMMd().format(episode.publicationDate!) +
                      ' • ' +
                      _parseDuration(episode.duration!),
                  style: _subTitleStyle,
                ),
                const SizedBox(
                  height: 7.5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextButton.icon(
                    onPressed: model.playBtnClick,
                    icon: Icon(
                      model.playing ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    label: Text(
                      model.playing ? 'Pause' : 'Play',
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xff3b3b4f)),
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xff2a2a40)),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextButton.icon(
                    onPressed: model.downloadBtnClick,
                    icon: const Icon(
                      Icons.download,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Download',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xff3b3b4f)),
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xff2a2a40)),
                    ),
                  ),
                ),
                Html(
                  data: episode.description,
                  shrinkWrap: true,
                  onLinkTap: (String? url, RenderContext context,
                      Map<String, String> attributes, dom.Element? element) {
                    launch(url!);
                  },
                  style: {
                    'body': Style(
                      fontSize: const FontSize(16),
                      color: Colors.white,
                      padding: EdgeInsets.zero,
                    )
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
