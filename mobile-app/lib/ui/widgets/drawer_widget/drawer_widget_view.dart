import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_tile.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_web_buttton.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_viewmodel.dart';

class DrawerWidgetView extends ConsumerStatefulWidget {
  const DrawerWidgetView({
    super.key,
  });

  @override
  ConsumerState<DrawerWidgetView> createState() => _DrawerWidgetViewState();
}

class _DrawerWidgetViewState extends ConsumerState<DrawerWidgetView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(drawerWidgetProvider.notifier).initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(drawerWidgetProvider);
    final notifier = ref.read(drawerWidgetProvider.notifier);

    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Container(
        color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
        child: Column(
          children: [
            Expanded(
              child: ScrollShadow(
                color: Colors.black,
                child: ListView(
                  controller: notifier.scrollController,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Image.asset(
                        'assets/images/placeholder-profile-img.png',
                        width: 75,
                        height: 75,
                      ),
                      title: state.loggedIn
                          ? FutureBuilder(
                              future: notifier.auth.userModel,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  FccUserModel user =
                                      snapshot.data as FccUserModel;
                                  return Text(
                                    user.name.isEmpty
                                        ? user.username
                                        : user.name,
                                  );
                                }

                                return Text(
                                  context.t.anonymous_user,
                                );
                              })
                          : Text(
                              context.t.anonymous_user,
                            ),
                      subtitle: Text(
                        state.loggedIn
                            ? context.t.coolest_camper
                            : context.t.login_save_progress,
                      ),
                      isThreeLine: true,
                      onTap: () {
                        if (state.loggedIn) {
                          notifier.routeComponent('PROFILE', context);
                        }
                      },
                    ),
                    buildDivider(),
                    DrawerTile(
                      key: const Key('daily-challenges'),
                      component: 'DAILY CHALLENGES',
                      icon: Icons.extension,
                      route: () {
                        notifier.routeComponent('DAILY_CHALLENGES', context);
                      },
                    ),
                    DrawerTile(
                      key: const Key('learn'),
                      component: 'LEARN',
                      icon: '',
                      route: () {
                        notifier.routeComponent('LEARN', context);
                      },
                    ),
                    DrawerTile(
                      key: const Key('news'),
                      component: 'TUTORIALS',
                      icon: Icons.forum_outlined,
                      route: () {
                        notifier.routeComponent('NEWS', context);
                      },
                    ),
                    DrawerTile(
                      key: const Key('podcasts'),
                      component: 'PODCASTS',
                      icon: Icons.podcasts_outlined,
                      route: () {
                        notifier.routeComponent('PODCAST', context);
                      },
                    ),
                    if (!Platform.isIOS)
                      DrawerTile(
                        key: const Key('code-radio'),
                        component: 'CODE RADIO',
                        icon: Icons.radio,
                        route: () {
                          notifier.routeComponent('CODERADIO', context);
                        },
                      ),
                    buildDivider(),
                    const CustomTabButton(
                      key: Key('donate'),
                      component: 'DONATE',
                      url: 'https://www.freecodecamp.org/donate/',
                      icon: Icons.favorite,
                    ),
                    DrawerTile(
                      key: const Key('settings'),
                      component: 'SETTINGS',
                      icon: Icons.settings,
                      route: () {
                        notifier.routeComponent('SETTINGS', context);
                      },
                    ),
                    buildDivider(),
                    const CustomTabButton(
                      key: Key('report-issue'),
                      component: 'REPORT AN ISSUE',
                      url: 'https://github.com/freeCodeCamp/mobile',
                      icon: Icons.bug_report,
                    ),
                    DrawerTile(
                        key: const Key('auth'),
                        component: state.loggedIn
                            ? context.t.logout
                            : context.t.login,
                        icon: state.loggedIn ? Icons.logout : Icons.login,
                        textColor: state.loggedIn
                            ? const Color.fromARGB(255, 230, 59, 59)
                            : null,
                        route: () {
                          state.loggedIn
                              ? notifier.auth.logout()
                              : notifier.routeComponent('LOGIN', context);
                        }),
                  ],
                ),
              ),
            ),
            const SafeArea(
              minimum: EdgeInsets.only(bottom: 16),
              child: Text(
                'freeCodeCamp is a donor-supported tax-exempt 501(c)(3) nonprofit organization',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.white70),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildDivider() {
  return Divider(
    color: Colors.white.withValues(alpha: 0.12),
    indent: 16,
    endIndent: 16,
    thickness: 1,
  );
}
