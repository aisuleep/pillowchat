// ignore_for_file:

import 'package:get/get.dart';
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/models/unreads.dart';
import 'package:pillowchat/models/user.dart';

// class Channels {
//   static late List<String> names;
// }

class Channel {
  late String id;
  String? server;
  String? name;
  String? description = '';
  String? icon = '';
  RxList<User> users = <User>[].obs;
  RxList<Member> members = <Member>[].obs;
  String? type;
  late String owner;
  late List<dynamic>? recipients;
  String lastMessage = '';
  late int permissions;
  RxList<Message> messages = <Message>[].obs;
  List<Unread> unreads = [];
  RxBool isUnread = true.obs;
  RxList<User> typingList = <User>[].obs;
  Channel({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    required this.users,
    required this.members,
    required this.messages,
    required this.isUnread,
  });

  Channel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];

    name = json['name'];

    if (json['description'] != null) {
      description = json['description'];
    }

    if (json['icon'] != null) {
      icon = json['icon']['_id'];
    }

    // user = json['user'];

    type = json['channel_type'];

    server = json['server'];

    recipients = json['recipients'];

    if (json["last_message_id"] != null) {
      lastMessage = json['last_message_id'];
    }
  }
}
