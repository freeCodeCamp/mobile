import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:stacked_services/stacked_services.dart';

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final builders = {
    DialogType.basic: (contex, sheetRequest, completer) =>
        _BasicDialog(request: sheetRequest, completer: completer),
    DialogType.authform: (contex, sheetRequest, completer) => _AuthFormDialog(
          request: sheetRequest,
          onDialogTap: completer,
        )
  };

  dialogService.registerCustomDialogBuilders(builders);
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
                  Text(
                    request.title as String,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 16, right: 32.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      request.description as String,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                        controller: authCodeController,
                        maxLength: 6,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            helperText: 'Please enter a six digit code',
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
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  )
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
                        primary: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                        side: const BorderSide(width: 2, color: Colors.white),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onPressed: () => {
                          onDialogTap(DialogResponse(
                              data: authCodeController.text, confirmed: true)),
                          onDialogTap(DialogResponse())
                        },
                    child: const Text(
                      'LOGIN',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
          ],
        ));
  }
}
