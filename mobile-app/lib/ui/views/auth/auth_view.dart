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
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Logged In'),
                          ElevatedButton(
                            onPressed: model.logoutAction,
                            child: const Text('Logout'),
                          ),
                          ElevatedButton(
                            onPressed: model.fetchUser,
                            child: const Text('Fetch User'),
                          ),
                          model.user != null
                              ? Text('User: ${model.user}')
                              : Container(),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: model.loginAction,
                          child: const Text('Login'),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
