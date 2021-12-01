import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_awesome_web_names/flutter_font_awesome.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:freecodecamp/models/forum_post_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-comment/forum_comment_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-create-comment/forum_create_comment_view.dart';
import 'package:freecodecamp/ui/widgets/text_function_bar_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;
import 'forum_post_viewmodel.dart';

class ForumPostView extends StatelessWidget {
  final String id;
  final String slug;

  const ForumPostView({Key? key, required this.id, required this.slug})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostViewModel>.reactive(
        viewModelBuilder: () => PostViewModel(),
        onModelReady: (model) => model.initState(slug, id),
        onDispose: (model) => model.disposeTimer(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF0a0a23),
                title: const Text('Back To Feed'),
              ),
              backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              body: SingleChildScrollView(
                  child: Container(
                      color: const Color(0xFF0a0a23),
                      child: postViewTemplate(model, id, slug))),
            ));
  }

  Column postViewTemplate(PostViewModel model, id, slug) {
    List<PostModel> comments = [];

    return Column(
      children: [
        FutureBuilder<PostModel>(
            future: model.future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var post = snapshot.data;
                comments = [];
                comments.addAll(Comment.returnCommentList(post!.postComments));
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
                                post.postName as String,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
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
                      ? ForumCommentView(
                          comments: comments,
                          postId: id,
                          postSlug: slug,
                          baseUrl: model.baseUrl)
                      : Container(),
                  model.isLoggedIn
                      ? ForumCreateCommentView(
                          topicId: id,
                          post: post,
                        )
                      : Container()
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

  Column htmlView(PostModel post, BuildContext context, PostViewModel model) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Html(
                data: post.postCooked,
                style: {
                  "body": Style(color: Colors.white),
                  "blockquote": Style(
                      backgroundColor:
                          const Color.fromRGBO(0x65, 0x65, 0x74, 1),
                      padding: const EdgeInsets.all(8)),
                  "a": Style(fontSize: FontSize.rem(1)),
                  "p": Style(
                      fontSize: FontSize.rem(1.2),
                      lineHeight: LineHeight.em(1.2)),
                  "ul": Style(fontSize: FontSize.xLarge),
                  "li": Style(
                    margin: const EdgeInsets.only(top: 8),
                    fontSize: FontSize.rem(1.35),
                  ),
                  "pre": Style(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width),
                  "code": Style(
                      backgroundColor:
                          const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)),
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
                          maxHeight: 500,
                        ),
                        child: SyntaxView(
                          code: code.tree.element?.text as String,
                          syntax: Syntax.JAVASCRIPT,
                          syntaxTheme: SyntaxTheme.vscodeDark(),
                          fontSize: 16.0,
                          withZoom: false,
                          withLinesCount: true,
                          useCustomHeight: true,
                          minWidth: MediaQuery.of(context).size.width,
                          minHeight: 1,
                        ),
                      );
                    }
                  },
                  "aside": (context, child) {
                    var link =
                        context.tree.element!.attributes['data-onebox-src'];
                    if (link!.isNotEmpty) {
                      return InkWell(
                        onTap: () {
                          launch(link);
                        },
                        child: Text(
                          link,
                          style: const TextStyle(
                              color: Color.fromRGBO(0x22, 0x91, 0xeb, 1)),
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
                  },
                  "div": (context, child) {
                    var divClasses = context.tree.element?.className;

                    var classList = divClasses?.split(" ");

                    var classContainsMeta = classList!.contains('meta');
                    if (classContainsMeta) {
                      return Container();
                    }
                  }
                },
                onLinkTap: (String? url, RenderContext context,
                    Map<String, String> attributes, dom.Element? element) {
                  launch(url!);
                },
              ),
            ))
          ],
        ),
      ],
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
                  FadeInImage.assetNetwork(
                      height: 60,
                      placeholder: 'assets/images/placeholder-profile-img.png',
                      image: PostViewModel.parseProfileAvatUrl(
                          post.profieImage, "60")),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      post.username,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
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
                      model.updatePost(post.postId, post.postSlug);
                    },
                    child: const Text(
                      'UPDATE COMMENT',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )),
              ),
          ))
        ],
      )
    ],
  );
}

Row postHeader(PostViewModel model, PostModel post) {
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
                FadeInImage.assetNetwork(
                    height: 60,
                    placeholder: 'assets/images/placeholder-profile-img.png',
                    image: PostModel.fromDiscourse(post.profieImage)
                        ? PostModel.parseProfileAvatar(post.profieImage)
                        : model.baseUrl +
                            PostModel.parseProfileAvatar(post.profieImage)),
              ],
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

  Row topicFooter(PostViewModel model, PostModel post, BuildContext context) {
    return Row(
      children: [
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
            ? IconButton(
                onPressed: () {
                  model.deleteTopic(id, context);
                },
                icon: const Icon(
                  Icons.delete_sharp,
                  color: Colors.white,
                ))
            : Container()
      ],
    );
  }
}
