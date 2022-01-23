import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/code_radio/code_radio_viemodel.dart';
import 'package:stacked/stacked.dart';

class CodeRadioView extends StatelessWidget {
  const CodeRadioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CodeRadioViewModel>.reactive(
        viewModelBuilder: () => CodeRadioViewModel(),
        onModelReady: (model) => model.initRadio(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: Text('CODE RADIO'),
              ),
              body: Container(),
            ));
  }
}
