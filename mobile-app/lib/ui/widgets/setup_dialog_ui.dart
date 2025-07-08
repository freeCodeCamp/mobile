import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:url_launcher/url_launcher.dart';

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final builders = {
    DialogType.basic: (BuildContext context, DialogRequest sheetRequest,
            Function(DialogResponse) completer) =>
        _BasicDialog(request: sheetRequest, completer: completer),
    DialogType.buttonForm: (BuildContext context, DialogRequest sheetRequest,
            Function(DialogResponse) completer) =>
        _buttonDialog(request: sheetRequest, onDialogTap: completer),
    DialogType.askForHelp: (BuildContext context, DialogRequest sheetRequest,
            Function(DialogResponse) completer) =>
        _askForHelpDialog(request: sheetRequest, onDialogTap: completer),
    DialogType.askForHelpInput: (BuildContext context,
            DialogRequest sheetRequest, Function(DialogResponse) completer) =>
        _askForHelpInputDialogue(request: sheetRequest, onDialogTap: completer),
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

  const _buttonDialog({required this.request, required this.onDialogTap});

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
                    color: Colors.white,
                  ),
                ),
                Text(
                  request.description as String,
                  style: const TextStyle(
                    height: 1.5,
                    fontSize: 16,
                    color: Colors.white,
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
      {required this.request, required this.onDialogTap});

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

  const _buttonDialog2({required this.request, required this.onDialogTap});

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
  const _BasicDialog({required this.request, required this.completer});

  @override
  Widget build(BuildContext context) {
    return Dialog(child: Container());
  }
}

// ignore: camel_case_types
class _askForHelpInputDialogue extends HookWidget {
  final DialogRequest request;
  final Function(DialogResponse) onDialogTap;

  const _askForHelpInputDialogue({
    required this.request,
    required this.onDialogTap,
  });

  @override
  Widget build(BuildContext context) {
    final requestData = useState<Map<String, dynamic>>(request.data ?? {});
    final charCount =
        useState(requestData.value['issueDescription']?.length ?? 0);
    final textController = useTextEditingController(
      text: requestData.value['issueDescription'] ?? '',
    );

    return Dialog(
      backgroundColor: FccColors.gray90,
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
                    fontWeight: FontWeight.bold,
                    color: FccColors.gray00,
                  ),
                ),
                Text(
                  request.description as String,
                  style: const TextStyle(
                    fontSize: 16,
                    color: FccColors.gray05,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: requestData.value['readSearchAskChecked'] ??
                              false,
                          onChanged: (value) {
                            requestData.value = {
                              ...requestData.value,
                              'readSearchAskChecked': value,
                            };
                          },
                          activeColor: FccColors.gray00,
                        ),
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: 'I have tried the ',
                              style: const TextStyle(
                                fontSize: 14,
                                color: FccColors.gray00,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Read-Search-Ask',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: FccColors.gray00,
                                    decoration: TextDecoration.underline,
                                    decorationColor: FccColors.gray00,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launchUrl(Uri.parse(
                                          '$forumLocation/t/how-to-get-help-when-you-are-stuck-coding/19514'));
                                    },
                                ),
                                const TextSpan(
                                  text: ' method',
                                  style: TextStyle(color: FccColors.gray00),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: requestData.value['similarQuestionsChecked'] ??
                              false,
                          onChanged: (value) {
                            requestData.value = {
                              ...requestData.value,
                              'similarQuestionsChecked': value,
                            };
                          },
                          activeColor: FccColors.gray00,
                        ),
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: 'I have searched for ',
                              style: const TextStyle(
                                fontSize: 14,
                                color: FccColors.gray00,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      'similar questions that have already been answered on the forum',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: FccColors.gray00,
                                    decoration: TextDecoration.underline,
                                    decorationColor: FccColors.gray00,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      final query = Uri.encodeComponent(
                                          '${requestData.value['blockName']} - ${requestData.value['challengeName']} in:title');
                                      launchUrl(Uri.parse(
                                          '$forumLocation/search?q=$query'));
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (charCount.value < 50)
                  Text(
                    'Please enter at least ${50 - charCount.value} more characters.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: FccColors.gray00,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                TextField(
                  controller: textController,
                  onChanged: (value) {
                    requestData.value['issueDescription'] = value;
                    requestData.value = Map.from(requestData.value);
                    charCount.value = value.length;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Describe your issue in detail here...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FccColors.gray75,
                      foregroundColor: FccColors.gray00,
                      side: const BorderSide(width: 2, color: FccColors.gray00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed:
                        requestData.value['readSearchAskChecked'] == true &&
                                requestData.value['similarQuestionsChecked'] ==
                                    true &&
                                charCount.value >= 50
                            ? () => {
                                  onDialogTap(
                                    DialogResponse(
                                      confirmed: true,
                                      data: textController.text,
                                    ),
                                  ),
                                }
                            : null,
                    child: Text(
                      request.mainButtonTitle as String,
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
                      backgroundColor: FccColors.gray75,
                      foregroundColor: FccColors.gray00,
                      side: const BorderSide(width: 2, color: FccColors.gray00),
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
class _askForHelpDialog extends HookWidget {
  final DialogRequest request;
  final Function(DialogResponse) onDialogTap;

  const _askForHelpDialog({required this.request, required this.onDialogTap});

  @override
  Widget build(BuildContext context) {
    final requestData = useState<Map<String, dynamic>>(request.data ?? {});

    return Dialog(
      backgroundColor: FccColors.gray90,
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
                    fontWeight: FontWeight.bold,
                    color: FccColors.gray00,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: "If you've already tried the ",
                    style: const TextStyle(
                      fontSize: 16,
                      color: FccColors.gray05,
                    ),
                    children: [
                      TextSpan(
                        text: 'Read-Search-Ask',
                        style: const TextStyle(
                          fontSize: 16,
                          color: FccColors.gray00,
                          decoration: TextDecoration.underline,
                          decorationColor: FccColors.gray00,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse(
                                '$forumLocation/t/how-to-get-help-when-you-are-stuck-coding/19514'));
                          },
                      ),
                      const TextSpan(
                        text:
                            ' method, then you can ask for help on the freeCodeCamp forum.',
                        style: TextStyle(color: FccColors.gray05),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Before making a new post please ',
                    style: const TextStyle(
                      fontSize: 16,
                      color: FccColors.gray05,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'check if your question has already been answered on the forum',
                        style: const TextStyle(
                          fontSize: 16,
                          color: FccColors.gray00,
                          decoration: TextDecoration.underline,
                          decorationColor: FccColors.gray00,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            final query = Uri.encodeComponent(
                                '${requestData.value['blockName']} - ${requestData.value['challengeName']} in:title');
                            launchUrl(
                                Uri.parse('$forumLocation/search?q=$query'));
                          },
                      ),
                      const TextSpan(
                        text: '.',
                        style: TextStyle(color: FccColors.gray05),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FccColors.gray75,
                      foregroundColor: FccColors.gray00,
                      side: const BorderSide(width: 2, color: FccColors.gray00),
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
                      backgroundColor: FccColors.gray75,
                      foregroundColor: FccColors.gray00,
                      side: const BorderSide(width: 2, color: FccColors.gray00),
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
