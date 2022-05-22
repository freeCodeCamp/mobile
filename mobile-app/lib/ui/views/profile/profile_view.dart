import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/ui/views/profile/profile_viemodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  BoxBorder borderPicker(FccUserModel user) {
    if (user.isDonating && user.yearsTopContributor.isNotEmpty) {
      return Border.all(width: 5, color: const Color(0xFF9400D3));
    } else if (user.yearsTopContributor.isNotEmpty) {
      return Border.all(width: 5, color: const Color(0xFF198EEE));
    } else if (user.isDonating) {
      return Border.all(width: 5, color: const Color(0xFFFFBF00));
    } else {
      return Border.all(width: 5, color: const Color(0xFFD0D0D5));
    }
  }

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

              final hasModernCert = user.isRespWebDesignCert ||
                  user.is2018DataVisCert ||
                  user.isFrontEndLibsCert ||
                  user.isJsAlgoDataStructCert ||
                  user.isApisMicroservicesCert ||
                  user.isQaCertV7 ||
                  user.isInfosecCertV7 ||
                  user.isFullStackCert ||
                  user.isSciCompPyCertV7 ||
                  user.isDataAnalysisPyCertV7 ||
                  user.isMachineLearningPyCertV7 ||
                  user.isRelationalDatabaseCertV8;
              final hasLegacyCert = user.isFrontEndCert ||
                  user.isBackEndCert ||
                  user.isDataVisCert ||
                  user.isInfosecQaCert;
              final currentCerts = [
                {
                  'show': user.isRespWebDesignCert,
                  'title': 'Responsive Web Design Certification',
                  'certSlug': 'responsive-web-design',
                },
                {
                  'show': user.isJsAlgoDataStructCert,
                  'title':
                      'JavaScript Algorithms and Data Structures Certification',
                  'certSlug': 'javascript-algorithms-and-data-structures'
                },
                {
                  'show': user.isFrontEndLibsCert,
                  'title': 'Front End Development Libraries Certification',
                  'certSlug': 'front-end-development-libraries',
                },
                {
                  'show': user.is2018DataVisCert,
                  'title': 'Data Visualization Certification',
                  'certSlug': 'data-visualization',
                },
                {
                  'show': user.isApisMicroservicesCert,
                  'title': 'Back End Development and APIs Certification',
                  'certSlug': 'back-end-development-and-apis',
                },
                {
                  'show': user.isQaCertV7,
                  'title': ' Quality Assurance Certification',
                  'certSlug': 'quality-assurance-v7',
                },
                {
                  'show': user.isInfosecCertV7,
                  'title': 'Information Security Certification',
                  'certSlug': 'information-security-v7',
                },
                {
                  'show': user.isSciCompPyCertV7,
                  'title': 'Scientific Computing with Python Certification',
                  'certSlug': 'scientific-computing-with-python-v7',
                },
                {
                  'show': user.isDataAnalysisPyCertV7,
                  'title': 'Data Analysis with Python Certification',
                  'certSlug': 'data-analysis-with-python-v7',
                },
                {
                  'show': user.isMachineLearningPyCertV7,
                  'title': 'Machine Learning with Python Certification',
                  'certSlug': 'machine-learning-with-python-v7',
                },
                {
                  'show': user.isRelationalDatabaseCertV8,
                  'title': 'Relational Database Certification',
                  'certSlug': 'relational-database-v8',
                }
              ];
              final legacyCerts = [
                {
                  'show': user.isFrontEndCert,
                  'title': 'Front End Certification',
                  'certSlug': 'legacy-front-end'
                },
                {
                  'show': user.isBackEndCert,
                  'title': 'Back End Certification',
                  'certSlug': 'legacy-back-end'
                },
                {
                  'show': user.isDataVisCert,
                  'title': 'Data Visualization Certification',
                  'certSlug': 'legacy-data-visualization'
                },
                {
                  'show': user.isInfosecQaCert,
                  'title':
                      'Information Security and Quality Assurance Certification',
                  'certSlug': 'information-security-and-quality-assurance'
                },
                {
                  'show': user.isFullStackCert,
                  'title': 'Full Stack Certification',
                  'certSlug': 'full-stack'
                }
              ];

              return Container(
                padding: const EdgeInsets.all(4),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: borderPicker(user),
                          ),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          '@${user.username}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.robotoMono(
                            fontSize: 21.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          user.name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.robotoMono(
                              fontSize: 16, height: 1.25),
                        ),
                      ),
                      user.location != null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                user.location!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.robotoMono(
                                    fontSize: 16, height: 1.25),
                              ),
                            )
                          : Container(),
                      user.isDonating
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FaIcon(FontAwesomeIcons.solidHeart,
                                      size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Supporter',
                                    style: GoogleFonts.robotoMono(
                                        fontSize: 16, height: 1.25),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      user.about != null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                user.about!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.robotoMono(
                                    fontSize: 16, height: 1.25),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                      user.yearsTopContributor.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.award,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Top Contributor - ${user.yearsTopContributor.join(', ')}',
                                      style: GoogleFonts.robotoMono(
                                        fontSize: 16,
                                        height: 1.25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          '${user.points} total points',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.robotoMono(
                              fontSize: 16, height: 1.25),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: HeatMap(
                          startDate: Jiffy().subtract(months: 6).dateTime,
                          datasets: user.heatMapCal,
                          colorsets: const {
                            0: Color(0xFF2A2A40),
                            1: Color(0xFF858591),
                            4: Color(0xFFD0D0D5),
                            8: Colors.white,
                          },
                          defaultColor: const Color(0xFF2A2A40),
                          scrollable: true,
                          colorMode: ColorMode.color,
                          showColorTip: false,
                          onClick: (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 2),
                                content: Text(
                                  Intl.plural(
                                    user.heatMapCal[value] ?? 0,
                                    other:
                                        '${user.heatMapCal[value]} points on ${DateFormat.yMMMd().format(value)}',
                                    zero:
                                        '0 points on ${DateFormat.yMMMd().format(value)}',
                                    one:
                                        '1 point on ${DateFormat.yMMMd().format(value)}',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        // FCC uses below color
                        // color: Color(0xFF3B3B4F),
                        color: Colors.grey.shade600,
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 2),
                        child: Text(
                          'freeCodeCamp Certifications',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.robotoMono(
                            fontSize: 20,
                            height: 1.25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      hasModernCert
                          ? ListView(
                              padding: const EdgeInsets.all(4),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: currentCerts
                                  .map(
                                    (cert) => (cert['show'] as bool)
                                        ? SizedBox(
                                            height: 50,
                                            child: ListTile(
                                              title:
                                                  Text('View ${cert["title"]}'),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios_sharp,
                                                color: Colors.white,
                                              ),
                                              onTap: () => launch(
                                                '${model.auth.baseURL}/certification/${user.username}/${cert["certSlug"]}',
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  )
                                  .toList(),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                'No certifications have been earned under the current curriculum',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.robotoMono(
                                  fontSize: 16,
                                  height: 1.25,
                                ),
                              ),
                            ),
                      hasLegacyCert
                          ? Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 16, bottom: 2),
                                  child: Text(
                                    'Legacy Certifications',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.robotoMono(
                                      fontSize: 18,
                                      height: 1.25,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                ListView(
                                  padding: const EdgeInsets.all(4),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: legacyCerts
                                      .map(
                                        (cert) => (cert['show'] as bool)
                                            ? SizedBox(
                                                height: 50,
                                                child: ListTile(
                                                  title: Text(
                                                      'View ${cert["title"]}'),
                                                  trailing: const Icon(
                                                    Icons
                                                        .arrow_forward_ios_sharp,
                                                    color: Colors.white,
                                                  ),
                                                  onTap: () => launch(
                                                    '${model.auth.baseURL}/certification/${user.username}/${cert["certSlug"]}',
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      )
                                      .toList(),
                                ),
                              ],
                            )
                          : Container(),
                      Divider(
                        thickness: 2,
                        // FCC uses below color
                        // color: Color(0xFF3B3B4F),
                        color: Colors.grey.shade600,
                        height: 24,
                      ),
                      // TODO: Portfolio here
                      Divider(
                        thickness: 2,
                        // FCC uses below color
                        // color: Color(0xFF3B3B4F),
                        color: Colors.grey.shade600,
                        height: 24,
                      ),
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
