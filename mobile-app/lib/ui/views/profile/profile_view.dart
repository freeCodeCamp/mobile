import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/ui/views/profile/profile_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

Map<String, int> calculateStreak(FccUserModel user) {
  int longest = 0;
  int current = 0;

  user.heatMapCal.forEach((date, value) {
    if (user.heatMapCal.containsKey(date.subtract(const Duration(days: 1)))) {
      current++;
    } else {
      if (current > longest) {
        longest = current;
      }
      current = 1;
    }
  });

  return {
    'longest': longest,
    'current': current,
  };
}

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
          title: Text(context.t.profile_title),
        ),
        drawer: const DrawerWidgetView(),
        body: FutureBuilder<FccUserModel>(
          future: model.auth.userModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
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

              final streak = calculateStreak(user);

              return Container(
                padding: const EdgeInsets.all(4),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: borderPicker(user),
                            ),
                            child: user.picture == ''
                                ? Image.asset(
                                    'assets/images/placeholder-profile-img.png',
                                    height: MediaQuery.of(context).size.width *
                                        0.25,
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: user.picture,
                                    height: MediaQuery.of(context).size.width *
                                        0.25,
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            'assets/images/placeholder-profile-img.png'),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              child: ListTile(
                                title: Text('@${user.username}',
                                    style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700)),
                                subtitle: Text(
                                  user.name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      buildDivider(),
                      ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          user.location != null
                              ? ListTile(
                                  leading: const Icon(Icons.location_on),
                                  title: Text(
                                    user.location as String,
                                  ))
                              : Container(),
                          user.isDonating
                              ? ListTile(
                                  leading: const Icon(Icons.favorite),
                                  title: Text(
                                    context.t.profile_supporter,
                                  ),
                                )
                              : Container(),
                          user.about != null
                              ? ListTile(
                                  leading: const Icon(Icons.chat_bubble),
                                  title: Text(
                                    user.about as String,
                                  ),
                                )
                              : Container(),
                          ListTile(
                            leading: const Icon(Icons.calendar_month),
                            title: Text(
                              context.t.profile_join_date(
                                Jiffy.parseFromDateTime(user.joinDate).yMMMM,
                              ),
                            ),
                          )
                        ],
                      ),
                      buildDivider(),
                      ListTile(
                        leading: const Icon(Icons.local_fire_department_sharp),
                        title: Text(
                          context.t.profile_points(
                            user.points.toString(),
                          ),
                        ),
                      ),
                      HeatMap(
                        startDate: Jiffy.now().subtract(months: 3).dateTime,
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
                                context.t.profile_points_on_date(
                                  (user.heatMapCal[value] ?? 0),
                                  Jiffy.parseFromDateTime(value).yMMMd,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          context.t.profile_longest_streak(
                            streak['longest'] ?? 0,
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, height: 1.25),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Text(
                          context.t.profile_current_streak(
                            streak['current'] ?? 0,
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, height: 1.25),
                        ),
                      ),
                      buildDivider(),
                      CertificationWidget(
                        user: user,
                        hasModernCert: hasModernCert,
                        hasLegacyCert: hasLegacyCert,
                        currentCerts: currentCerts,
                        legacyCerts: legacyCerts,
                      ),
                      user.portfolio.isNotEmpty
                          ? PortfolioWidget(user: user)
                          : Container(),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Text(
                  context.t.profile_no_userdata.toString(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class CertificationWidget extends StatelessWidget {
  const CertificationWidget(
      {Key? key,
      required this.user,
      required this.hasModernCert,
      required this.hasLegacyCert,
      required this.currentCerts,
      required this.legacyCerts})
      : super(key: key);

  final FccUserModel user;
  final bool hasModernCert;
  final bool hasLegacyCert;
  final List currentCerts;
  final List legacyCerts;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, child) => Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 2),
            child: Text(
              key: ValueKey('certification_title'),
              'freeCodeCamp Certifications',
              textAlign: TextAlign.center,
              style: TextStyle(
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
                                  title: Text(
                                    context.t.profile_view_cert(
                                      cert['certTitle'].toString(),
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    color: Colors.white,
                                  ),
                                  onTap: () => launchUrl(
                                    Uri.parse(
                                      '${AuthenticationService.baseURL}/certification/${user.username}/${cert["certSlug"]}',
                                    ),
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
                    context.t.profile_no_modern_certs,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.25,
                    ),
                  ),
                ),
          hasLegacyCert
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 2),
                      child: Text(
                        context.t.profile_legacy_certs,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
                                        context.t.profile_view_cert(
                                          cert['certTitle'].toString(),
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.white,
                                      ),
                                      onTap: () => launchUrl(
                                        Uri.parse(
                                          '${AuthenticationService.baseURL}/certification/${user.username}/${cert["certSlug"]}',
                                        ),
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
        ],
      ),
    );
  }
}

class PortfolioWidget extends StatelessWidget {
  const PortfolioWidget({Key? key, required this.user}) : super(key: key);

  final FccUserModel user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, child) => Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          buildDivider(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              context.t.profile_portfolio,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                height: 1.25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ...user.portfolio.map(
            (portfolio) => InkWell(
              onTap: () => launchUrl(Uri.parse(portfolio.url!)),
              child: Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      // Apparentlly all properties are present with empty values - CONFIRM
                      portfolio.image!.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(
                                bottom: 6,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: portfolio.image ?? '',
                                height: 200,
                                errorWidget: (context, url, error) => Image.asset(
                                    'assets/images/placeholder-profile-img.png'),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Text(
                        portfolio.title!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          // height: 1.25,
                        ),
                      ),
                      portfolio.description!.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                portfolio.description!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  // height: 1.25,
                                  // fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
