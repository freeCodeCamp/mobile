import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freecodecamp/widgets/dumb_widgets/custom_web/custom_web_widget.dart';
import 'package:freecodecamp/widgets/dumb_widgets/navigation_controls/navigation_controls_widget.dart';
import 'package:freecodecamp/widgets/smart_widgets/drawer_list/drawer_list_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'donation_view_model.dart';

class DonationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DonationViewModel>.reactive(
      builder: (BuildContext context, DonationViewModel viewModel, Widget _) {
        final Completer<WebViewController> _controller =
            Completer<WebViewController>();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF0a0a23),
            actions: <Widget>[
              NavigationControls(_controller.future),
            ],
          ),
          drawer: Drawer(
            child: DrawerListWidget(),
          ),
          body: Builder(builder: (BuildContext context) {
            return CustomWebWidget(
              controller: _controller,
              url: 'https://www.freecodecamp.org/donate/',
            );
          }),
        );
      },
      viewModelBuilder: () => DonationViewModel(),
    );
  }
}
