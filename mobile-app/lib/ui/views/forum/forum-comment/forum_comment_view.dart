import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/models/forum/forum_post_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-html-handler/forum_html_handler.dart';
import 'package:freecodecamp/ui/views/forum/forum-post/forum_post_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/text_function_bar_widget.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class ForumCommentView extends StatelessWidget {
  late final String topicId;
  late final String postId;
  late final List<PostModel> topicPosts;
  late final String postSlug;
  late final String baseUrl;
  // ignore: prefer_const_constructors_in_immutables
  ForumCommentView(
      {Key? key,
      required this.topicPosts,
      required this.topicId,
      required this.postId,
      required this.postSlug,
      required this.baseUrl})
      : super(key: key);

  void initState() {
    dev.log(topicPosts.toString());
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostViewModel>.reactive(
        viewModelBuilder: () => PostViewModel(),
        onModelReady: (model) => initState(),
        builder: (context, model, child) => ListView.separated(
            separatorBuilder: (context, int i) => const Divider(
                  color: Color.fromRGBO(0x42, 0x42, 0x55, 1),
                  thickness: 2,
                  height: 2,
                ),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: topicPosts.length,
            itemBuilder: (context, index) {
              var post = topicPosts[index];
              return Container(
                color: model.recentlyDeletedPost &&
                        model.recentlyDeletedPostId == post.postId
                    ? Colors.red
                    : const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                child: Column(
                  children: [
                    commentHeader(model, post),
                    model.isEditingPost && model.editedPostId == post.postId
                        ? commentEditor(model, post)
                        : post.postAction != null
                            ? commentAction(model, post)
                            : htmlView(post, context, model),
                    post.postAction == null
                        ? commentFooter(post, model, context, index)
                        : Container()
                  ],
                ),
              );
            }));
  }

  Padding commentAction(PostViewModel model, PostModel post) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, bottom: 48, top: 24),
      child: model.postActionParser(
          post.postAction as String, post.postCreateDate),
    );
  }

  Row commentHeader(PostViewModel model, PostModel post) {
    return Row(
      children: [
        Row(children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: const Color.fromRGBO(0xAC, 0xD1, 0x57, 1))),
                    child: FadeInImage.assetNetwork(
                        height: 60,
                        placeholder:
                            'assets/images/placeholder-profile-img.png',
                        image: PostModel.fromDiscourse(post.profieImage)
                            ? PostModel.parseProfileAvatar(post.profieImage)
                            : baseUrl +
                                PostModel.parseProfileAvatar(
                                    post.profieImage))),
              ),
            ],
          ),
          Column(children: [
            post.isAdmin || post.isModerator || post.isStaff
                ? const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.shield,
                      color: Colors.white,
                    ),
                  )
                : Container()
          ]),
          Column(
            children: [
              Text(
                post.username,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              )
            ],
          )
        ]),
      ],
    );
  }

  Column commentEditor(PostViewModel model, PostModel post) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
                child: TextField(
                  controller: model.commentText,
                  minLines: 10,
                  maxLines: null,
                  decoration: const InputDecoration(
                      fillColor: Colors.white, filled: true),
                ),
              ),
            ),
          ],
        ),
        ForumTextFunctionBar(
          textController: model.commentText,
          post: post,
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                        side: const BorderSide(width: 2, color: Colors.white),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onPressed: () {
                      model.updatePost(topicPosts);
                    },
                    child: const Text(
                      'UPDATE COMMENT',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                        side: const BorderSide(width: 2, color: Colors.white),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onPressed: () {
                      model.cancelUpdatePost();
                    },
                    child: const Text(
                      'CANCEL',
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

  Column commentFooter(
      PostModel post, PostViewModel model, BuildContext context, int index) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                PostViewModel.parseDate(post.postCreateDate),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            IconButton(
              onPressed: () {
                model.parseShareUrl(post.postSlug, postId, index);
              },
              icon: const Icon(Icons.share_outlined),
              color: Colors.white,
            ),
            model.recentlyDeletedPost &&
                    model.recentlyDeletedPostId == post.postId
                ? IconButton(
                    onPressed: () {
                      model.recoverPost(post.postId);
                    },
                    icon: const Icon(
                      Icons.refresh_sharp,
                      color: Colors.white,
                    ))
                : Container(),
            Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: PopupMenuButton(
                      color: const Color(0xFF0a0a23),
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      itemBuilder: (context) => model.postOptionHandler(
                          post, model, postId, postSlug)),
                ),
              ]),
            )
          ],
        ),
      ],
    );
  }
}
