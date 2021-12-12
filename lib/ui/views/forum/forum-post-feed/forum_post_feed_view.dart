import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freecodecamp/models/forum_post_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-post-feed/forum_post_feed_lazyloading.dart';
import 'package:freecodecamp/ui/views/forum/forum-post-feed/forum_post_feed_viewmodel.dart';
import 'package:freecodecamp/ui/views/forum/forum-post/forum_post_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class ForumPostFeedView extends StatelessWidget {
  final String slug;
  final String id;
  final String name;

  const ForumPostFeedView(
      {Key? key, required this.slug, required this.id, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumPostFeedModel>.reactive(
        viewModelBuilder: () => ForumPostFeedModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: Text(name + ' Category'),
              ),
              body: FutureBuilder<List<PostModel>?>(
                future: model.fetchPosts(slug, id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var post = snapshot.data;
                    return postFeedBuilder(model, post!);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ));
  }

  ListView postFeedBuilder(ForumPostFeedModel model, List<PostModel> post) {
    return ListView.builder(
        itemCount: model.posts.length,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) => ForumLazyLoading(
            postCreated: () {
              SchedulerBinding.instance!.addPostFrameCallback(
                  (timeStamp) => model.handlePostLazyLoading(index));
            },
            child: InkWell(
              onTap: () {
                model.navigateToPost(
                  post[index].postSlug,
                  post[index].postId,
                );
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: postViewTemplate(post[index], index, model),
                ),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 2,
                            color: Color.fromRGBO(0x42, 0x42, 0x55, 1)))),
              ),
            )));
  }

  ListTile postViewTemplate(
      PostModel post, int index, ForumPostFeedModel model) {
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          post.postHasAnswer
              ? const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FaIcon(
                    FontAwesomeIcons.checkSquare,
                    color: Color.fromRGBO(0xa9, 0xaa, 0xb2, 1),
                    size: 18,
                  ),
                )
              : Container(),
          Expanded(
            child: Text(
              model.truncateTitle(post.postName as String),
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      leading: FadeInImage.assetNetwork(
          height: 60,
          placeholder: 'assets/images/placeholder-profile-img.png',
          image: PostModel.fromDiscourse(post.userImages![0])
              ? PostModel.parseProfileAvatar(post.userImages![0])
              : model.baseUrl +
                  PostModel.parseProfileAvatar(post.userImages![0])),
      trailing: Text(
        post.postReplyCount.toString(),
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(0xa9, 0xaa, 0xb2, 1)),
      ),
      subtitle: Row(
        children: [
          Column(
            children: [
              Text(
                PostViewModel.parseDate(post.postLastActivity as String),
                style:
                    const TextStyle(color: Color.fromRGBO(0xa9, 0xaa, 0xb2, 1)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
