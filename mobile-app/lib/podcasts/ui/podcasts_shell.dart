import 'package:flutter/material.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/listen_header.dart';

class PodcastsShell extends StatelessWidget {
  const PodcastsShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      bottom: false,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => const [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: ListenHeader(isRadio: false),
            ),
          ),
        ],
        body: child,
      ),
    ),
    bottomNavigationBar: const AppNavigationFooter(
      selected: AppDestination.listen,
    ),
  );
}
