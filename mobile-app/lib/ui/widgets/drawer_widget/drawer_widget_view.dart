import 'package:flutter/material.dart';
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
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Drawer(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Color(0xFF0a0a23))),
            title: const Text(
              'MENU',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0a0a23),
                fontSize: 18,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                model.inDevelopmentMode || model.showForum
                    ? navButtonWidget(
                        'FORUM',
                        "Ask questions, share tips, projects etc and get feedbacks",
                        '',
                        const Icon(
                          Icons.forum_outlined,
                          color: Colors.white,
                          size: 40,
                        ),
                        false,
                        model,
                        context)
                    : navButtonWidget(
                        'LEARN',
                        "Welcome to freeCodeCamp.org",
                        'https://www.freecodecamp.org/learn/',
                        const Icon(
                          Icons.local_fire_department_sharp,
                          color: Colors.white,
                          size: 40,
                        ),
                        true,
                        model,
                        context),
                navButtonWidget(
                    'PODCAST',
                    "Learn to code with free online courses, programming projects and interview preparation.",
                    '',
                    const Icon(
                      Icons.podcasts_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                    false,
                    model,
                    context),
                navButtonWidget(
                    'RADIO',
                    "Welcome to Code Radio.24/7 music designed for coding.",
                    'https://coderadio.freecodecamp.org/',
                    const Icon(
                      Icons.radio,
                      color: Colors.white,
                      size: 40,
                    ),
                    true,
                    model,
                    context),
                navButtonWidget(
                    'DONATE',
                    "When you donate to freeCodeCamp, you help people learn new skills and provide for their families",
                    'https://www.freecodecamp.org/donate/',
                    const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 40,
                    ),
                    true,
                    model,
                    context),
                model.inDevelopmentMode
                    ? navButtonWidget(
                        'SETTINGS',
                        "",
                        'https://www.google.com/',
                        const Icon(
                          Icons.settings,
                          color: Colors.black,
                          size: 40,
                        ),
                        false,
                        model,
                        context)
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

InkWell navButtonWidget(String text, String sub, url, Icon icon,
    bool isWebComponent, DrawerWidgtetViewModel model, context) {
  return InkWell(
    onTap: () {
      if (isWebComponent) {
        model.goToBrowser(url);
      } else {
        model.navNonWebComponent(text, context);
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 60,
            decoration: const BoxDecoration(
                color: Color(0xFF0a0a23),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: icon,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sub,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}
