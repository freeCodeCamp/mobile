import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_service.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio();

  if (dotenv.getBool('DEVELOPMENT_MODE', fallback: false)) {
    dio.interceptors.add(PrettyDioLogger(responseBody: false));
  }

  ref.onDispose(dio.close);

  return dio;
}
