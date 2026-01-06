
import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/chapter/chapter_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ChapterView extends StatelessWidget {
  const ChapterView({
    super.key,
    required this.superBlockDashedName,
    required this.superBlockName,
  });

  final String superBlockDashedName;
  final String superBlockName;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChapterViewModel>.reactive(
      viewModelBuilder: () => ChapterViewModel(),
      onViewModelReady: (model) => model.init(
        superBlockDashedName,
        superBlockName,
      ),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: FccColors.gray90,
          appBar: AppBar(
            title: Text(superBlockName),
          ),
          body: StreamBuilder(
            stream: model.auth.progress.stream,
            builder: (context, snapshot) {
              return FutureBuilder(
                future: model.superBlockFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          'Error loading chapters: ${snapshot.error} ${snapshot.stackTrace}'),
                    );
                  }

                  if (snapshot.hasData) {
                    SuperBlock superBlock = snapshot.data as SuperBlock;

                    List exams = [
                      'responsive-web-design-certification-exam',
                      'javascript-certification-exam',
                      'python-certification-exam'
                    ];

                    List<Chapter> chapters =
                        (superBlock.chapters as List<Chapter>).where((chapter) => !exams.contains(chapter.dashedName)).toList();

                    return ListView(
                      shrinkWrap: true,
                      children: [
                        Column(
                          children: [
                            ...[
                              for (Chapter chapter in chapters)
                                chapterBlock(
                                    superBlock, chapter, model, context)
                            ]
                          ],
                        ),
                      ],
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget chapterBlock(
    SuperBlock superBlock,
    Chapter chapter,
    ChapterViewModel model,
    BuildContext context,
  ) {
    bool disabled = chapter.dashedName == 'frontend-libraries' && !model.isDev;

    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0x1b, 0x1b, 0x32, 1),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    chapter.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (chapter.comingSoon != null && chapter.comingSoon == true ||
                    disabled)
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text('Coming Soon'),
                  ),
                for (Module module in chapter.modules as List<Module>)
                  chapterButton(context, module, model, chapter)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container chapterButton(
    BuildContext context,
    Module module,
    ChapterViewModel model,
    Chapter chapter,
  ) {
    bool disabled = chapter.dashedName == 'frontend-libraries' && !model.isDev;
    if (module.comingSoon != null && module.comingSoon == true || disabled) {
      return Container();
    }

    bool isSingleStep = model.isSingleStepModule(module);
    Color moduleColor = model.getModuleColor(module);
    bool isReview = module.blocks != null &&
                    module.blocks!.isNotEmpty &&
                    module.blocks!.first.label == BlockLabel.review;
    bool isCertProject = module.moduleType == ModuleType.certProject;
    Color backgroundColor = isSingleStep
        ? moduleColor.withValues(alpha: 0.3)
        : moduleColor.withValues(alpha: 0.1);
    Color borderColor = isSingleStep
        ? moduleColor.withValues(alpha: 0.5)
        : moduleColor.withValues(alpha: 0.4);
    Color textColor = isSingleStep ? moduleColor : Colors.white;

    return Container(
      margin: const EdgeInsets.all(5),
      constraints: BoxConstraints(minHeight: 100, maxHeight: 200),
      width: MediaQuery.of(context).size.width * 0.90,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: TextButton(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.all(12),
          ),
          alignment: Alignment.centerLeft,
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          backgroundColor: WidgetStatePropertyAll<Color>(Colors.transparent),
          overlayColor: WidgetStatePropertyAll<Color>(
            Colors.white.withValues(alpha: 0.1),
          ),
        ),
        onPressed: () {
          if (isSingleStep && module.blocks!.isNotEmpty) {
            Block firstBlock = module.blocks!.first;
            if (firstBlock.challenges.isNotEmpty) {
              model.routeToChallengeView(
                firstBlock,
                firstBlock.challenges.first.id,
              );
            }
          } else {
            model.routeToBlockView(module.blocks!, module.name);
          }
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    module.name,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  if (isCertProject)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Certification Project',
                        style: TextStyle(
                          color: moduleColor.withValues(alpha: 0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (isReview)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Review',
                        style: TextStyle(
                          color: moduleColor.withValues(alpha: 0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (!isSingleStep && !isReview)
                    FutureBuilder(
                      future: model.calculateProgress(module),
                      builder: (context, snapshot) {
                        String steps = snapshot.data ?? '0';

                        return Text(
                          '$steps Steps Complete',
                          style: TextStyle(
                            color: FccColors.gray15,
                            fontSize: 18,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Icon(
              isSingleStep
                  ? Icons.play_arrow_rounded
                  : Icons.arrow_forward_ios_outlined,
              size: 25,
              color: textColor,
            )
          ],
        ),
      ),
    );
  }
}
