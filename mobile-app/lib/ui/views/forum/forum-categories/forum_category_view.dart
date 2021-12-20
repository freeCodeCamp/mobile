import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/models/forum_post_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-categories/forum_category_builder.dart';
import 'package:freecodecamp/ui/views/forum/forum-categories/forum_category_viewmodel.dart';
import 'package:freecodecamp/ui/views/forum/forum-login/forum_login_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-search/forum_search_view.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
class ForumCategoryView extends StatelessWidget {
  ForumCategoryView({Key? key}) : super(key: key);

  List views = <dynamic>[
    const ForumLoginView(fromCreatePost: true),
    const ForumCategoryBuilder(),
    const ForumSearchView(),
  ];

  List titles = <Text>[
    const Text('New topic'),
    const Text('Categories'),
    const Text('Search topics')
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumCategoryViewModel>.reactive(
        viewModelBuilder: () => ForumCategoryViewModel(),
        onModelReady: (model) => model.initState(),
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: titles.elementAt(model.index),
              centerTitle: true,
              actions: [
                model.isLoggedIn
                    ? model.userProfileIsLoading
                        ? Image.asset(
                            'assets/images/placeholder-profile-img.png')
                        : IconButton(
                            onPressed: () => model.goToUserProfile(),
                            icon: Image.network(PostModel.parseProfileAvatar(
                                model.baseUrl + model.user.profilePicture)))
                    : Container()
              ],
            ),
            drawer: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const DrawerWidgetView(),
            ),
            body: views.elementAt(model.index),
            bottomNavigationBar: BottomNavigationBar(
              // ignore: prefer_const_literals_to_create_immutables
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add,
                    ),
                    label: 'New'),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.article), label: 'Categories'),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.search_outlined), label: 'Search')
              ],
              currentIndex: model.index,
              onTap: model.onTapped,
            )));
  }
}
