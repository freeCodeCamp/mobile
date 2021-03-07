import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'drawer_list_view_model.dart';

class DrawerListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerListViewModel>.reactive(
      builder: (BuildContext context, DrawerListViewModel viewModel, Widget _) {
        return ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(''),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/splash_screen.png')),
              ),
            ),
            ListTile(
              title: Text(
                'Training',
                style: TextStyle(color: Color(0xFF0a0a23)),
              ),
              onTap: () => viewModel.navigateToTraining(),
            ),
            ListTile(
              title: Text(
                'Forum',
                style: TextStyle(color: Color(0xFF0a0a23)),
              ),
              onTap: () => viewModel.navigateToForum(),
            ),
            ListTile(
              title: Text(
                'News',
                style: TextStyle(color: Color(0xFF0a0a23)),
              ),
              onTap: () => viewModel.navigateToNews(),
            ),
            ListTile(
              title: Text(
                'Radio',
                style: TextStyle(color: Color(0xFF0a0a23)),
              ),
              onTap: () => viewModel.navigateToRagio(),
            ),
            ListTile(
              title: Text(
                'FAQ',
                style: TextStyle(color: Color(0xFF0a0a23)),
              ),
              onTap: () => viewModel.navigateToFAQ(),
            ),
            ListTile(
              title: Text(
                'Donation',
                style: TextStyle(color: Color(0xFF0a0a23)),
              ),
              onTap: () => viewModel.navigateToDonation(),
            ),
          ],
        );
      },
      viewModelBuilder: () => DrawerListViewModel(),
    );
  }
}
