import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_awesome_web_names/flutter_font_awesome.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:freecodecamp/models/forum_post_model.dart';
import 'package:freecodecamp/ui/widgets/text_function_bar_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;
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
                backgroundColor: const Color(0xFF0a0a23),
                title: const Text('Back To Feed'),
              ),
              backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
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
                        ? model.postBuilder(slug, id)
                        : Container(),
                    model.isLoggedIn
                        ? createPost(model, context, post)
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
                      model.updateTopic(id, post.postSlug);
                    },
                    child: const Text(
                      'UPDATE TOPIC',
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
                        primary: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
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
                  model.editPost(post.postId, post.postCooked);
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
