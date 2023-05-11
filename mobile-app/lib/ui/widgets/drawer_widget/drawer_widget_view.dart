import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';

import 'package:freecodecamp/models/main/user_model.dart';

import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_tile.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_web_buttton.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_viewmodel.dart';
import 'package:stacked/stacked.dart';

class DrawerWidgetView extends StatelessWidget {
  const DrawerWidgetView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerWidgtetViewModel>.reactive(
      viewModelBuilder: () => DrawerWidgtetViewModel(),
      onViewModelReady: (model) => model.initState(),
      builder: (context, model, child) => Drawer(
        child: Container(
          color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
          child: Column(
            children: [
              Expanded(
                child: ScrollShadow(
                  controller: model.scrollController,
                  color: Colors.black,
                  child: ListView(
                    controller: model.scrollController,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Image.asset(
                          'assets/images/placeholder-profile-img.png',
                          width: 75,
                          height: 75,
                        ),
                        title: model.loggedIn
                            ? FutureBuilder(
                                future: model.auth.userModel,
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

                                  return const Text('Anonymous user');
                                })
                            : const Text('Anonymous user'),
                        subtitle: Text(model.loggedIn
                            ? 'Our coolest Camper'
                            : 'login to save your progress'),
                        isThreeLine: true,
                        onTap: () {
                          if (model.loggedIn) {
                            model.routeComponent('PROFILE', context);
                          }
                        },
                      ),
                      buildDivider(),
                      DrawerTile(
                        component: 'TUTORIALS',
                        icon: Icons.forum_outlined,
                        route: () {
                          model.routeComponent('NEWS', context);
                        },
                      ),
                      DrawerTile(
                        component: 'LEARN',
                        icon: '',
                        route: () {
                          model.routeComponent('LEARN', context);
                        },
                      ),
                      DrawerTile(
                        component: 'PODCASTS',
                        icon: Icons.podcasts_outlined,
                        route: () {
                          model.routeComponent('PODCAST', context);
                        },
                      ),
                      if (!Platform.isIOS)
                        DrawerTile(
                          component: 'CODE RADIO',
                          icon: Icons.radio,
                          route: () {
                            model.routeComponent('CODERADIO', context);
                          },
                        ),
                      buildDivider(),
                      const CustomTabButton(
                        component: 'PRIVACY',
                        icon: Icons.info_outline,
                        url:
                            'https://www.freecodecamp.org/news/privacy-policy/',
                      ),
                      const CustomTabButton(
                        component: 'DONATE',
                        url: 'https://www.freecodecamp.org/donate/',
                        icon: Icons.favorite,
                      ),
                      buildDivider(),
                      DrawerTile(
                          component: model.loggedIn ? 'LOG OUT' : 'LOGIN',
                          icon: model.loggedIn ? Icons.logout : Icons.login,
                          textColor: model.loggedIn
                              ? const Color.fromARGB(255, 230, 59, 59)
                              : null,
                          route: () {
                            model.loggedIn
                                ? model.auth.logout()
                                : model.routeComponent('LOGIN', context);
                          })
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: 10),
                child: Text(
                  'freeCodeCamp is a donor-supported tax-exempt 501(c)(3) nonprofit organization',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Colors.white70),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildDivider() {
  return Divider(
    color: Colors.white.withOpacity(0.12),
    indent: 16,
    endIndent: 16,
    thickness: 1,
  );
}
