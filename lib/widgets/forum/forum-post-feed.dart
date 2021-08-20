import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/models/post-model,.dart';
import 'package:freecodecamp/widgets/article/article-feed.dart';
import 'package:freecodecamp/widgets/forum/forum-connect.dart';

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

  Future<List<dynamic>?> fetchPosts() async {
    final response =
        await ForumConnect.connectAndGet('/c/${widget.slug}/${widget.id}');

    if (response.statusCode == 200) {
      return PostList.returnPosts(json.decode(response.body));
    } else {
      PostList.error();
    }
  }

  Future<List> fetchUserProfilePictures(String postId) async {
    String baseUrl = 'https://forum.freecodecamp.org';

    final response = await ForumConnect.connectAndGet('/t/$postId');

    List participantNames = [];

    if (response.statusCode == 200) {
      List participants =
          PostList.returnProfilePictures(json.decode(response.body));

      participants.forEach((participant) {
        List size = participant["avatar_template"].toString().split('{size}');

        if (size.length == 1) participantNames.add(size[0]);

        String avatarUrl = size[0] + "60" + size[1];

        participantNames.add(baseUrl + avatarUrl);
      });
      setState(() {
        profileUrls = participantNames;
      });
    }
    return [];
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
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 400,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 2, color: Colors.white))),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(truncateStr(post[index]["title"]),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                              itemCount: profileUrls.length,
                              itemBuilder: (BuildContext context, int i) {
                                return Column(children: [Text(profileUrls[i])]);
                              }),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'Views: ' + post[index]["views"].toString(),
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
                          ],
                        )
                      ],
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
