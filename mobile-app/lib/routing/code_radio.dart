import 'package:flutter/material.dart';
import 'package:freecodecamp/code_radio/ui/player/player_view.dart';
import 'package:go_router/go_router.dart';

part 'code_radio.g.dart';

const codeRadioPath = '/code-radio';

@TypedGoRoute<CodeRadioRoute>(path: codeRadioPath)
class CodeRadioRoute extends GoRouteData with $CodeRadioRoute {
  const CodeRadioRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CodeRadioPlayerView();
}
