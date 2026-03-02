import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/core/providers/service_providers.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:freecodecamp/service/dio_service.dart';

class NativeLoginState {
  const NativeLoginState({
    this.showOTPfield = false,
    this.incorrectOTP = false,
    this.emailFieldIsValid = false,
    this.otpFieldIsValid = false,
  });

  final bool showOTPfield;
  final bool incorrectOTP;
  final bool emailFieldIsValid;
  final bool otpFieldIsValid;

  NativeLoginState copyWith({
    bool? showOTPfield,
    bool? incorrectOTP,
    bool? emailFieldIsValid,
    bool? otpFieldIsValid,
  }) {
    return NativeLoginState(
      showOTPfield: showOTPfield ?? this.showOTPfield,
      incorrectOTP: incorrectOTP ?? this.incorrectOTP,
      emailFieldIsValid: emailFieldIsValid ?? this.emailFieldIsValid,
      otpFieldIsValid: otpFieldIsValid ?? this.otpFieldIsValid,
    );
  }
}

class NativeLoginNotifier extends Notifier<NativeLoginState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final Dio _dio = DioService.dio;

  late AuthenticationService auth;
  late DeveloperService developerService;

  @override
  NativeLoginState build() {
    auth = ref.watch(authenticationServiceProvider);
    developerService = ref.watch(developerServiceProvider);
    ref.onDispose(() {
      emailController.dispose();
      otpController.dispose();
    });
    return const NativeLoginState();
  }

  void init() async {
    bool isEmail(String em) {
      String p =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      RegExp regExp = RegExp(p);

      return regExp.hasMatch(em);
    }

    emailController.addListener(() {
      if (isEmail(emailController.text)) {
        state = state.copyWith(emailFieldIsValid: true);
      } else if (state.emailFieldIsValid) {
        state = state.copyWith(emailFieldIsValid: false);
      }
    });

    otpController.addListener(() {
      if (RegExp(r'^[0-9]{6}$').hasMatch(otpController.text)) {
        state = state.copyWith(otpFieldIsValid: true);
      } else if (state.emailFieldIsValid) {
        state = state.copyWith(otpFieldIsValid: false);
      }
    });
  }

  void sendOTPtoEmail() async {
    state = state.copyWith(showOTPfield: true);
    await dotenv.load();
    await _dio.post(
      'https://${dotenv.get('AUTH0_DOMAIN')}/passwordless/start',
      data: {
        'client_id': dotenv.get('AUTH0_CLIENT_ID'),
        'connection': 'email',
        'email': emailController.text,
        'send': 'code',
      },
    );
  }

  void verifyOTP(BuildContext context) async {
    await dotenv.load();
    bool isSuccess = await auth.login(
      context,
      'email',
      email: emailController.text,
      otp: otpController.text,
    );
    if (isSuccess) {
      state = state.copyWith(incorrectOTP: false);
    } else {
      state = state.copyWith(incorrectOTP: true);
    }
  }
}

final nativeLoginProvider =
    NotifierProvider<NativeLoginNotifier, NativeLoginState>(
  NativeLoginNotifier.new,
);
