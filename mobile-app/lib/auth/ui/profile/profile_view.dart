import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/auth/controllers/profile_controller.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/ui/profile/profile_viewmodel.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/routing/auth.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/utils/custom_tab.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/error_retry.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  bool _preview = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final refresh = ref.watch(profileRefreshProvider);
    final user = auth.value;
    final preview = _preview && user != null;
    return PopScope(
      canPop: !preview,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && preview) setState(() => _preview = false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              if (preview) {
                setState(() => _preview = false);
              } else if (context.canPop()) {
                context.pop();
              } else {
                const AccountRoute().go(context);
              }
            },
          ),
          title: Text(preview ? 'Profile' : 'Public profile'),
          actions: [
            if (user != null && !preview)
              IconButton(
                tooltip: 'Edit profile',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => const EditProfileRoute().push<void>(context),
              ),
          ],
        ),
        bottomNavigationBar: const AppNavigationFooter(
          selected: AppDestination.account,
        ),
        body: SafeArea(
          top: false,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: auth.isLoading && user == null
                  ? const Center(child: CircularProgressIndicator())
                  : auth.hasError || refresh.hasError
                  ? ErrorRetry(
                      message: 'Unable to load your profile.',
                      onRetry: () => ref.invalidate(profileRefreshProvider),
                    )
                  : user == null
                  ? const _GuestProfile()
                  : Column(
                      children: [
                        if (preview)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                            child: _PreviewBanner(
                              onDone: () => setState(() => _preview = false),
                            ),
                          ),
                        Expanded(
                          child: preview && user.profileUI.isLocked
                              ? _PrivateProfile(username: user.username)
                              : RefreshIndicator(
                                  onRefresh: () => ref.refresh(
                                    profileRefreshProvider.future,
                                  ),
                                  child: _ProfileBody(
                                    key: ValueKey(preview),
                                    user: user,
                                    preview: preview,
                                    onPreview: () =>
                                        setState(() => _preview = true),
                                  ),
                                ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrivateProfile extends StatelessWidget {
  const _PrivateProfile({required this.username});
  final String username;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
      children: [
        Center(
          child: CircleAvatar(
            radius: 42,
            backgroundColor: colors.surfaceContainer,
            child: Icon(
              Icons.person_outline,
              size: 42,
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          '@$username',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            fontFamily: 'JetBrains Mono',
          ),
        ),
        const SizedBox(height: 38),
        Center(
          child: CircleAvatar(
            radius: 26,
            backgroundColor: colors.primaryContainer,
            child: Icon(
              Icons.lock_outline,
              color: FccDesignColors.of(context).accentText,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'This profile is private',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'This camper has chosen to keep their profile private.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _PreviewBanner extends StatelessWidget {
  const _PreviewBanner({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: FccDesignColors.of(context).heatmapLow),
      ),
      child: Row(
        children: [
          Icon(
            Icons.visibility_outlined,
            size: 18,
            color: FccDesignColors.of(context).accentText,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text('Previewing your profile as others see it'),
          ),
          const SizedBox(width: 10),
          FilledButton(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              minimumSize: const Size(48, 44),
            ).copyWith(shape: FccTheme.focusShape(context, radius: 10)),
            onPressed: onDone,
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _PrivacyBanner extends StatelessWidget {
  const _PrivacyBanner({required this.onPreview});
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final accent = FccDesignColors.of(context).accentText;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colors.primary.withValues(alpha: 0.12),
                child: Icon(Icons.lock_outline, color: accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your profile is private.',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'This limits what other people can see.',
                      style: theme.textTheme.bodySmall,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        textStyle: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () =>
                          const ProfileVisibilityRoute().push<void>(context),
                      child: const Text('Change visibility'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: const ButtonStyle().copyWith(
              shape: FccTheme.focusShape(context),
            ),
            onPressed: onPreview,
            icon: const Icon(Icons.visibility_outlined, size: 20),
            label: const Text('View as others'),
          ),
        ],
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
                  style: FilledButton.styleFrom(),
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

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({
    super.key,
    required this.user,
    required this.preview,
    required this.onPreview,
  });
  final FccUserModel user;
  final bool preview;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = user.heatMapCal;
    final streak = ref.watch(profileStreakProvider);
    final visibility = user.profileUI;
    final showActivity = visibility.showHeatMap;
    final statistics = [
      if (visibility.showPoints) (user.points, 'Points'),
      if (showActivity) ...[
        (streak.current, 'Current streak'),
        (streak.longest, 'Longest streak'),
      ],
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        if (!preview && visibility.isLocked) ...[
          _PrivacyBanner(onPreview: onPreview),
          const SizedBox(height: 16),
        ],
        _Header(user: user),
        if (statistics.isNotEmpty) ...[
          const SizedBox(height: 16),
          _Section(
            radius: 14,
            padding: EdgeInsets.zero,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final textScale =
                    MediaQuery.textScalerOf(context).scale(12) / 12;
                final stacked =
                    constraints.maxWidth < 80 * statistics.length * textScale;
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
        ],
        if (showActivity) ...[
          const SizedBox(height: 16),
          _Section(child: _Heatmap(days: days)),
        ],
        if (visibility.showCerts) ...[
          const SizedBox(height: 16),
          _Certifications(user: user, preview: preview),
        ],
        if (visibility.showPortfolio && user.portfolio.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Portfolio',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          _Section(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final (index, item) in user.portfolio.indexed) ...[
                  if (index > 0) const Divider(),
                  _PortfolioRow(portfolio: item),
                ],
              ],
            ),
          ),
        ],
        if (visibility.showExperience && user.experience.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Experience',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          _Section(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final (index, item) in user.experience.indexed) ...[
                  if (index > 0) const Divider(),
                  _ExperienceRow(experience: item),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 16,
  });
  final Widget child;
  final EdgeInsets padding;
  final double radius;

  @override
  Widget build(BuildContext context) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
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
    final visibility = user.profileUI;
    final showName = visibility.showName;
    final showDonation = visibility.showDonation;
    final showSupporter = user.isDonating && showDonation;
    final description = [
      if (visibility.showAbout) ...[
        if (user.about?.trim().isNotEmpty ?? false) user.about!.trim(),
      ],
      if (visibility.showLocation &&
          (user.location?.trim().isNotEmpty ?? false))
        user.location!.trim(),
      if (visibility.showAbout)
        'Joined ${Jiffy.parseFromDateTime(user.joinDate).yMMMM}',
    ];
    final links = [
      if (user.githubProfile?.trim().isNotEmpty ?? false)
        ('GitHub', user.githubProfile!),
      if (user.linkedin?.trim().isNotEmpty ?? false)
        ('LinkedIn', user.linkedin!),
      if (user.twitter?.trim().isNotEmpty ?? false) ('X', user.twitter!),
      if (user.bluesky?.trim().isNotEmpty ?? false) ('Bluesky', user.bluesky!),
      if (user.website?.trim().isNotEmpty ?? false) ('Website', user.website!),
    ];
    return _Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 36,
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
                    if (showName)
                      Text(
                        user.name.trim().isNotEmpty ? user.name : user.username,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    Text(
                      '@${user.username}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 13,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    if (showSupporter ||
                        user.yearsTopContributor.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: showSupporter
                              ? FccDesignColors.of(context).donateContainer
                              : colors.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          showSupporter ? 'Supporter' : 'Top contributor',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: showSupporter
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
          if (description.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              description.join(' · '),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.5,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
          if (links.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (label, url) in links)
                  OutlinedButton(
                    style: FccTheme.compactOutlineStyle(context).copyWith(
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 12),
                      ),
                      shape: FccTheme.focusShape(context, radius: 999),
                      textStyle: const WidgetStatePropertyAll(
                        TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
      child: Text(
        '$value',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
    final labelText = Text(
      label,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
    final design = FccDesignColors.of(context);
    Color shade(int points) => points == 0
        ? colors.surfaceContainerHighest
        : points >= 8
        ? design.heatmapHigh
        : points >= 4
        ? design.heatmapMid
        : design.heatmapLow;
    final legendStyle = theme.textTheme.labelSmall?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: colors.onSurfaceVariant,
    );

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
              Text(
                'Activity',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Last 12 weeks',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  color: colors.onSurfaceVariant,
                ),
              ),
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
                                      child: Tooltip(
                                        message: label,
                                        child: Container(
                                          width: cell,
                                          height: cell,
                                          decoration: BoxDecoration(
                                            color: shade(points),
                                            borderRadius: BorderRadius.circular(
                                              4,
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
            Text('Less', style: legendStyle),
            for (final points in [0, 1, 4, 8])
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  color: shade(points),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            const SizedBox(width: 4),
            Text('More', style: legendStyle),
          ],
        ),
      ],
    );
  }
}

class _Certifications extends StatelessWidget {
  const _Certifications({required this.user, required this.preview});
  final FccUserModel user;
  final bool preview;

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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Certifications',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        if (current.isEmpty && legacy.isEmpty)
          _Section(
            child: Text(
              preview
                  ? 'This camper has not yet earned any certifications.'
                  : 'You have not yet earned any certifications.',
            ),
          ),
        if (current.isNotEmpty)
          _CertificateList(certificates: current, username: user.username),
        if (legacy.isNotEmpty) ...[
          const SizedBox(height: 16),
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
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  );
                  final viewButton = Semantics(
                    label: 'View ${certificate.$1} certification',
                    child: OutlinedButton(
                      style: FccTheme.compactOutlineStyle(context),
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

class _PortfolioRow extends StatelessWidget {
  const _PortfolioRow({required this.portfolio});
  final Portfolio portfolio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final accent = FccDesignColors.of(context).accentText;
    final url = portfolio.url?.trim() ?? '';
    final link = Uri.tryParse(url);
    final canOpen =
        link != null &&
        link.host.isNotEmpty &&
        (link.scheme == 'http' || link.scheme == 'https');
    final image = portfolio.image?.trim() ?? '';
    final fallback = ColoredBox(
      color: colors.surfaceContainer,
      child: Icon(Icons.code, color: colors.onSurfaceVariant, size: 30),
    );
    final thumbnail = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 96,
        height: 64,
        child: image.isEmpty
            ? fallback
            : CachedNetworkImage(
                imageUrl: image,
                width: 96,
                height: 64,
                fit: BoxFit.cover,
                placeholder: (_, _) => fallback,
                errorWidget: (_, _, _) => fallback,
              ),
      ),
    );
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (portfolio.title?.trim().isNotEmpty ?? false)
          Text(
            portfolio.title!,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        if (portfolio.description?.trim().isNotEmpty ?? false) ...[
          const SizedBox(height: 4),
          Text(
            portfolio.description!,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 13),
          ),
        ],
        if (canOpen) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Flexible(
                child: Text(
                  url.replaceFirst(RegExp(r'^https?://'), ''),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'JetBrains Mono',
                    color: accent,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Icon(Icons.open_in_new, size: 14, color: accent),
            ],
          ),
        ],
      ],
    );
    return InkWell(
      onTap: canOpen ? () => launchUrl(link).ignore() : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: LayoutBuilder(
          builder: (context, constraints) => constraints.maxWidth < 240
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [thumbnail, const SizedBox(height: 12), details],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    thumbnail,
                    const SizedBox(width: 12),
                    Expanded(child: details),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ExperienceRow extends StatelessWidget {
  const _ExperienceRow({required this.experience});
  final Experience experience;

  String _monthYear(String value) {
    final match = RegExp(r'^(\d{2})/(\d{4})$').firstMatch(value);
    if (match == null) return value;
    final month = int.parse(match.group(1)!);
    if (month < 1 || month > 12) return value;
    return Jiffy.parseFromDateTime(
      DateTime(int.parse(match.group(2)!), month),
    ).format(pattern: 'MMM yyyy');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final company = [
      experience.company.trim(),
      if (experience.location.trim().isNotEmpty) experience.location.trim(),
    ].where((part) => part.isNotEmpty).join(' · ');
    final start = _monthYear(experience.startDate.trim());
    final end = experience.endDate.trim().isEmpty
        ? 'Present'
        : _monthYear(experience.endDate.trim());
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.work_outline,
              color: FccDesignColors.of(context).accentText,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  experience.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (company.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    company,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: colors.onSurface,
                    ),
                  ),
                ],
                if (start.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    '$start – $end',
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 13),
                  ),
                ],
                if (experience.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    experience.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
