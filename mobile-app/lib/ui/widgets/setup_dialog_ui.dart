import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:stacked_services/stacked_services.dart';

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final builders = {
    DialogType.basic: (BuildContext context, DialogRequest sheetRequest,
            Function(DialogResponse) completer) =>
        _BasicDialog(request: sheetRequest, completer: completer),
    DialogType.authform: (BuildContext context, DialogRequest sheetRequest,
            Function(DialogResponse) completer) =>
        _AuthFormDialog(request: sheetRequest, onDialogTap: completer),
    DialogType.inputForm: (BuildContext context, DialogRequest sheetRequest,
            Function(DialogResponse) completer) =>
        _InputFormDialog(request: sheetRequest, onDialogTap: completer),
    DialogType.buttonForm: (BuildContext context, DialogRequest sheetRequest,
            Function(DialogResponse) completer) =>
        _buttonDialog(request: sheetRequest, onDialogTap: completer),
    DialogType.buttonForm2: (BuildContext context, DialogRequest sheetRequest,
            Function(DialogResponse) completer) =>
        _buttonDialog(request: sheetRequest, onDialogTap: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}

// ignore: camel_case_types
class _buttonDialog extends HookWidget {
  final DialogRequest request;
  final Function(DialogResponse) onDialogTap;

  const _buttonDialog(
      {Key? key, required this.request, required this.onDialogTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0a0a23),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              runSpacing: 20,
              children: [
                Text(
                  request.title as String,
                  style: const TextStyle(
                    fontSize: 24,
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  request.description as String,
                  style: const TextStyle(
                    height: 1.5,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                        side: const BorderSide(width: 2, color: Colors.white),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onPressed: () => {
                      onDialogTap(
                          DialogResponse(data: 'gallery', confirmed: true)),
                    },
                    child: Text(
                      request.mainButtonTitle as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ignore: camel_case_types, unused_element
class _buttonDialog2 extends HookWidget {
  final DialogRequest request;
  final Function(DialogResponse) onDialogTap;

  const _buttonDialog2(
      {Key? key, required this.request, required this.onDialogTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0a0a23),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              children: [
                Text(
                  request.title as String,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    request.description as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 32, top: 8, right: 32, bottom: 8),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                    side: const BorderSide(width: 2, color: Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0))),
                onPressed: () => {
                  onDialogTap(DialogResponse(data: 'confirmed')),
                },
                child: Text(
                  request.mainButtonTitle as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputFormDialog extends HookWidget {
  final DialogRequest request;
  final Function(DialogResponse) onDialogTap;
  const _InputFormDialog(
      {Key? key, required this.request, required this.onDialogTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    return Dialog(
      backgroundColor: const Color(0xFF0a0a23),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              children: [
                Text(
                  request.title as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    request.description as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 16, right: 32.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: TextField(
                      controller: controller,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        helperStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 32, top: 8, right: 32, bottom: 32),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                    side: const BorderSide(width: 2, color: Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0))),
                onPressed: () => {
                  onDialogTap(
                      DialogResponse(data: controller.text, confirmed: true)),
                },
                child: Text(
                  request.mainButtonTitle as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BasicDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const _BasicDialog({Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(child: Container());
  }
}

class _AuthFormDialog extends HookWidget {
  final DialogRequest request;
  final Function(DialogResponse) onDialogTap;
  const _AuthFormDialog(
      {Key? key, required this.request, required this.onDialogTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCodeController = useTextEditingController();
    return Dialog(
      backgroundColor: const Color(0xFF0a0a23),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    request.title as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    request.description as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 16, right: 32.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 75,
                    child: TextField(
                      controller: authCodeController,
                      maxLength: 6,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        helperText: 'Please enter the six digit code',
                        helperStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                        label: const Text(
                          'Code',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 32, top: 8, right: 32, bottom: 32),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                      side: const BorderSide(width: 2, color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0))),
                  onPressed: () => {
                    onDialogTap(DialogResponse(
                        data: authCodeController.text, confirmed: true)),
                  },
                  child: const Text(
                    'LOGIN',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
