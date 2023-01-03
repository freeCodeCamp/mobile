import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/news/news-image-viewer/news_image_model.dart';
import 'package:stacked/stacked.dart';
import 'package:photo_view/photo_view.dart';

class NewsImageView extends StatelessWidget {
  const NewsImageView({Key? key, required this.imgUrl}) : super(key: key);

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => NewsImageModel(),
      builder: (context, model, child) => Scaffold(
        body: PhotoView(
          backgroundDecoration: const BoxDecoration(
            color: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            backgroundBlendMode: BlendMode.color,
          ),
          imageProvider: NetworkImage(imgUrl),
        ),
      ),
    );
  }
}
