import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioService {
  static final DioService _dioService = DioService._internal();

  static final Dio dio = Dio();

  factory DioService() {
    return _dioService;
  }

  Future<void> init() async {
    await dotenv.load();
    bool isDevMode =
        dotenv.get('DEVELOPMENTMODE', fallback: '').toLowerCase() == 'true';

    if (isDevMode) {
      dio.interceptors.add(PrettyDioLogger(responseBody: false));
    }
  }

  DioService._internal();
}
