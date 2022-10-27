import 'package:flutter/material.dart';
import 'package:freecodecamp/models/forum/forum_post_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-html-handler/forum_html_handler.dart';
import 'package:freecodecamp/ui/views/forum/widgets/text_function_bar_widget.dart';
import 'package:stacked/stacked.dart';

import 'forum_post_viewmodel.dart';
import 'dart:developer' as dev;

class ForumPostView extends StatelessWidget {
  final String id;
  final String slug;

  const ForumPostView({Key? key, required this.id, required this.slug})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostViewModel>.reactive(
        viewModelBuilder: () => PostViewModel(),
        onModelReady: (model) => model.initState(id, slug),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: const Text('Back To Feed'),
              ),
              body: RefreshIndicator(
                backgroundColor: const Color(0xFF0a0a23),
                color: Colors.white,
                onRefresh: () => model.initState(id, slug),
                child: SingleChildScrollView(
                    child: Container(
                        color: const Color(0xFF0a0a23),
                        child: postViewTemplate(model, id, slug))),
              ),
            ));
  }

  Column postViewTemplate(PostViewModel model, id, slug) {
    return Column(
      children: [
        FutureBuilder<PostModel>(
            future: model.future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var post = snapshot.data;
                return Column(
                  children: [
                    Container(
                      color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                post!.postName as String,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    topicHeader(model, post),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 300),
                      child: Container(
                        child: model.isEditingPost
                            ? topicEditor(model, post)
                            : htmlView(post, context, model),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: topicFooter(model, post, context),
                    ),
                    model.baseUrl != ''
                        ? model.postBuilder(slug, id)
                        : Container(),
                    model.isLoggedIn
                        ? createPost(model, context, post)
                        : loginTemplate(context, model)
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            })
      ],
    );
  }

  Padding loginTemplate(BuildContext context, PostViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'LOGIN TO POST A MESSAGE',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                side: const BorderSide(width: 2, color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              onPressed: () {
                model.goToLoginPage();
              },
              child: const Text(
                'LOGIN',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row topicHeader(PostViewModel model, PostModel post) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            model.goToUserProfile(post.username);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 24),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      post.username,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 48.0),
                    child: Text(
                      PostViewModel.parseDateShort(post.postCreateDate),
                      style: const TextStyle(
                        color: Color.fromRGBO(0xa9, 0xaa, 0xb2, 1),
                        fontSize: 24,
                      ),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ],
    );
  }

  Column topicEditor(PostViewModel model, PostModel post) {
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
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
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
                        backgroundColor:
                            const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                        side: const BorderSide(width: 2, color: Colors.white),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onPressed: () {
                      model.updateTopic(id, post.postSlug);
                    },
                    child: const Text(
                      'UPDATE TOPIC',
                      textAlign: TextAlign.center,
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
                        backgroundColor:
                            const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
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
            )
          ],
        )
      ],
    );
  }

  Column createPost(PostViewModel model, BuildContext context, PostModel post) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: TextField(
                    controller: model.createPostText,
                    minLines: 10,
                    maxLines: null,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
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
          textController: model.createPostText,
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
                        backgroundColor:
                            const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                        side: const BorderSide(width: 2, color: Colors.white),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0))),
                    onPressed: () {
                      dev.log(post.postId.toString());
                      model.createPost(id, model.createPostText.text, post);
                    },
                    child: const Text(
                      'PLACE COMMENT',
                      textAlign: TextAlign.center,
                    )),
              ),
            ),
          ],
        )
      ],
    );
  }

  Row topicFooter(PostViewModel model, PostModel post, BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            model.parseShareUrl(post.postSlug, id);
          },
          icon: const Icon(Icons.share_outlined),
        ),
        post.postCanEdit && !model.isEditingPost
            ? IconButton(
                onPressed: () {
                  model.editPost(post.postId, post.postCooked);
                },
                icon: const Icon(
                  Icons.edit_sharp,
                ))
            : Container(),
        post.postCanDelete
            ? IconButton(
                onPressed: () {
                  model.deleteTopic(id, context);
                },
                icon: const Icon(
                  Icons.delete_sharp,
                ))
            : Container()
      ],
    );
  }
}
