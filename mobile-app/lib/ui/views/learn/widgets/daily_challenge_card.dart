import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_service.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/utils/challenge_utils.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class DailyChallengeCard extends StatefulWidget {
  const DailyChallengeCard({super.key});

  @override
  State<DailyChallengeCard> createState() => _DailyChallengeCardState();
}

class _DailyChallengeCardState extends State<DailyChallengeCard> {
  Duration _timeLeft = Duration.zero;
  Timer? _timer;
  DailyChallenge? _challenge;
  bool _loading = true;
  String? _error;
  bool _isCompleted = false;
  final AuthenticationService _auth = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  void _navigateToDailyChallenge(BuildContext context) {
    if (_challenge == null) return;
    final challenge = _challenge!;
    final monthYear = formatMonthFromDate(challenge.date);

    final challengeOverview = DailyChallengeOverview(
      id: challenge.id,
      title: challenge.title,
      date: challenge.date,
      challengeNumber: challenge.challengeNumber,
    );

    final block = DailyChallengeBlock(
      monthYear: monthYear,
      challenges: [challengeOverview],
      description: '',
    ).toCurriculumBlock();

    Navigator.of(context).pushNamed(
      '/challenge-template-view',
      arguments: ChallengeTemplateViewArguments(
        challengeId: challenge.id,
        block: block,
        challengeDate: challenge.date,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tzdata.initializeTimeZones();
    _updateTimeLeft();
    _fetchChallenge();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _updateTimeLeft();
    });
  }

  Future<void> _fetchChallenge() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final todayChallenge =
          await DailyChallengeService().fetchTodayChallenge();

      final isCompleted = await _checkIfChallengeCompleted(todayChallenge.id);

      setState(() {
        _challenge = todayChallenge;
        _isCompleted = isCompleted;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load today\'s challenge';
        _loading = false;
      });
    }
  }

  Future<bool> _checkIfChallengeCompleted(String challengeId) async {
    FccUserModel? user = await _auth.userModel;
    if (user != null) {
      for (CompletedDailyChallenge challenge
          in user.completedDailyCodingChallenges) {
        if (challenge.id == challengeId) {
          return true;
        }
      }
    }
    return false;
  }

  void _updateTimeLeft() {
    final chicago = tz.getLocation('America/Chicago');
    final now = tz.TZDateTime.now(chicago);
    final nextMidnight =
        tz.TZDateTime(chicago, now.year, now.month, now.day + 1);
    setState(() {
      _timeLeft = nextMidnight.difference(now);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}';
  }

  Widget _buildCompletedContent() {
    return Column(
      children: [
        // Card label
        Text(
          "Today's challenge completed!",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: FccColors.gray80,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 14),
        // Countdown timer
        Semantics(
          label:
              'Countdown timer. Next challenge in ${_formatDuration(_timeLeft)}',
          liveRegion: true,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Next challenge in: ${_formatDuration(_timeLeft)}',
              style: TextStyle(
                color: FccColors.gray90,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
        SizedBox(height: 14),
        // CTA Button
        SizedBox(
          width: double.infinity,
          child: Tooltip(
            message: 'View past daily challenges',
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: FccColors.yellow50,
                foregroundColor: FccColors.gray90,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                _navigationService.navigateTo(Routes.dailyChallengesView);
              },
              icon: Icon(
                Icons.history,
                size: 20,
                semanticLabel: 'View past challenges',
              ),
              label: Text(
                'View past challenges',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotCompletedContent() {
    if (_challenge == null) {
      return SizedBox();
    }
    return Column(
      children: [
        // Card label
        Text(
          "Today's challenge",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: FccColors.gray80,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        // Challenge title
        Text(
          _challenge!.title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: FccColors.gray90,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 14),
        // Motivation text
        Text(
          'Do you have the skills to complete this challenge?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: FccColors.gray85),
        ),
        SizedBox(height: 20),
        // CTA Button
        SizedBox(
          width: double.infinity,
          child: Tooltip(
            message: 'Start the daily challenge now',
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: FccColors.yellow50,
                foregroundColor: FccColors.gray90,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _navigateToDailyChallenge(context),
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                semanticLabel: 'Go to challenge',
              ),
              label: Text(
                'Start the challenge',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_challenge == null) {
      return Center(child: Text('No challenge available today'));
    }
    return Column(
      children: [
        SizedBox(height: 16),
        GestureDetector(
          onTap: () {},
          child: Semantics(
            label: _isCompleted
                ? 'Daily challenge completed. View past challenges.'
                : 'Daily challenge card',
            container: true,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 24,
              decoration: BoxDecoration(
                color: FccColors.gray10,
                border: Border.all(color: FccColors.gray10, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _isCompleted
                      ? _buildCompletedContent()
                      : _buildNotCompletedContent(),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
