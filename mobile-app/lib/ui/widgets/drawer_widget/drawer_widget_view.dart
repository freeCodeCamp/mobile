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
          color: const Color(0xFF0a0a23),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Image.asset(
                      'assets/images/freecodecamp-banner.png',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 28.0),
                      child: Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DrawerButton(
                      component: 'NEWS',
                      icon: Icons.forum_outlined,
                      route: () {
                        model.routeComponent('NEWS', context);
                      },
                    ),
                    buildDivider(),
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
                    buildDivider(),
                    DrawerButton(
                      component: 'PODCAST',
                      icon: Icons.podcasts_outlined,
                      route: () {
                        model.routeComponent('PODCAST', context);
                      },
                    ),
                    buildDivider(),
                    DrawerButton(
                      component: 'RADIO',
                      icon: Icons.radio,
                      route: () {
                        model.routeComponent('CODERADIO', context);
                      },
                    ),
                    buildDivider(),
                    const WebButton(
                      component: 'DONATE',
                      url: 'https://www.freecodecamp.org/donate/',
                      icon: Icons.favorite,
                    ),
                    buildDivider(),
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
