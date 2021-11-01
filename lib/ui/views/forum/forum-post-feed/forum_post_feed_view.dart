import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  ListTile postViewTemplate(
      PostModel post, int index, ForumPostFeedModel model) {
    return ListTile(
      title: Text(
        post.postName as String,
        style: const TextStyle(color: Colors.white),
      ),
      leading: FadeInImage.assetNetwork(
          height: 60,
          placeholder: 'assets/images/placeholder-profile-img.png',
          image: post.userImages![0]),
      subtitle: Text(
        PostViewModel.parseDate(post.postCreateDate),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
