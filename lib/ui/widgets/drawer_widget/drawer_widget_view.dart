import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class DrawerWidgetView extends StatelessWidget {
  const DrawerWidgetView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerWidgtetViewModel>.reactive(
      viewModelBuilder: () => DrawerWidgtetViewModel(),
      builder: (context, model, child) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(25),
                        child: Text(
                          'MENU',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0a0a23),
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: navButtonWidget(
                        'NEWS',
                        'https://www.google.com/',
                        const Icon(
                          Icons.article,
                          size: 70,
                        ),
                        false,
                        model,
                        context),
                  ),
                  Expanded(
                    child: navButtonWidget(
                        'FORUM',
                        '',
                        const Icon(
                          Icons.forum_outlined,
                          size: 70,
                        ),
                        false,
                        model,
                        context),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: navButtonWidget(
                          'PODCAST',
                          '',
                          const Icon(
                            Icons.podcasts_outlined,
                            size: 70,
                          ),
                          false,
                          model,
                          context)),
                  Expanded(
                      child: navButtonWidget(
                          'RADIO',
                          'https://coderadio.freecodecamp.org/',
                          const Icon(
                            Icons.radio,
                            size: 70,
                          ),
                          true,
                          model,
                          context)),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: navButtonWidget(
                          'DONATE',
                          'https://www.freecodecamp.org/donate/',
                          const Icon(
                            Icons.favorite,
                            size: 70,
                          ),
                          true,
                          model,
                          context)),
                  Expanded(
                    child: navButtonWidget(
                        'SETTINGS',
                        'https://www.google.com/',
                        const Icon(
                          Icons.settings,
                          size: 70,
                        ),
                        false,
                        model,
                        context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InkWell navButtonWidget(String text, url, Icon icon, bool isWebComponent,
    DrawerWidgtetViewModel model, context) {
  return InkWell(
    onTap: () {
      dev.log(text);
      if (isWebComponent) {
        model.goToBrowser(url);
      } else {
        model.navNonWebComponent(text, context);
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(0xD0, 0xD0, 0xD5, 1),
          border: Border.all(color: Colors.black, width: 3),
        ),
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
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
