import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
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
  const ProfileView({super.key});

  BoxBorder borderPicker(FccUserModel user) {
    if (user.isDonating && user.yearsTopContributor.isNotEmpty) {
      return Border.all(width: 5, color: FccColors.purple50);
    } else if (user.yearsTopContributor.isNotEmpty) {
      return Border.all(width: 5, color: FccColors.blue50);
    } else if (user.isDonating) {
      return Border.all(width: 5, color: FccColors.yellow45);
    } else {
      return Border.all(width: 5, color: FccColors.gray15);
    }
  }

  Widget buildDivider() => Divider(
        color: FccColors.gray75,
        thickness: 1.2,
        height: 24,
      );

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: FccSemanticColors.backgroundPrimary,
        appBar: AppBar(
          title: Text(
            context.t.profile_title,
            style: const TextStyle(color: FccSemanticColors.foregroundPrimary),
          ),
          backgroundColor: FccSemanticColors.backgroundSecondary,
          iconTheme:
              const IconThemeData(color: FccSemanticColors.foregroundPrimary),
        ),
        drawer: const DrawerWidgetView(),
        body: FutureBuilder<FccUserModel>(
          future: model.auth.userModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                  child: CircularProgressIndicator(color: FccColors.yellow40));
            }
            if (snapshot.hasError) {
              return Text('${snapshot.error}',
                  style: const TextStyle(
                      color: FccSemanticColors.foregroundDanger));
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
                },
                {
                  'show': user.isCollegeAlgebraPyCertV8,
                  'title': 'College Algebra with Python',
                  'certSlug': 'college-algebra-with-python-v8',
                },
                {
                  'show': user.isFoundationalCSharpCertV8,
                  'title': 'Foundational C# with Microsoft',
                  'certSlug': 'foundational-c-sharp-with-microsoft',
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
                color: FccSemanticColors.backgroundPrimary,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(user),
                      _buildAboutCard(user),
                      _buildInfoSection(context, user, streak),
                      _buildHeatmap(context, user, streak),
                      _buildCertifications(user, hasModernCert, hasLegacyCert,
                          currentCerts, legacyCerts),
                      _buildPortfolio(user),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Text(
                  context.t.profile_no_userdata.toString(),
                  style: const TextStyle(
                      color: FccSemanticColors.foregroundDanger),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildHeader(FccUserModel user) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(8, 64, 8, 6),
          child: Card(
            color: FccColors.gray85,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 60,
                bottom: 24,
                left: 16,
                right: 16,
              ),
              child: Column(
                children: [
                  SizedBox(height: 32),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: FccColors.gray00,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '@${user.username}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: FccColors.yellow40,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: FccColors.blue50,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 54,
                  backgroundColor: FccColors.gray85,
                  backgroundImage: user.picture == ''
                      ? const AssetImage(
                          'assets/images/placeholder-profile-img.png')
                      : CachedNetworkImageProvider(user.picture)
                          as ImageProvider,
                ),
              ),
              if (user.isDonating || user.yearsTopContributor.isNotEmpty)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: FccColors.yellow45,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      user.isDonating ? Icons.favorite : Icons.emoji_events,
                      color: FccColors.gray85,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutCard(FccUserModel user) {
    if (user.about == null || user.about!.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Card(
        color: FccColors.gray85,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.chat_bubble, color: FccColors.purple50, size: 22),
                  const SizedBox(width: 10),
                  const Text(
                    'About',
                    style: TextStyle(
                      color: FccColors.purple50,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                user.about!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
      BuildContext context, FccUserModel user, Map<String, int> streak) {
    final infoRows = <Widget>[
      if (user.location != null && user.location!.trim().isNotEmpty)
        _infoRow(
            Icons.location_on, 'Location', user.location!, FccColors.blue50),
      if (user.isDonating)
        _infoRow(Icons.favorite, 'Supporter', context.t.profile_supporter,
            FccColors.yellow45),
      if (user.twitter != null && user.twitter!.trim().isNotEmpty)
        _infoRow(
            Icons.alternate_email, 'X', '@${user.twitter}', FccColors.blue50),
      if (user.githubProfile != null && user.githubProfile!.trim().isNotEmpty)
        _infoRow(Icons.code, 'GitHub', user.githubProfile!, FccColors.blue50),
      if (user.linkedin != null && user.linkedin!.trim().isNotEmpty)
        _infoRow(Icons.business, 'LinkedIn', user.linkedin!, FccColors.blue50),
      if (user.website != null && user.website!.trim().isNotEmpty)
        _infoRow(Icons.language, 'Website', user.website!, FccColors.blue50),
      _infoRow(Icons.calendar_month, 'Joined',
          Jiffy.parseFromDateTime(user.joinDate).yMMMM, FccColors.gray15),
      _infoRow(Icons.local_fire_department_sharp, 'Points',
          user.points.toString(), FccColors.red30),
      _infoRow(Icons.emoji_events, 'Longest Streak',
          (streak['longest'] ?? 0).toString(), FccColors.yellow40),
      _infoRow(Icons.bolt, 'Current Streak',
          (streak['current'] ?? 0).toString(), FccColors.yellow40),
    ];
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Card(
        color: FccColors.gray85,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            children: [
              ...infoRows.expand((row) sync* {
                yield row;
                yield const Divider(
                    color: FccColors.gray75, height: 18, thickness: 1);
              }).toList()
                ..removeLast(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 14),
          Text(
            label,
            style: const TextStyle(
              color: FccColors.gray15,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmap(
      BuildContext context, FccUserModel user, Map<String, int> streak) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Card(
        color: FccColors.gray85,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              HeatMap(
                startDate: Jiffy.now().subtract(months: 3).dateTime,
                datasets: user.heatMapCal,
                colorsets: const {
                  0: FccColors.gray80,
                  1: FccColors.gray45,
                  4: FccColors.gray15,
                  8: FccColors.gray00,
                },
                defaultColor: FccColors.gray80,
                scrollable: true,
                colorMode: ColorMode.color,
                showColorTip: false,
                onClick: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: FccColors.gray75,
                      duration: const Duration(seconds: 2),
                      content: Text(
                        context.t.profile_points_on_date(
                          (user.heatMapCal[value] ?? 0),
                          Jiffy.parseFromDateTime(value).yMMMd,
                        ),
                        style: const TextStyle(
                            color: FccSemanticColors.foregroundPrimary),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCertifications(FccUserModel user, bool hasModernCert,
      bool hasLegacyCert, List currentCerts, List legacyCerts) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Card(
        color: FccColors.gray85,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: CertificationWidget(
            user: user,
            hasModernCert: hasModernCert,
            hasLegacyCert: hasLegacyCert,
            currentCerts: currentCerts,
            legacyCerts: legacyCerts,
          ),
        ),
      ),
    );
  }

  Widget _buildPortfolio(FccUserModel user) {
    if (user.portfolio.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Card(
        color: FccColors.gray85,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: _buildPortfolioWidget(user),
        ),
      ),
    );
  }

  Widget _buildPortfolioWidget(FccUserModel user) {
    return Column(
      children: [
        buildDivider(),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Portfolio',
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    if (portfolio.image != null && portfolio.image!.isNotEmpty)
                      Image.network(
                        portfolio.image!,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    const SizedBox(height: 8),
                    Text(
                      portfolio.title!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (portfolio.description != null &&
                        portfolio.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          portfolio.description!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CertificationWidget extends StatelessWidget {
  const CertificationWidget({
    super.key,
    required this.user,
    required this.hasModernCert,
    required this.hasLegacyCert,
    required this.currentCerts,
    required this.legacyCerts,
  });

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
              'freeCodeCamp Certifications',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                height: 1.25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (hasModernCert) _buildTrophyList(currentCerts),
          if (hasLegacyCert) _buildTrophyList(legacyCerts),
        ],
      ),
    );
  }

  Widget _buildTrophyList(List certs) {
    return Column(
      children: certs.where((cert) => cert['show']).map<Widget>((cert) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
          decoration: BoxDecoration(
            color: FccColors.gray85,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events, color: FccColors.yellow40, size: 26),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    cert['title'],
                    style: const TextStyle(
                      color: FccColors.yellow40,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
