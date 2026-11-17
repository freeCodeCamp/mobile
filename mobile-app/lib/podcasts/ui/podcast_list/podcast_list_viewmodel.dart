import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/services/api_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'podcast_list_viewmodel.g.dart';

@Riverpod(retry: noRetry)
Future<List<Podcast>> podcastList(Ref ref) =>
    ref.watch(podcastApiServiceProvider).getPodcasts();
