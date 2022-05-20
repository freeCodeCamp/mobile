import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/profile/profile_viemodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      onModelReady: (model) => model.initState(),
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFF0a0a23),
        appBar: AppBar(
          title: const Text('PROFILE'),
        ),
        drawer: const DrawerWidgetView(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: model.user.picture,
                height: MediaQuery.of(context).size.width * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Text('@${model.user.username}'),
              Text(model.user.name),
              model.user.location != null
                  ? Text(model.user.location!)
                  : Container(),
              model.user.about != null ? Text(model.user.about!) : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_month),
                  Text('Joined ${DateFormat.yMMMM().format(model.user.joinDate)}'),
                ],
              ),
              // TODO: Top Contributor comes here
              Text('${model.user.points} total points'),
              // TODO: Add heatmap here
              // TODO: Certifications here
              // TODO: Timeline here
            ],
          ),
        ),
      ),
    );
  }
}
