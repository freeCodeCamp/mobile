import 'package:freecodecamp/auth/repositories/session_repository.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_account_viewmodel.g.dart';

@riverpod
class DeleteAccountNotifier extends _$DeleteAccountNotifier {
  @override
  bool build() => false;

  Future<String> deleteAccount() async {
    final auth = ref.read(authProvider.notifier);
    state = true;

    try {
      await auth.deleteAccount();
      return 'Account deleted successfully';
    } on SessionExpiredException {
      return 'Your session has expired. Please log in again.';
    } catch (_) {
      return 'Account deletion failed. Please try again later.';
    } finally {
      if (ref.mounted) state = false;
    }
  }
}
