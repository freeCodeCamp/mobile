import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/models/forum_post_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-create-comment/forum_create_comment_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/text_function_bar_widget.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
class ForumCreateCommentView extends StatelessWidget {
  ForumCreateCommentView({Key? key, required this.topicId, required this.post})
      : super(key: key);

  late String topicId;
  late PostModel post;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumCreateCommentViewModel>.reactive(
        viewModelBuilder: () => ForumCreateCommentViewModel(),
        builder: (context, model, child) => Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 16, right: 16),
                          child: TextField(
                            controller: model.commentText,
                            minLines: 10,
                            maxLines: null,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                fillColor: Colors.white,
                                filled: true),
                          ),
                        ))
                  ],
                ),
                ForumTextFunctionBar(
                  textController: model.commentText,
                  post: post,
                ),
                model.commentHasError
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Text(model.errorMesssage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            )),
                      )
                    : Container(),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary:
                                    const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                                side: const BorderSide(
                                    width: 2, color: Colors.white),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0))),
                            onPressed: () {
                              model.createComment(
                                  topicId, model.commentText.text);
                            },
                            child: const Text(
                              'PLACE COMMENT',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                  ],
                )
              ],
            ));
  }
}
