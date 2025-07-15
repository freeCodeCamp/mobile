import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/service/learn/daily_challenges_service.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/utils/challenge_utils.dart';
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
        challengesCompleted: 0,
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
          await DailyChallengesService().fetchTodayChallenge();

      setState(() {
        _challenge = todayChallenge;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load today\'s challenge';
        _loading = false;
      });
    }
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

  Widget _buildChallengeTitle(DailyChallenge challenge) {
    return Text(
      challenge.title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: FccColors.gray90,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildChallengeCountdown() {
    return Semantics(
      label: 'Countdown timer. Next challenge in ${_formatDuration(_timeLeft)}',
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
    );
  }

  Widget _buildChallengeMotivation() {
    return Text(
      'Do you have the skills to complete this challenge?',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18, color: FccColors.gray85),
    );
  }

  Widget _buildChallengeCTAButton() {
    return SizedBox(
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
          icon: Icon(Icons.arrow_forward_ios,
              size: 20, semanticLabel: 'Go to challenge'),
          label: Text(
            'Start the challenge',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
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
    final challenge = _challenge!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Daily Challenge',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: FccColors.gray00,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Semantics(
            label: 'Daily challenge card',
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
                  _buildChallengeTitle(challenge),
                  SizedBox(height: 14),
                  _buildChallengeCountdown(),
                  SizedBox(height: 14),
                  _buildChallengeMotivation(),
                  SizedBox(height: 20),
                  _buildChallengeCTAButton(),
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
