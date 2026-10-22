import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/ui/profile/profile_viewmodel.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/widgets/drawer/drawer.dart';
import 'package:freecodecamp/widgets/error_retry.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

({int longest, int current}) _calculateStreak(Map<DateTime, int> days) {
  final sorted = days.keys.toList()..sort();
  var longest = 0;
  var current = 0;

  for (final day in sorted) {
    final previous = DateTime(day.year, day.month, day.day - 1);
    current = days.containsKey(previous) ? current + 1 : 1;
    if (current > longest) longest = current;
  }

  // A streak whose last day is before yesterday has ended.
  final now = DateTime.now();
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  if (sorted.isEmpty || sorted.last.isBefore(yesterday)) current = 0;

  return (longest: longest, current: current);
}

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refresh = ref.watch(profileRefreshProvider);
    final user = ref.watch(authProvider.select((s) => s.value));

    return Scaffold(
      backgroundColor: FccSemanticColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('PROFILE'),
        backgroundColor: FccSemanticColors.backgroundSecondary,
      ),
      drawer: const DrawerWidget(),
      body: switch (refresh) {
        AsyncData() when user != null => _ProfileBody(user: user),
        AsyncData() => const Center(
          child: Text(
            'No user data found',
            style: TextStyle(color: FccSemanticColors.foregroundDanger),
          ),
        ),
        AsyncError() => ErrorRetry(
          message: 'Unable to load your profile.',
          onRetry: () => ref.invalidate(profileRefreshProvider),
        ),
        _ => const Center(
          child: CircularProgressIndicator(color: FccColors.yellow40),
        ),
      },
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.user});

  final FccUserModel user;

  @override
  Widget build(BuildContext context) {
    final heatMapCal = user.heatMapCal;
    final streak = _calculateStreak(heatMapCal);

    return SingleChildScrollView(
      child: Column(
        children: [
          _Header(user: user),
          if (user.about?.trim().isNotEmpty ?? false)
            _Section(
              padding: const EdgeInsets.all(16),
              child: _About(about: user.about!),
            ),
          _Section(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: _Info(user: user, streak: streak),
          ),
          _Section(
            padding: const EdgeInsets.all(12),
            child: _Heatmap(days: heatMapCal),
          ),
          if (user.portfolio.isNotEmpty)
            _Section(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                children: [
                  for (final item in user.portfolio)
                    _PortfolioCard(portfolio: item),
                ],
              ),
            ),
          _Section(
            margin: const EdgeInsets.fromLTRB(8, 6, 8, 56),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: _Certifications(user: user),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.padding,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  });

  final EdgeInsets padding;
  final EdgeInsets margin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      child: Card(
        color: FccColors.gray85,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.user});

  final FccUserModel user;

  @override
  Widget build(BuildContext context) {
    final hasName = user.name.trim().isNotEmpty;
    final nameColor = user.isDonating ? FccColors.yellow40 : Colors.white;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(8, 89, 8, 6),
          child: Card(
            color: FccColors.gray85,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 92, 16, 24),
              child: Column(
                children: [
                  Text(
                    hasName ? user.name : '@${user.username}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: nameColor,
                    ),
                  ),
                  if (hasName) ...[
                    const SizedBox(height: 4),
                    Text(
                      '@${user.username}',
                      style: TextStyle(
                        fontSize: 16,
                        color: nameColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
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
                  border: Border.all(color: FccColors.blue50, width: 3),
                ),
                child: CircleAvatar(
                  radius: 54,
                  backgroundColor: FccColors.gray85,
                  backgroundImage: user.picture.isEmpty
                      ? const AssetImage(
                          'assets/images/placeholder-profile-img.png',
                        )
                      : CachedNetworkImageProvider(user.picture),
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
}

class _About extends StatelessWidget {
  const _About({required this.about});

  final String about;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.chat_bubble, color: FccColors.gray00, size: 22),
            SizedBox(width: 10),
            Text(
              'About',
              style: TextStyle(
                color: FccColors.gray00,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          about,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.user, required this.streak});

  final FccUserModel user;
  final ({int longest, int current}) streak;

  @override
  Widget build(BuildContext context) {
    bool present(String? value) => value != null && value.trim().isNotEmpty;

    final rows = [
      if (present(user.location))
        _InfoRow(
          Icons.location_on,
          'Location',
          user.location!,
          FccColors.blue50,
        ),
      if (user.isDonating)
        const _InfoRow(
          Icons.favorite,
          'Supporter',
          'Supporter',
          FccColors.yellow45,
        ),
      if (present(user.twitter))
        _InfoRow(Icons.alternate_email, 'X', user.twitter!, FccColors.blue50),
      if (present(user.githubProfile))
        _InfoRow(Icons.code, 'GitHub', user.githubProfile!, FccColors.blue50),
      if (present(user.linkedin))
        _InfoRow(Icons.business, 'LinkedIn', user.linkedin!, FccColors.blue50),
      if (present(user.website))
        _InfoRow(Icons.language, 'Website', user.website!, FccColors.blue50),
      _InfoRow(
        Icons.calendar_month,
        'Joined',
        Jiffy.parseFromDateTime(user.joinDate).yMMMM,
        FccColors.gray15,
      ),
      _InfoRow(
        Icons.local_fire_department_sharp,
        'Points',
        '${user.points}',
        FccColors.red30,
      ),
      _InfoRow(
        Icons.emoji_events,
        'Longest Streak',
        '${streak.longest}',
        FccColors.orange30,
      ),
      _InfoRow(
        Icons.bolt,
        'Current Streak',
        '${streak.current}',
        FccColors.orange30,
      ),
    ];

    return Column(
      children: [
        for (final (i, row) in rows.indexed) ...[
          if (i > 0)
            const Divider(color: FccColors.gray75, height: 18, thickness: 1),
          row,
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.label, this.value, this.iconColor);

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: FccColors.gray15,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.days});

  final Map<DateTime, int> days;

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      startDate: Jiffy.now().subtract(months: 3).dateTime,
      datasets: days,
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
      onClick: (date) {
        final points = days[date] ?? 0;
        final day = Jiffy.parseFromDateTime(date).yMMMd;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: FccColors.gray75,
            duration: const Duration(seconds: 2),
            content: Text(
              '$points ${points == 1 ? 'point' : 'points'} on $day',
              style: const TextStyle(
                color: FccSemanticColors.foregroundPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  const _PortfolioCard({required this.portfolio});

  final Portfolio portfolio;

  @override
  Widget build(BuildContext context) {
    final url = portfolio.url?.trim() ?? '';
    final link = url.isEmpty ? null : Uri.tryParse(url);
    final image = portfolio.image;
    final description = portfolio.description;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: FccColors.gray85,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: link == null ? null : () => launchUrl(link).ignore(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != null && image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                portfolio.title ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (description != null && description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: FccColors.gray15,
                    ),
                  ),
                ),
              if (link != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.link, color: FccColors.blue50, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        url,
                        style: const TextStyle(
                          fontSize: 14,
                          color: FccColors.blue50,
                          decoration: TextDecoration.underline,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Certifications extends StatelessWidget {
  const _Certifications({required this.user});

  final FccUserModel user;

  @override
  Widget build(BuildContext context) {
    final current = [
      if (user.isRespWebDesignCert) 'Responsive Web Design Certification',
      if (user.isJsAlgoDataStructCert)
        'JavaScript Algorithms and Data Structures Certification',
      if (user.isFrontEndLibsCert)
        'Front End Development Libraries Certification',
      if (user.is2018DataVisCert) 'Data Visualization Certification',
      if (user.isApisMicroservicesCert)
        'Back End Development and APIs Certification',
      if (user.isQaCertV7) 'Quality Assurance Certification',
      if (user.isInfosecCertV7) 'Information Security Certification',
      if (user.isSciCompPyCertV7)
        'Scientific Computing with Python Certification',
      if (user.isDataAnalysisPyCertV7)
        'Data Analysis with Python Certification',
      if (user.isMachineLearningPyCertV7)
        'Machine Learning with Python Certification',
      if (user.isRelationalDatabaseCertV8) 'Relational Database Certification',
      if (user.isCollegeAlgebraPyCertV8) 'College Algebra with Python',
      if (user.isFoundationalCSharpCertV8) 'Foundational C# with Microsoft',
    ];

    final legacy = [
      if (user.isFrontEndCert) 'Front End Certification',
      if (user.isBackEndCert) 'Back End Certification',
      if (user.isDataVisCert) 'Data Visualization Certification',
      if (user.isInfosecQaCert)
        'Information Security and Quality Assurance Certification',
      if (user.isFullStackCert) 'Full Stack Certification',
    ];

    final certs = [...current, ...legacy];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
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
        if (certs.isEmpty)
          const Text(
            'You have not yet earned any certifications.',
            style: TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        for (final title in certs) _Trophy(title: title),
      ],
    );
  }
}

class _Trophy extends StatelessWidget {
  const _Trophy({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: FccColors.gray85,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: FccColors.yellow40, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
