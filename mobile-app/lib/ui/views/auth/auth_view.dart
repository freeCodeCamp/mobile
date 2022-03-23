import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/auth/auth_viemodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
      onModelReady: (model) => model.initState(),
      viewModelBuilder: () => AuthViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFF0a0a23),
        appBar: AppBar(
          title: const Text('LOGIN'),
        ),
        drawer: const DrawerWidgetView(),
        body: Center(
          child: model.isAuthBusy
              ? const CircularProgressIndicator()
              : model.isLoggedIn
                  ? Profile(
                      logoutAction: model.logoutAction,
                      name: model.name,
                      picture: model.picture,
                    )
                  : Login(
                      loginAction: model.loginAction,
                      loginError: model.errorMessage,
                    ),
        ),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  final Function logoutAction;
  final String name;
  final String picture;

  const Profile({
    Key? key,
    required this.logoutAction,
    required this.name,
    required this.picture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 4.0),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(picture),
            ),
          ),
        ),
        const SizedBox(height: 24.0),
        Text('Name: $name'),
        const SizedBox(height: 48.0),
        ElevatedButton(
          onPressed: () {
            logoutAction();
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}

class Login extends StatelessWidget {
  final Function loginAction;
  final String loginError;

  const Login({
    Key? key,
    required this.loginAction,
    required this.loginError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            loginAction();
          },
          child: const Text('Login'),
        ),
        Text(loginError),
      ],
    );
  }
}
