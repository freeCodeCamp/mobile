import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mobile_app_new/auth/models/user_model.dart';
import 'package:mobile_app_new/auth/ui/profile/profile_viewmodel.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/routing/auth.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:mobile_app_new/utils/custom_tab.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';
import 'package:url_launcher/url_launcher.dart';

({int longest, int current}) _calculateStreak(Map<DateTime, int> days) {
  final activeDays = days.entries
      .where((entry) => entry.value > 0)
      .map((entry) => entry.key)
      .toSet();
  final sorted = activeDays.toList()..sort();
  var longest = 0;
  var current = 0;
  for (final day in sorted) {
    final previous = DateTime(day.year, day.month, day.day - 1);
    current = activeDays.contains(previous) ? current + 1 : 1;
    if (current > longest) longest = current;
  }
  final now = DateTime.now();
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  if (sorted.isEmpty || sorted.last.isBefore(yesterday)) current = 0;
  return (longest: longest, current: current);
}

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final refresh = ref.watch(profileRefreshProvider);
    final user = auth.value;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.canPop()
              ? context.pop()
              : const AccountRoute().go(context),
        ),
        title: const Text('Public profile'),
      ),
      body: auth.isLoading && user == null
          ? const Center(child: CircularProgressIndicator())
          : auth.hasError || refresh.hasError
          ? ErrorRetry(
              message: 'Unable to load your profile.',
              onRetry: () => ref.invalidate(profileRefreshProvider),
            )
          : user == null
          ? const _GuestProfile()
          : RefreshIndicator(
              onRefresh: () => ref.refresh(profileRefreshProvider.future),
              child: _ProfileBody(user: user),
            ),
    );
  }
}

