import 'package:flutter/material.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';

class NewsTutorialHeader extends StatelessWidget {
  const NewsTutorialHeader({Key? key, required this.tutorial}) : super(key: key);

  final Tutorial tutorial;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              tutorial.featureImage,
              fit: BoxFit.cover,
            )),
        Row(
          children: [
            Expanded(
              child: Container(
                color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tutorial.title,
                      style: const TextStyle(
                          fontSize: 24, height: 1.5, fontFamily: 'Lato'),
                      key: const Key('title'),
                    ),
                    Text(
                      'Written by ${tutorial.authorName}',
                      style: const TextStyle(height: 1.5, fontFamily: 'Lato'),
                    ),
                    Wrap(
                      children: [
                        for (int j = 0;
                            j < tutorial.tagNames.length && j < 3;
                            j++)
                          tutorial.tagNames[j]
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
