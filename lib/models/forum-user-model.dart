import 'forum-badge-model.dart';

class User {
  final String username;
  final String name;
  final String profilePicture;
  final String lastSeen;
  final String createdAt;
  final String title;
  final String bio;
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
  final List<Badge> badges;

  User(
      {required this.username,
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
      required this.badges});

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
        badges: data['badges']);
  }
}
