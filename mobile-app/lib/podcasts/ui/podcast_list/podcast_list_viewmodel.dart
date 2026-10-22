import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'podcast_list_viewmodel.g.dart';

@riverpod
Future<List<Podcast>> podcastList(Ref ref) =>
    ref.watch(podcastApiServiceProvider).getPodcasts();
