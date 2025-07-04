import 'package:dio/dio.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:stacked/stacked.dart';

class DailyChallengesViewModel extends BaseViewModel {
  final Dio _dio = DioService.dio;
  List<dynamic> _dailyChallenges = [];

  List<dynamic> get dailyChallenges => _dailyChallenges;

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
