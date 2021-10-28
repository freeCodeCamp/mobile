import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:freecodecamp/ui/views/settings/podcastSettings/podcast_settings_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PodcastSettingsView extends StatelessWidget {
  const PodcastSettingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PodcastSettingsViewModel>.reactive(
        viewModelBuilder: () => PodcastSettingsViewModel(),
        builder: (context, model, child) => Scaffold());
  }
}
