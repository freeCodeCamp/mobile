import 'package:dio/dio.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:stacked/stacked.dart';

class DailyChallengesViewModel extends BaseViewModel {
  final Dio _dio = DioService.dio;
  List<dynamic> _dailyChallenges = [];
  bool _isJulyOpen = true;
  bool _isJuneOpen = false;
  bool _isMayOpen = false;

  List<dynamic> get dailyChallenges => _dailyChallenges;
  bool get isJulyOpen => _isJulyOpen;
  bool get isJuneOpen => _isJuneOpen;
  bool get isMayOpen => _isMayOpen;

  List<dynamic> get julyChallenges => _dailyChallenges.take(30).toList();
  List<dynamic> get juneChallenges =>
      _dailyChallenges.skip(30).take(30).toList();
  List<dynamic> get mayChallenges =>
      _dailyChallenges.skip(60).take(30).toList();

  void toggleJulyOpen() {
    _isJulyOpen = !_isJulyOpen;
    notifyListeners();
  }

  void toggleJuneOpen() {
    _isJuneOpen = !_isJuneOpen;
    notifyListeners();
  }

  void toggleMayOpen() {
    _isMayOpen = !_isMayOpen;
    notifyListeners();
  }

  Future<void> fetchDailyChallenges() async {
    setBusy(true);
    try {
      Response response = await _dio.get(
        'http://localhost:3000/api/daily-challenge/all',
        options: Options(),
      );

      if (response.statusCode == 200) {
        _dailyChallenges = response.data;
      } else {
        // Handle error
        print('Error fetching daily challenges: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    } finally {
      setBusy(false);
    }
  }
}
