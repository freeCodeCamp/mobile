import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/profile/profile_viemodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
        body: Container(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: CachedNetworkImage(
                  imageUrl: model.user.picture,
                  height: MediaQuery.of(context).size.width * 0.4,
                  width: MediaQuery.of(context).size.width * 0.4,
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/placeholder-profile-img.png'),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '@${model.user.username}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoMono(
                    fontSize: 21.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  model.user.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoMono(fontSize: 16),
                ),
              ),
              model.user.location != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        model.user.location!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.robotoMono(fontSize: 16),
                      ),
                    )
                  : Container(),
              model.user.about != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        model.user.about!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.robotoMono(fontSize: 16),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.solidCalendar),
                    const SizedBox(width: 4),
                    Text(
                      'Joined ${DateFormat.yMMMM().format(model.user.joinDate)}',
                      style: GoogleFonts.robotoMono(fontSize: 16),
                    ),
                  ],
                ),
              ),
              // TODO: Top Contributor comes here
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '${model.user.points} total points',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoMono(fontSize: 16),
                ),
              ),
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
