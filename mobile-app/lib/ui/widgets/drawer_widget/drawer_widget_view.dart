import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_button.dart';
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
      builder: (context, model, child) => Drawer(
        child: Container(
          color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Image.asset(
                        'assets/images/placeholder-profile-img.png',
                        width: 75,
                        height: 75,
                      ),
                      title: const Text('Anonymous user'),
                      subtitle: const Text('login to save your progress'),
                      isThreeLine: true,
                    ),
                    buildDivider(),
                    DrawerButton(
                      component: 'NEWS',
                      icon: Icons.forum_outlined,
                      route: () {
                        model.routeComponent('NEWS', context);
                      },
                    ),
                    model.showForum
                        ? DrawerButton(
                            component: 'FORUM',
                            icon: Icons.forum_outlined,
                            route: () {
                              model.routeComponent('FORUM', context);
                            },
                          )
                        : DrawerButton(
                            component: 'LEARN',
                            icon: Icons.local_fire_department_sharp,
                            route: () {
                              model.routeComponent('LEARN', context);
                            }),
                    DrawerButton(
                      component: 'PODCAST',
                      icon: Icons.podcasts_outlined,
                      route: () {
                        model.routeComponent('PODCAST', context);
                      },
                    ),
                    DrawerButton(
                      component: 'RADIO',
                      icon: Icons.radio,
                      route: () {
                        model.routeComponent('CODERADIO', context);
                      },
                    ),
                    const WebButton(
                      component: 'DONATE',
                      url: 'https://www.freecodecamp.org/donate/',
                      icon: Icons.favorite,
                    ),
                    buildDivider(),
                    DrawerButton(
                      component: 'LOGIN',
                      icon: Icons.login,
                      route: () {
                        model.routeComponent('LOGIN', context);
                      },
                    )
                  ],
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
