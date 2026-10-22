import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_viewmodel.g.dart';

@Riverpod(retry: noRetry)
Future<void> profileRefresh(Ref ref) {
  return ref.read(authProvider.notifier).refresh();
}
