import 'package:mobile_app_new/services/auth_service.dart';
import 'package:mobile_app_new/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_viewmodel.g.dart';

@Riverpod(retry: noRetry)
Future<void> profileRefresh(Ref ref) {
  return ref.read(authProvider.notifier).refresh();
}
