import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/forum/forum-create-comment/forum_create_comment_viewmodel.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
class ForumCreateCommentView extends StatelessWidget {
  ForumCreateCommentView({Key? key, required this.topicId}) : super(key: key);

  late String topicId;

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
                            decoration: InputDecoration(
                                errorText: model.commentHasError
                                    ? model.errorMesssage
                                    : null,
                                fillColor: Colors.white,
                                filled: true),
                          ),
                        ))
                  ],
                ),
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
