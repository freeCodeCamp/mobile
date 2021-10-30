import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:freecodecamp/models/forum_post_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-post-feed/forum_post_feed_lazyloading.dart';
import 'package:freecodecamp/ui/views/forum/forum-post-feed/forum_post_feed_viewmodel.dart';
import 'package:freecodecamp/ui/views/forum/forum-post/forum_post_viewmodel.dart';
import 'package:stacked/stacked.dart';

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
                backgroundColor: const Color(0xFF0a0a23),
                title: Text(name + ' Category'),
                centerTitle: true,
              ),
              body: FutureBuilder<List<PostModel>?>(
                future: model.fetchPosts(slug, id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var post = snapshot.data;
                    return postFeedBuilder(model, post);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            ));
  }

  ListView postFeedBuilder(ForumPostFeedModel model, List<PostModel>? post) {
    return ListView.builder(
        itemCount: model.posts.length,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) => ForumLazyLoading(
            postCreated: () {
              SchedulerBinding.instance!.addPostFrameCallback(
                  (timeStamp) => model.handlePostLazyLoading(index));
            },
            child: postViewTemplate(post![index], index, model)));
  }

  InkWell postViewTemplate(
      PostModel post, int index, ForumPostFeedModel model) {
    return InkWell(
      onTap: () {
        model.navigateToPost(
          post.postSlug,
          post.postId,
        );
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 125),
        child: Container(
          decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 2, color: Colors.white))),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(post.postName as String,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "posted " +
                            PostViewModel.parseDate(post.postCreateDate),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "activity " +
                            PostViewModel.parseDate(
                                post.postLastActivity as String),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Views: ' + post.postViews.toString(),
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Replies: ' + post.postReplyCount.toString(),
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
