import 'dart:convert';

import 'package:freecodecamp/widgets/forum/forum-connect.dart';

class User {
  final String username;
  final String name;
  final String profilePicture;
  final String lastSeen;
  final String createdAt;
  final String title;
  final String? bio;
  final String dateOfBirth;
  final bool ignored;
  final bool muted;
  final bool canSendPrivateMessages;
  final bool canSendPrivateMessageToUser;
  final bool isModerator;
  final bool isAdmin;
  final int trustLevel;
  final int badgeCount;
  final int postCount;
  final List<dynamic> badges;

  User({
    required this.username,
    required this.name,
    required this.profilePicture,
    required this.lastSeen,
    required this.createdAt,
    required this.title,
    required this.bio,
    required this.dateOfBirth,
    required this.ignored,
    required this.muted,
    required this.canSendPrivateMessages,
    required this.canSendPrivateMessageToUser,
    required this.isModerator,
    required this.isAdmin,
    required this.trustLevel,
    required this.badgeCount,
    required this.postCount,
    required this.badges,
  });

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
      username: data['user']['username'],
      name: data['user']['name'],
      profilePicture: data['user']['avatar_template'],
      lastSeen: data['user']['last_seen_at'],
      createdAt: data['user']['created_at'],
      title: data['user']['title'],
      bio: data['user']['bio_excerpt'],
      dateOfBirth: data['user']['date_of_birth'],
      ignored: data['user']['ignored'],
      muted: data['user']['muted'],
      canSendPrivateMessages: data['user']['can_send_private_messages'],
      canSendPrivateMessageToUser: data['user']
          ['can_send_private_messages_to_user'],
      isModerator: data['user']['moderator'],
      isAdmin: data['user']['admin'],
      trustLevel: data['user']['trust_level'],
      badgeCount: data['user']['badge_count'],
      postCount: data['user']['post_count'],
      badges: data['badges'],
    );
  }

  static Future<User> fetchUser(String username) async {
    final response = await ForumConnect.connectAndGet('/u/$username');

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    throw Exception('could not load user data: ' + response.body.toString());
  }

  static List<UserTopic>? getUserTopics(data) {
    int userTopics = data['topics'].length;
    List<UserTopic> topics = [];

    if (userTopics == 0) return null;

    for (int i = 0; i < userTopics; i++) {
      topics.add(UserTopic.fromJson(data['topics'][i]));
    }
    return topics;
  }

  static Future<UserSummary> fetchUserSummary(String username) async {
    final response = await ForumConnect.connectAndGet('/u/$username/summary');
    if (response.statusCode == 200) {
      return UserSummary.fromJson(jsonDecode(response.body));
    }
    throw Exception('could not load user summary: ' + response.body.toString());
  }
}

class UserTopic {
  final int id;
  final int postCount;
  final String title;
  final String slug;
  final String createdAt;
  final String likedCount;

  UserTopic(
      {required this.id,
      required this.postCount,
      required this.title,
      required this.slug,
      required this.createdAt,
      required this.likedCount});

  factory UserTopic.fromJson(Map<String, dynamic> data) {
    return UserTopic(
        id: data['id'],
        postCount: data['post_count'],
        title: data['title'],
        slug: data['slug'],
        createdAt: data['created_at'],
        likedCount: data['liked_count']);
  }
}

class UserBadge {
  final int id;
  final int grantCount;
  final String name;
  final String description;
  final String slug;
  final bool allowTitle;
  final bool listable;
  final bool enabled;
  final bool manuallyGrantable;

  UserBadge(
      {required this.id,
      required this.grantCount,
      required this.name,
      required this.description,
      required this.slug,
      required this.allowTitle,
      required this.listable,
      required this.enabled,
      required this.manuallyGrantable});

  factory UserBadge.fromJson(Map<String, dynamic> data) {
    return UserBadge(
        id: data['id'],
        grantCount: data['grant_count'],
        name: data['name'],
        description: data['description'],
        slug: data['slug'],
        allowTitle: data['allow_title'],
        listable: data['listable'],
        enabled: data['enabled'],
        manuallyGrantable: data['manually_grantable']);
  }
}

class UserSummary {
  final int likesGiven;
  final int likesReceived;
  final int topicEnterd;
  final int postRead;
  final int daysVisited;
  final int topicCount;
  final int postCount;
  final int solvedCount;
  final bool canSeeStats;

  UserSummary(
      {required this.likesGiven,
      required this.likesReceived,
      required this.topicEnterd,
      required this.postRead,
      required this.daysVisited,
      required this.topicCount,
      required this.postCount,
      required this.solvedCount,
      required this.canSeeStats});

  factory UserSummary.fromJson(Map<String, dynamic> data) {
    return UserSummary(
        likesGiven: data['user_summary']['likes_given'],
        likesReceived: data['user_summary']['likes_received'],
        topicEnterd: data['user_summary']['topics_entered'],
        postRead: data['user_summary']['post_read_count'],
        daysVisited: data['user_summary']['days_visited'],
        topicCount: data['user_summary']['topic_count'],
        postCount: data['user_summary']['post_count'],
        solvedCount: data['user_summary']['solved_count'],
        canSeeStats: data['user_summary']['can_see_summary_stats']);
  }
}
