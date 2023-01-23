import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_model.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({
    Key? key,
    required this.model,
    required this.block,
  }) : super(key: key);

  final BlockViewModel model;
  final Block block;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!model.isDownloaded || model.isDownloading)
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: !model.isDownloading
                  ? () async {
                      await model.startDownload(block);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              ),
              child: !model.isDownloading
                  ? const Text('Download All Challenges')
                  : StreamBuilder(
                      stream: model.learnOfflineService.downloadStream.stream,
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Starting Download...');
                        }

                        // if (snapshot.hasError) {
                        //   model.stopDownload(block.dashedName);

                        //   Timer(const Duration(seconds: 5), () {
                        //     model.setIsDownloading = false;
                        //   });

                        //   return const Text('An Error has Occured');
                        // }

                        if (snapshot.hasData) {
                          return Text(
                            '${(snapshot.data as double).toStringAsFixed(2)}%',
                          );
                        }

                        return const Text(
                          'Download All Challenges',
                        );
                      }),
                    ),
            ),
          ),
        if (model.isDownloaded || model.isDownloading)
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: () async {
                model.isDownloading
                    ? model.stopDownload(block, false)
                    : model.stopDownload(block, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              ),
              child: model.isDownloading
                  ? const Text('Cancel Downloading Challenges')
                  : const Text('Delete Downloaded Challenges'),
            ),
          )
      ],
    );
  }
}
