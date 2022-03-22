import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/auth/auth_viemodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
      viewModelBuilder: () => AuthViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFF0a0a23),
        appBar: AppBar(
          title: const Text('LOGIN'),
        ),
        drawer: const DrawerWidgetView(),
        body: const Center(
          child: Text('LOGIN VIEW'),
        ),
      ),
    );
  }
}
