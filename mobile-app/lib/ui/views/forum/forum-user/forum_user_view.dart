import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/models/forum/forum_post_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-post/forum_post_viewmodel.dart';
import 'package:freecodecamp/models/forum/forum_user_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-user/forum_user_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher_string.dart';

class ForumUserView extends StatelessWidget {
  const ForumUserView({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumUserModel>.reactive(
        onModelReady: (model) => model.initState(username),
        viewModelBuilder: () => ForumUserModel(),
        builder: (context, model, child) => Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [userTemplateBuilder(context, model)],
                ),
              ),
            ));
  }
}

FutureBuilder userTemplateBuilder(context, model) {
  return FutureBuilder<User>(
      future: model.future,
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
                      fit: BoxFit.cover,
                      child: ClipRect(
                        child: Align(
                          heightFactor: 0.5,
                          widthFactor: 1,
                          child: FadeInImage.assetNetwork(
                            placeholder:
                                'assets/images/placeholder-profile-img.png',
                            image: PostModel.fromDiscourse(user!.profilePicture)
                                ? PostModel.parseProfileAvatar(
                                    user.profilePicture)
                                : model.baseUrl +
                                    PostModel.parseProfileAvatar(
                                        user.profilePicture),
                            width: 360,
                          ),
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
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: user.bio != null ? 16 : 0, left: 16),
                    child: Text(
                      user.name,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                )
              ]),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.all(user.bio != null ? 16 : 0),
                          child: user.bio != null
                              ? Html(
                                  data: user.bio,
                                  style: {
                                    'body': Style(
                                        color: Colors.white,
                                        fontSize: FontSize.rem(1.2))
                                  },
                                  onLinkTap: (String? url,
                                      RenderContext context,
                                      Map<String, String> attributes,
                                      dom.Element? element) {
                                    launchUrlString(url!);
                                  },
                                  customRender: {
                                    'img': (context, child) {
                                      var classes =
                                          context.tree.element?.className;
                                      var classesSplit = classes?.split(' ');

                                      var classIsEmoji = classesSplit!
                                              .contains('emoji') ||
                                          classesSplit.contains('emoji-only');

                                      var emojiImage = context
                                          .tree.attributes['src']
                                          .toString();

                                      if (classIsEmoji) {
                                        return Image.network(
                                          emojiImage,
                                          height: 25,
                                          width: 25,
                                        );
                                      }
                                    }
                                  },
                                )
                              : null))
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: user.bio != null
                          ? const EdgeInsets.only(left: 16.0, top: 8)
                          : const EdgeInsets.only(left: 16),
                      child: Text(
                        'Joined ' + PostViewModel.parseDate(user.createdAt),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8),
                      child: Text(
                        'Seen ' + PostViewModel.parseDate(user.lastSeen),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  color: const Color(0xFF0a0a23),
                  width: MediaQuery.of(context).size.width,
                  child: UserTopicTemplate(
                    user: user,
                    model: model,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  color: const Color(0xFF0a0a23),
                  width: MediaQuery.of(context).size.width,
                  child: UserBadgeBuilder(user: user, model: model),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          throw Exception('Snapshot has error' + snapshot.error.toString());
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      });
}

class UserTopicTemplate extends StatelessWidget {
  const UserTopicTemplate({
    Key? key,
    required this.model,
    required this.user,
  }) : super(key: key);

  final User user;
  final ForumUserModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16),
              child: Text('Topics', style: TextStyle(fontSize: 28)),
            )
          ],
        ),
        FutureBuilder<List<UserTopic>?>(
          future: model.getUserTopics(user.username, 5),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var topic = snapshot.data;
              return Column(
                children: [
                  UserTopicBuilder(topic: topic, model: model),
                ],
              );
            } else if (snapshot.hasError) {
              throw Exception(snapshot.error);
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
      ],
    );
  }
}

class UserTopicBuilder extends StatelessWidget {
  const UserTopicBuilder({Key? key, required this.topic, required this.model})
      : super(key: key);

  final List<UserTopic>? topic;
  final ForumUserModel model;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: topic!.length,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: ListTile(
            title:
                Text(topic![index].title, style: const TextStyle(fontSize: 18)),
            subtitle: Text(
              'posted ' + PostViewModel.parseDate(topic![index].createdAt),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_sharp,
              size: 40,
            ),
            onTap: () {
              model.navigateToPost(topic![index].slug, topic![index].id);
            },
          ),
        );
      },
    );
  }
}

class UserBadgeBuilder extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  UserBadgeBuilder({Key? key, required this.user, required this.model})
      : super(key: key);
  final User user;
  final ForumUserModel model;
  late final List<UserBadge> badges;

  @override
  Widget build(BuildContext context) {
    var future = model.fetchUserBadges(user.username, 5);

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16),
      child: Column(
        children: [
          Row(
            children: const [
              Text(
                'Badges',
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
            ],
          ),
          FutureBuilder<List<UserBadge>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var badge = snapshot.data;
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        trailing: model.parseBages(
                            badge![index].icon, 50, badge[index].badgeTypeId),
                        title: Text(badge[index].name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18)),
                        subtitle: Text(
                          ForumUserModel.parseBadgeDescription(
                              badge[index].description),
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                throw Exception(snapshot.error);
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
