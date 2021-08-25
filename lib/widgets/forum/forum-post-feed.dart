import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/models/post-model.dart';
import 'package:freecodecamp/widgets/article/article-feed.dart';
import 'package:freecodecamp/widgets/forum/forum-connect.dart';
import 'package:freecodecamp/widgets/forum/forum-postview.dart';

class ForumPostFeed extends StatefulWidget {
  final String slug;
  final int id;

  const ForumPostFeed({Key? key, required this.slug, required this.id})
      : super(key: key);

  _ForumPostFeedState createState() => _ForumPostFeedState();
}

class _ForumPostFeedState extends State<ForumPostFeed> {
  late Future<List<dynamic>?> postFuture;
  List profileUrls = [];
  List participantNames = [];
  int count = 0;
  Future<List<dynamic>?> fetchPosts() async {
    final response =
        await ForumConnect.connectAndGet('/c/${widget.slug}/${widget.id}');

    if (response.statusCode == 200) {
      return PostList.returnPosts(json.decode(response.body));
    } else {
      PostList.error();
    }
  }

  Future<void> fetchUserProfilePictures(String postId) async {
    String baseUrl = 'https://forum.freecodecamp.org';
    final response = await ForumConnect.connectAndGet('/t/$postId');

    if (response.statusCode == 200) {
      participantNames = [];
      List participants =
          PostList.returnProfilePictures(json.decode(response.body));

      participants.forEach((participant) {
        List size = participant["avatar_template"].toString().split('{size}');
        String avatarUrl = size[0] + "60" + size[1];
        bool fromDiscourseCdn = size[0]
            .toString()
            .contains(new RegExp(r'discourse-cdn', caseSensitive: false));

        if (fromDiscourseCdn) {
          participantNames.add(avatarUrl);
        } else if (size.length == 1) {
          participantNames.add(size[0]);
        } else {
          participantNames.add(baseUrl + avatarUrl);
        }
      });
      dev.log(participantNames.toString());
      setState(() {
        count = participantNames.length;
      });
      //dev.log(count.toString());
    }
  }

  ListView populateProfilePictures(id) {
    fetchUserProfilePictures(id.toString());
    return ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: count,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 20,
            width: 20,
            child: Row(
              children: [
                Image.network(participantNames[index]),
              ],
            ),
          );
        });
  }

  void initState() {
    super.initState();
    postFuture = fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>?>(
        future: postFuture,
        builder: (context, snapshot) {
          //dev.log(snapshot.data.toString());
          if (snapshot.hasData) {
            var post = snapshot.data;

            return ListView.builder(
                itemCount: snapshot.data?.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForumPostView(
                                    refPostId: post![index]["id"].toString(),
                                    refSlug: post[index]["slug"],
                                  )));
                    },
                    child: Container(
                      height: 125,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 2, color: Colors.white))),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(truncateStr(post![index]["title"]),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ))
                            ],
                          ),
                          // populateProfilePictures(post[index]["id"]),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Views: ' +
                                          post[index]["views"].toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300)),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Replies: ' +
                                          post[index]["reply_count"].toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300)),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Posted: ' +
                                          PostModel.parseDate(
                                              post[index]["created_at"]),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300)),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
    );
  }
}
