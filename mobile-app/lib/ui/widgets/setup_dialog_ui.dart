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
    DialogType.buttonForm: (BuildContext context, DialogRequest sheetRequest,
            Function(DialogResponse) completer) =>
        _buttonDialog(request: sheetRequest, onDialogTap: completer),
    DialogType.deleteAccount: (BuildContext context, DialogRequest sheetRequest,
            Function(DialogResponse) completer) =>
        _deleteAccountDialog(request: sheetRequest, onDialogTap: completer),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
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
                      backgroundColor:
                          const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                      side: const BorderSide(width: 2, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () => {
                      onDialogTap(DialogResponse(confirmed: true)),
                    },
                    child: Text(
                      request.mainButtonTitle as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                      side: const BorderSide(width: 2, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () => {
                      onDialogTap(DialogResponse(confirmed: false)),
                    },
                    child: Text(
                      request.secondaryButtonTitle ?? 'Cancel',
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

// ignore: camel_case_types
class _deleteAccountDialog extends HookWidget {
  final DialogRequest request;
  final Function(DialogResponse) onDialogTap;

  const _deleteAccountDialog(
      {Key? key, required this.request, required this.onDialogTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0a0a23),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      backgroundColor: Colors.red.shade100,
                      foregroundColor: Colors.red.shade900,
                      side: BorderSide(
                        width: 2,
                        color: Colors.red.shade900,
                      ),
                      disabledBackgroundColor: Colors.red.shade50,
                      disabledForegroundColor: Colors.red.shade700,
                    ),
                    onPressed: () => {
                      onDialogTap(DialogResponse(confirmed: true)),
                    },
                    child: Text(
                      request.mainButtonTitle?.toUpperCase() as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                      side: const BorderSide(width: 2, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () => {
                      onDialogTap(DialogResponse(confirmed: false)),
                    },
                    child: Text(
                      request.secondaryButtonTitle ?? 'Cancel',
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
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
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
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
