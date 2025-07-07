import 'package:dio/dio.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:stacked/stacked.dart';

class DailyChallengesViewModel extends BaseViewModel {
  final Dio _dio = DioService.dio;

  List<Block> _blocks = [];
  List<Block> get blocks => _blocks;

  Map<String, bool> _blockOpenStates = {};
  Map<String, bool> get blockOpenStates => _blockOpenStates;

  void toggleBlock(String blockId) {
    _blockOpenStates[blockId] = !(_blockOpenStates[blockId] ?? false);
    notifyListeners();
  }

  Future<void> fetchDailyChallenges() async {
    setBusy(true);
    try {
      Response response = await _dio.get(
        // TODO: Change this to use AuthenticationService.baseURL
        // when the API is deployed.
        'http://localhost:3000/api/daily-challenge/all',
        options: Options(),
      );

      if (response.statusCode == 200) {
        Map<String, List<Map<String, dynamic>>> challengesByMonth = {};

        for (var item in response.data as List) {
          String monthYear = _formatBlockFromDate(item['date']);
          if (!challengesByMonth.containsKey(monthYear)) {
            challengesByMonth[monthYear] = [];
          }
          challengesByMonth[monthYear]!.add(item);
        }

        // Sort months in descending order (newest first)
        List<String> sortedMonths = challengesByMonth.keys.toList()
          ..sort((a, b) {
            DateTime dateA = _parseMonthYear(a);
            DateTime dateB = _parseMonthYear(b);
            return dateB.compareTo(dateA);
          });

        _blocks = [];
        _blockOpenStates = {};

        // Create a block for each month
        for (String monthYear in sortedMonths) {
          List<Map<String, dynamic>> monthChallenges =
              challengesByMonth[monthYear]!;

          // Sort challenges within the month in ascending order (oldest first)
          monthChallenges.sort((a, b) {
            DateTime dateA = DateTime.parse(a['date']);
            DateTime dateB = DateTime.parse(b['date']);
            return dateA.compareTo(dateB);
          });

          final List<ChallengeListTile> tiles = monthChallenges
              .map((item) => ChallengeListTile(
                    id: item['_id'],
                    name: item['title'],
                    dashedName: (item['title'] as String)
                        .toLowerCase()
                        .replaceAll(' ', '-'),
                  ))
              .toList();

          String blockId =
              'daily-challenges-${monthYear.toLowerCase().replaceAll(' ', '-')}';

          // The API doesn't return all the required fields for blocks,
          // so improvisation is needed here.
          Block monthBlock = Block(
            superBlock: SuperBlock(
                dashedName: 'daily-coding-challenges',
                name: 'Daily Coding Challenges'),
            layout: BlockLayout.challengeGrid,
            type: BlockType.legacy,
            name: monthYear,
            dashedName: blockId,
            description: [
              'Explore the daily coding challenges for $monthYear. Stay motivated and keep your learning streak alive!'
            ],
            challenges: tiles
                .map((e) => ChallengeOrder(id: e.id, title: e.name))
                .toList(),
            challengeTiles: tiles,
          );

          _blocks.add(monthBlock);
          _blockOpenStates[blockId] = false;
        }

        if (_blocks.isNotEmpty) {
          _blockOpenStates[_blocks.first.dashedName] = true;
        }
      } else {
        print('Error fetching daily challenges: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    } finally {
      setBusy(false);
    }
  }

  String _formatBlockFromDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${monthNames[date.month - 1]} ${date.year}';
  }

  DateTime _parseMonthYear(String monthYear) {
    // Parse "January 2025" format back to DateTime
    List<String> parts = monthYear.split(' ');
    String monthName = parts[0];
    int year = int.parse(parts[1]);

    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    int month = monthNames.indexOf(monthName) + 1;
    return DateTime(year, month, 1);
  }
}
