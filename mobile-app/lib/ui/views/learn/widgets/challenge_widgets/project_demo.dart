import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_viewmodel.dart';

class ProjectDemo extends StatelessWidget {
  const ProjectDemo({
    super.key,
    required this.solutions,
    required this.model,
  });

  final List<List<SolutionFile>>? solutions;
  final ChallengeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Demo'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: model.provideDemo(solutions),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data is String) {
                      return InAppWebView(
                        initialData: InAppWebViewInitialData(
                          data: snapshot.data as String,
                          mimeType: 'text/html',
                        ),
                        onWebViewCreated: (controller) {
                          model.setWebviewController = controller;
                        },
                        initialSettings: InAppWebViewSettings(
                          // TODO: Set this to true only in dev mode
                          isInspectable: true,
                        ),
                      );
                    }
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(context.t.error),
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
