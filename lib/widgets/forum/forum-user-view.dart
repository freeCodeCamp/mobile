import 'package:flutter/material.dart';
import 'package:freecodecamp/models/forum-post-model.dart';
import 'package:freecodecamp/models/forum-user-model.dart';

class UserTemplate extends StatefulWidget {
  UserTemplate({Key? key, required this.username}) : super(key: key);
  late final String username;
  _UserTemplateState createState() => _UserTemplateState();
}

class _UserTemplateState extends State<UserTemplate> {
  late Future<User> userFuture;

  void initState() {
    userFuture = User.fetchUser(widget.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
      body: Column(
        children: [userTemplateBuilder(context, userFuture)],
      ),
    );
  }
}

FutureBuilder userTemplateBuilder(context, future) {
  return FutureBuilder<User>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data;

          return Column(
            children: [
              Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 400,
                      minWidth: MediaQuery.of(context).size.width,
                    ),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: ClipRect(
                        child: Align(
                          heightFactor: 0.5,
                          widthFactor: 1,
                          child: FadeInImage.assetNetwork(
                              placeholder:
                                  'assets/images/placeholder-profile-img.png',
                              image: PostModel.parseProfileAvatUrl(
                                  user!.profilePicture,
                                  MediaQuery.of(context)
                                      .size
                                      .width
                                      .toInt()
                                      .toString())),
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
                      padding: const EdgeInsets.only(top: 8, left: 16),
                      child: Text(
                        user.username,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 32,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      user.name,
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                  ),
                )
              ]),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(user.bio != null ? 16 : 0),
                      child: Text(
                        user.bio ?? "",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 8),
                        child: Text(
                          'Joined ' + PostModel.parseDate(user.createdAt),
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 8),
                        child: Text(
                          'Seen ' + PostModel.parseDate(user.lastSeen),
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  color: Color(0xFF0a0a23),
                  width: MediaQuery.of(context).size.width,
                  child: UserTopicTemplate(user: user),
                ),
              )
            ],
          );
        } else if (snapshot.hasError) {
          throw Exception('Snapshot has error' + snapshot.error.toString());
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      });
}

class UserTopicTemplate extends StatelessWidget {
  const UserTopicTemplate({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Topics',
                  style: TextStyle(color: Colors.white, fontSize: 28)),
            )
          ],
        ),
        Row(children: [
          // Column(
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(left: 16.0, top: 8),
          //       child: Text(
          //         'Seen ' + PostModel.parseDate(user!.),
          //         style: TextStyle(fontSize: 18, color: Colors.white),
          //       ),
          //     )
          //   ],
          // )
        ])
      ],
    );
  }
}
