import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:stacked/stacked.dart';
import 'forum_create_post_viewmodel.dart';

class ForumCreatePostViewmodel extends StatelessWidget {
  const ForumCreatePostViewmodel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumCreatePostModel>.reactive(
        viewModelBuilder: () => ForumCreatePostModel(),
        builder: (context, model, chilld) => Padding(
              padding: const EdgeInsets.only(top: 75, left: 16, right: 16),
              child: createPostTemplate(model, context),
            ));
  }
}

Column createPostTemplate(ForumCreatePostModel model, context) {
  return Column(
    children: [
      Row(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.60,
              child: TextField(
                controller: model.title,
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0)),
                    label: const Text(
                      'Title',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
              ))
        ],
      ),
      Row(
        children: const [
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              'Your code',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      Row(
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: model.code,
                minLines: 10,
                maxLines: null,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0)),
                ),
              ),
            ),
          )
        ],
      ),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                      side: const BorderSide(width: 2, color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0))),
                  onPressed: () {
                    model.createPost(model.title.text, model.code.text);
                  },
                  child: const Text(
                    'CREATE NEW POST',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
        ],
      )
    ],
  );
}
