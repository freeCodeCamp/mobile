import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:jiffy/jiffy.dart';
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

  @override
  void initState() {
    super.initState();
    tzdata.initializeTimeZones();
    _updateTimeLeft();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateTimeLeft());
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

  @override
  Widget build(BuildContext context) {
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
                color: FccColors.yellow50,
                border: Border.all(color: FccColors.yellow50, width: 2),
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
                  Text(
                    'Write a Program That Prints Numbers from 1 to 100, Substituting Words Based on Divisibility Rules Using Clean, Readable, and Modular Code Practices',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: FccColors.gray90,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 14),
                  Semantics(
                    label:
                        'Countdown timer. Next challenge in ${_formatDuration(_timeLeft)}',
                    liveRegion: true,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: FccColors.gray10,
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
                  Text(
                    'Do you have the skills to complete this challenge?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: FccColors.gray85),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Tooltip(
                      message: 'Solve the daily challenge now',
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
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward_ios,
                            size: 20, semanticLabel: 'Go to challenge'),
                        label: Text(
                          'Solve it now!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          width: MediaQuery.of(context).size.width - 24,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: FccColors.gray10,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: FccColors.gray10, width: 1),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Missed yesterday? Try the previous challenge!',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: FccColors.gray90,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      Jiffy.parse('2025-07-07').format(pattern: 'EEEE, d MMMM'),
                      style: TextStyle(
                        fontSize: 13,
                        color: FccColors.gray85,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: FccColors.yellow50,
                  foregroundColor: FccColors.gray90,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'View',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