class _GuestProfile extends StatelessWidget {
  const _GuestProfile();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Section(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colors.surfaceContainer,
                    child: Icon(
                      Icons.person_outline,
                      color: colors.onSurfaceVariant,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "You're learning as a guest",
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sign in to save progress across devices and earn certifications.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => const LoginRoute().push<void>(context),
                  child: const Text('Sign in'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.user});
  final FccUserModel user;

  @override
  Widget build(BuildContext context) {
    final days = user.heatMapCal;
    final streak = _calculateStreak(days);
    final statistics = [
      (user.points, 'Points'),
      (streak.current, 'Current streak'),
      (streak.longest, 'Longest streak'),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        _Header(user: user),
        const SizedBox(height: 14),
        _Section(
          padding: EdgeInsets.zero,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final textScale = MediaQuery.textScalerOf(context).scale(12) / 12;
              final stacked = constraints.maxWidth < 240 * textScale;
              if (stacked) {
                return Column(
                  children: [
                    for (final (index, stat) in statistics.indexed) ...[
                      if (index > 0) const Divider(),
                      _Stat(value: stat.$1, label: stat.$2, horizontal: true),
                    ],
                  ],
                );
              }
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (index, stat) in statistics.indexed) ...[
                      if (index > 0) const VerticalDivider(width: 1),
                      Expanded(
                        child: _Stat(value: stat.$1, label: stat.$2),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        _Section(child: _Heatmap(days: days)),
        const SizedBox(height: 18),
        _Certifications(user: user),
        if (user.portfolio.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('Portfolio', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final item in user.portfolio) ...[
            _PortfolioCard(portfolio: item),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: Padding(padding: padding, child: child),
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.user});
  final FccUserModel user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final links = [
      if (user.githubProfile?.trim().isNotEmpty ?? false)
        ('GitHub', user.githubProfile!),
      if (user.linkedin?.trim().isNotEmpty ?? false)
        ('LinkedIn', user.linkedin!),
      if (user.twitter?.trim().isNotEmpty ?? false) ('X', user.twitter!),
      if (user.website?.trim().isNotEmpty ?? false) ('Website', user.website!),
    ];
    return _Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: colors.primaryContainer,
                backgroundImage: user.picture.isEmpty
                    ? null
                    : CachedNetworkImageProvider(user.picture),
                child: user.picture.isEmpty
                    ? Icon(
                        Icons.person_outline,
                        size: 30,
                        color: colors.onSurfaceVariant,
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name.trim().isNotEmpty ? user.name : user.username,
                      style: theme.textTheme.titleLarge,
                    ),
                    Text('@${user.username}', style: theme.textTheme.bodySmall),
                    if (user.isDonating ||
                        user.yearsTopContributor.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: user.isDonating
                              ? colors.tertiary.withValues(alpha: 0.12)
                              : colors.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user.isDonating ? 'Supporter' : 'Top contributor',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: user.isDonating
                                ? colors.tertiary
                                : FccDesignColors.of(context).accentText,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            [
              if (user.about?.trim().isNotEmpty ?? false) user.about!.trim(),
              if (user.location?.trim().isNotEmpty ?? false)
                user.location!.trim(),
              'Joined ${Jiffy.parseFromDateTime(user.joinDate).yMMMM}',
            ].join(' · '),
            style: theme.textTheme.bodySmall,
          ),
          if (links.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final (label, url) in links)
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(48, 40),
                      side: BorderSide(color: colors.outlineVariant),
                      shape: const StadiumBorder(),
                      textStyle: theme.textTheme.bodySmall,
                    ),
                    onPressed: () {
                      final uri = Uri.tryParse(url);
                      if (uri != null &&
                          (uri.scheme == 'https' || uri.scheme == 'http')) {
                        launchUrl(uri).ignore();
                      }
                    },
                    child: Text(label),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.value,
    required this.label,
    this.horizontal = false,
  });
  final int value;
  final String label;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final valueText = FittedBox(
      fit: BoxFit.scaleDown,
      alignment: horizontal ? Alignment.centerRight : Alignment.centerLeft,
      child: Text('$value', style: Theme.of(context).textTheme.titleLarge),
    );
    final labelText = Text(label, style: Theme.of(context).textTheme.bodySmall);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: horizontal
          ? Row(
              children: [
                Expanded(flex: 2, child: labelText),
                const SizedBox(width: 12),
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: valueText,
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [valueText, labelText],
            ),
    );
  }
}

class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.days});
  final Map<DateTime, int> days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Complete calendar weeks keep weekday rows aligned, including across DST.
    final weekStart = DateTime(
      today.year,
      today.month,
      today.day - (today.weekday - 1),
    );
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day - 77);
    Color shade(int points) => points == 0
        ? colors.surfaceContainerHighest
        : Color.lerp(
            colors.primaryContainer,
            colors.primary,
            points >= 8
                ? 1
                : points >= 4
                ? 0.65
                : 0.3,
          )!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 4,
            children: [
              Text('Activity', style: theme.textTheme.titleMedium),
              Text('Last 12 weeks', style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final cell = (constraints.maxWidth - 44) / 12;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var week = 0; week < 12; week++) ...[
                  if (week > 0) const SizedBox(width: 4),
                  Column(
                    children: [
                      for (var day = 0; day < 7; day++)
                        Builder(
                          builder: (context) {
                            final date = DateTime(
                              start.year,
                              start.month,
                              start.day + week * 7 + day,
                            );
                            final points = days[date] ?? 0;
                            final label =
                                '$points ${points == 1 ? 'point' : 'points'} on ${Jiffy.parseFromDateTime(date).yMMMd}';
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: date.isAfter(today)
                                  ? SizedBox(width: cell, height: cell)
                                  : Semantics(
                                      label: label,
                                      button: true,
                                      child: Tooltip(
                                        message: label,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          onTap: () =>
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  duration: const Duration(
                                                    seconds: 2,
                                                  ),
                                                  content: Text(label),
                                                ),
                                              ),
                                          child: Container(
                                            width: cell,
                                            height: cell,
                                            decoration: BoxDecoration(
                                              color: shade(points),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ],
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Less', style: theme.textTheme.labelSmall),
            for (final points in [0, 1, 4, 8])
              Container(
                width: 11,
                height: 11,
                margin: const EdgeInsets.only(left: 3),
                decoration: BoxDecoration(
                  color: shade(points),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            const SizedBox(width: 4),
            Text('More', style: theme.textTheme.labelSmall),
          ],
        ),
      ],
    );
  }
}

class _Certifications extends StatelessWidget {
  const _Certifications({required this.user});
  final FccUserModel user;

  @override
  Widget build(BuildContext context) {
    final current = [
      if (user.isRespWebDesignCert)
        ('Responsive Web Design', 'responsive-web-design'),
      if (user.isJsAlgoDataStructCert)
        (
          'JavaScript Algorithms and Data Structures',
          'javascript-algorithms-and-data-structures',
        ),
      if (user.isFrontEndLibsCert)
        ('Front End Development Libraries', 'front-end-development-libraries'),
      if (user.is2018DataVisCert) ('Data Visualization', 'data-visualization'),
      if (user.isApisMicroservicesCert)
        ('Back End Development and APIs', 'back-end-development-and-apis'),
      if (user.isQaCertV7) ('Quality Assurance', 'quality-assurance-v7'),
      if (user.isInfosecCertV7)
        ('Information Security', 'information-security-v7'),
      if (user.isSciCompPyCertV7)
        (
          'Scientific Computing with Python',
          'scientific-computing-with-python-v7',
        ),
      if (user.isDataAnalysisPyCertV7)
        ('Data Analysis with Python', 'data-analysis-with-python-v7'),
      if (user.isMachineLearningPyCertV7)
        ('Machine Learning with Python', 'machine-learning-with-python-v7'),
      if (user.isRelationalDatabaseCertV8)
        ('Relational Database', 'relational-database-v8'),
      if (user.isCollegeAlgebraPyCertV8)
        ('College Algebra with Python', 'college-algebra-with-python-v8'),
      if (user.isFoundationalCSharpCertV8)
        (
          'Foundational C# with Microsoft',
          'foundational-c-sharp-with-microsoft',
        ),
    ];
    final legacy = [
      if (user.isFrontEndCert) ('Front End', 'legacy-front-end'),
      if (user.isBackEndCert) ('Back End', 'legacy-back-end'),
      if (user.isDataVisCert)
        ('Data Visualization', 'legacy-data-visualization'),
      if (user.isInfosecQaCert)
        (
          'Information Security and Quality Assurance',
          'information-security-and-quality-assurance',
        ),
      if (user.isFullStackCert) ('Full Stack', 'full-stack'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Certifications', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (current.isEmpty && legacy.isEmpty)
          const _Section(
            child: Text('You have not yet earned any certifications.'),
          ),
        if (current.isNotEmpty)
          _CertificateList(certificates: current, username: user.username),
        if (legacy.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            'Legacy certifications',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _CertificateList(certificates: legacy, username: user.username),
        ],
      ],
    );
  }
}

class _CertificateList extends StatelessWidget {
  const _CertificateList({required this.certificates, required this.username});
  final List<(String, String)> certificates;
  final String username;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = FccDesignColors.of(context);
    return _Section(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (final (index, certificate) in certificates.indexed) ...[
            if (index > 0) const Divider(),
            Padding(
              padding: const EdgeInsets.all(14),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final stacked =
                      constraints.maxWidth < 380 &&
                      MediaQuery.textScalerOf(context).scale(14) > 20;
                  final identity = Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: design.successContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.emoji_events_outlined,
                          color: design.onSuccessContainer,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          certificate.$1,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  );
                  final viewButton = Semantics(
                    label: 'View ${certificate.$1} certification',
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(48, 44),
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: theme.textTheme.bodySmall,
                      ),
                      onPressed: () => openInCustomTab(
                        Uri.https(
                          'www.freecodecamp.org',
                          '/certification/$username/${certificate.$2}',
                        ).toString(),
                      ),
                      child: const Text('View'),
                    ),
                  );
                  return stacked
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            identity,
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: viewButton,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: identity),
                            const SizedBox(width: 10),
                            viewButton,
                          ],
                        );
                },
              ),
            ),
          ],
        ],
      ),
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
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: link == null ? null : () => launchUrl(link).ignore(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != null && image.isNotEmpty) ...[
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
              ],
              Text(
                portfolio.title ?? '',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (portfolio.description?.isNotEmpty ?? false) ...[
                const SizedBox(height: 8),
                Text(
                  portfolio.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              if (link != null) ...[
                const SizedBox(height: 8),
                Text(
                  url,
                  style: TextStyle(
                    color: FccDesignColors.of(context).accentText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
