import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/ui/views/profile/profile_viemodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFF0a0a23),
        appBar: AppBar(
          title: const Text('PROFILE'),
        ),
        drawer: const DrawerWidgetView(),
        body: FutureBuilder<FccUserModel>(
          future: model.auth.userModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            if (snapshot.hasData) {
              FccUserModel user = snapshot.data!;
              return Container(
                padding: const EdgeInsets.all(4),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: CachedNetworkImage(
                          imageUrl: user.picture,
                          height: MediaQuery.of(context).size.width * 0.4,
                          width: MediaQuery.of(context).size.width * 0.4,
                          errorWidget: (context, url, error) => Image.asset(
                              'assets/images/placeholder-profile-img.png'),
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
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          '@${user.username}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.robotoMono(
                            fontSize: 21.6,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          user.name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.robotoMono(
                              fontSize: 16, height: 1.25),
                        ),
                      ),
                      user.location != null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                user.location!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.robotoMono(
                                    fontSize: 16, height: 1.25),
                              ),
                            )
                          : Container(),
                      user.about != null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                user.about!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.robotoMono(
                                    fontSize: 16, height: 1.25),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(FontAwesomeIcons.solidCalendar,
                                size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Joined ${DateFormat.yMMMM().format(user.joinDate)}',
                              style: GoogleFonts.robotoMono(
                                  fontSize: 16, height: 1.25),
                            ),
                          ],
                        ),
                      ),
                      // TODO: Top Contributor comes here
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          '${user.points} total points',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.robotoMono(
                              fontSize: 16, height: 1.25),
                        ),
                      ),
                      // TODO: Add heatmap here
                      // TODO: Certifications here
                      // TODO: Timeline here
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No user data found'));
            }
          },
        ),
      ),
    );
  }
}
