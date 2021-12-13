import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_viewmodel.dart';
import 'package:stacked/stacked.dart';

class DrawerWidgetView extends StatelessWidget {
  const DrawerWidgetView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const iconsize = 44.0;
    return ViewModelBuilder<DrawerWidgtetViewModel>.reactive(
      viewModelBuilder: () => DrawerWidgtetViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Drawer(
        child: Container(
          color: const Color(0xFF0a0a23),
          width: MediaQuery.of(context).size.width * 0.8,
          child: ListView(
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/app-logo.png',
                      width: iconsize * 2,
                      height: iconsize * 2,
                    ),
                    const Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              navButtonWidget(
                  'News',
                  '',
                  const Icon(
                    Icons.article,
                    size: iconsize,
                  ),
                  false,
                  model,
                  context),
              model.inDevelopmentMode || model.showForum
                  ? navButtonWidget(
                      'Forum',
                      '',
                      const Icon(
                        Icons.forum_outlined,
                        size: iconsize,
                      ),
                      false,
                      model,
                      context)
                  : navButtonWidget(
                      'Learn',
                      'https://www.freecodecamp.org/learn/',
                      const Icon(
                        Icons.local_fire_department_sharp,
                        size: iconsize,
                      ),
                      true,
                      model,
                      context),
              navButtonWidget(
                  'Podcast',
                  '',
                  const Icon(
                    Icons.podcasts_outlined,
                    size: iconsize,
                  ),
                  false,
                  model,
                  context),
              navButtonWidget(
                  'Radio',
                  'https://coderadio.freecodecamp.org/',
                  const Icon(
                    Icons.radio,
                    size: iconsize,
                  ),
                  true,
                  model,
                  context),
              navButtonWidget(
                  'Donate',
                  'https://www.freecodecamp.org/donate/',
                  const Icon(
                    Icons.favorite,
                    size: iconsize,
                  ),
                  true,
                  model,
                  context),
              model.inDevelopmentMode
                  ? navButtonWidget(
                      'Settings',
                      'https://www.google.com/',
                      const Icon(
                        Icons.settings,
                        size: iconsize,
                      ),
                      false,
                      model,
                      context)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget navButtonWidget(String text, url, Icon icon, bool isWebComponent,
    DrawerWidgtetViewModel model, context) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: ListTile(
      onTap: () {
        if (isWebComponent) {
          model.goToBrowser(url);
        } else {
          model.navNonWebComponent(text, context);
        }
      },
      leading: Icon(
        icon.icon,
        color: Colors.white,
      ),
      title: Text(
        text,
        style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            letterSpacing: 0.5),
      ),
    ),
  );
}
