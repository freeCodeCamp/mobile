import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_viewmodel.dart';
import 'package:stacked/stacked.dart';

class DrawerWidgetView extends StatelessWidget {
  const DrawerWidgetView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const iconsize = 47.0;
    return ViewModelBuilder<DrawerWidgtetViewModel>.reactive(
      viewModelBuilder: () => DrawerWidgtetViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Drawer(
        child: Container(
          color: const Color(0xFF0a0a23),
          child: ListView(
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/freecodecamp-banner.png',
                      ),
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
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
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
              buildDivider(),
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
              buildDivider(),
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
              buildDivider(),
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
              buildDivider(),
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
              buildDivider(),
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

Widget buildDivider() {
  return 
  Divider(
    color: Colors.white.withOpacity(0.12),
    indent: 16,
    endIndent: 16,
    thickness: 1,
  );
}

Widget navButtonWidget(String text, url, Icon icon, bool isWebComponent,
    DrawerWidgtetViewModel model, context) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: ListTile(
      dense: true,
     
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
