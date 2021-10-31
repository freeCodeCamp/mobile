import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_awesome_web_names/flutter_font_awesome.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:freecodecamp/models/forum_post_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-post/forum_post_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/text_function_bar_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as dev;

class ForumCommentView extends StatelessWidget {
  late final List<PostModel> comments;
  late final String postId;
  late final String postSlug;
  // ignore: prefer_const_constructors_in_immutables
  ForumCommentView(
      {Key? key,
      required this.comments,
      required this.postId,
      required this.postSlug})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostViewModel>.reactive(
        viewModelBuilder: () => PostViewModel(),
        builder: (context, model, child) => ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              var post = comments[index];
              return Container(
                color: model.recentlyDeletedPost &&
                        model.recentlyDeletedPostId == post.postId
                    ? Colors.red
                    : const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        model.goToUserProfile(post.username);
                      },
                      child: commentHeader(model, post),
                    ),
                    model.isEditingPost && model.editedPostId == post.postId
                        ? commentEditor(model, post)
                        : commentHtml(index, context, comments, model),
                    commentFooter(post, model, context),
                  ],
                ),
              );
            }));
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
                            width: 4, color: model.randomBorderColor())),
                    child: FadeInImage.assetNetwork(
                        height: 60,
                        placeholder:
                            'assets/images/placeholder-profile-img.png',
                        image: PostViewModel.parseProfileAvatUrl(
                            post.profieImage, "60"))),
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
                      model.updatePost(postId, postSlug);
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
                      'CANCEL ',
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

  Container commentFooter(
      PostModel post, PostViewModel model, BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 2, color: Colors.white))),
      child: Column(
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
                  model.parseShareUrl(context, post.postSlug);
                },
                icon: const Icon(Icons.share_outlined),
                color: Colors.white,
              ),
              post.postCanEdit && !model.isEditingPost
                  ? IconButton(
                      onPressed: () {
                        model.editPost(post.postId, post.postCooked!);
                      },
                      icon: const Icon(
                        Icons.edit_sharp,
                        color: Colors.white,
                      ))
                  : Container(),
              post.postCanDelete
                  ? model.recentlyDeletedPost &&
                          model.recentlyDeletedPostId == post.postId
                      ? IconButton(
                          onPressed: () {
                            model.recoverPost(post.postId);
                          },
                          icon: const Icon(
                            Icons.refresh_sharp,
                            color: Colors.white,
                          ))
                      : IconButton(
                          onPressed: () {
                            // first id is the comment id
                            model.deletePost(post.postId, postId, postSlug);
                          },
                          icon: const Icon(
                            Icons.delete_sharp,
                            color: Colors.white,
                          ))
                  : Container()
            ],
          ),
        ],
      ),
    );
  }
}

Column commentHtml(int index, BuildContext context, List<PostModel> posts,
    PostViewModel model) {
  var post = posts[index];
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Html(
                shrinkWrap: true,
                data: post.postCooked,
                style: {
                  "aside": Style(
                      border: Border.all(width: 2, color: Colors.white),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(16)),
                  "body": Style(color: Colors.white),
                  "blockquote": Style(
                      backgroundColor:
                          const Color.fromRGBO(0x65, 0x65, 0x74, 1),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8)),
                  "p": Style(
                      fontSize: FontSize.rem(1.35),
                      lineHeight: LineHeight.em(1.2)),
                  "ul": Style(fontSize: FontSize.xLarge),
                  "li": Style(
                    margin: const EdgeInsets.only(top: 8),
                    fontSize: FontSize.rem(1.35),
                  ),
                  "pre": Style(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                  ),
                  "tr": Style(
                      border:
                          const Border(bottom: BorderSide(color: Colors.grey)),
                      backgroundColor: Colors.white),
                  "th": Style(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: const Color.fromRGBO(0xdf, 0xdf, 0xe2, 1),
                    color: Colors.black,
                  ),
                  "td": Style(
                    padding: const EdgeInsets.all(12),
                    color: Colors.black,
                    alignment: Alignment.topLeft,
                  ),
                },
                customRender: {
                  "table": (context, child) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: (context.tree as TableLayoutElement)
                          .toWidget(context),
                    );
                  },
                  "code": (code, child) {
                    var classList = code.tree.elementClasses;
                    if (classList.isNotEmpty && classList[0] == 'lang-auto') {
                      return ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 1,
                          maxHeight: 250,
                        ),
                        child: SyntaxView(
                          code: code.tree.element?.text as String,
                          syntax: Syntax.JAVASCRIPT,
                          syntaxTheme: SyntaxTheme.vscodeDark(),
                          fontSize: 16.0,
                          withZoom: false,
                          withLinesCount: false,
                        ),
                      );
                    }
                  },
                  "svg": (context, child) {
                    var iconParent = context.tree.element!.className;
                    var isFontAwesomeIcon = iconParent
                        .toString()
                        .contains(RegExp(r'fa ', caseSensitive: false));

                    var iconChild =
                        context.tree.element!.children[0].attributes.values;
                    var iconParsed =
                        iconChild.first.replaceFirst(RegExp(r'#'), '');

                    List bannedIcons = ['far-image', 'discourse-expand'];

                    if (isFontAwesomeIcon) {
                      if (bannedIcons.contains(iconParsed)) {
                        return Container();
                      } else {
                        return FaIcon(iconParsed);
                      }
                    }
                  },
                  "img": (context, child) {
                    var classes = context.tree.element?.className;
                    var classesSplit = classes?.split(" ");

                    var classIsEmoji = classesSplit!.contains('emoji') ||
                        classesSplit.contains('emoji-only');

                    var emojiImage = context.tree.attributes['src'].toString();

                    if (classIsEmoji) {
                      return Image.network(
                        emojiImage,
                        height: 25,
                        width: 25,
                      );
                    }
                  }
                },
                onLinkTap: (String? url, RenderContext context,
                    Map<String, String> attributes, dom.Element? element) {
                  launch(url!);
                },
              ),
            ),
          )
        ],
      ),
    ],
  );
}
