// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pillowchat/components/user_profile.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/l10n/en.dart';
import 'package:pillowchat/main.dart';
import 'package:pillowchat/models/client.dart';
import 'package:http/http.dart' as http;
import 'package:pillowchat/models/server.dart';
import 'package:pillowchat/themes/ui.dart';

class User {
  late String id;
  late String name;
  late String discriminator;
  String? displayName;
  String? avatar;
  late List<Relations> relations;
  String? relationship;
  late List<String> roles;
  int? badges;
  Status status = Status('', '');
  Profile? profile;
  // late int flags;
  // late bool priveleged;
  Object? bot;
  // late String relationship;
  // late bool online;
  static User? self;

  Server homeServer = Server(
    '-1',
    -1,
    En.directMessages,
    '',
    '',
    '',
    [],
    [],
  );
  User({
    required this.id,
    required this.name,
    this.avatar,
    this.badges,
    // this.flags,
    // this.priveleged,
    this.bot,
    this.relationship,
    // this.online,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];

    name = json['username'];
    discriminator = json['discriminator'];
    displayName = json['display_name'];

    // need for all avatars including defualt to work

    if (json['avatar'] != null) {
      avatar = json['avatar']['_id'];
    }
    // need for pfps

    if (json['status'] != null) {
      status = Status.fromJson(json['status']);
    }
    if (json['profile'] != null) {
      profile = Profile.fromJson(json['profile']);
    }
    badges = json['badges'];
    // flags = json['flags'];
    // priveleged = json['privileged'];

    bot = json['bot'];

    relationship = json['relationship'];

    // online = json['online'];
  }
  static Future<User> fetch(String target) async {
    var url = Uri.https(api, '/users/$target');

    final response =
        await http.get(url, headers: {'x-session-token': Client.token});

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      print("[success] got user! $json");
      final User user = User.fromJson(json);

      fetchProfile(target);
      return user;
    }
    throw response.statusCode;
  }

  static fetchSelf() async {
    try {
      Uri url = Uri.https(api, '/users/@me');

      final response =
          await http.get(url, headers: {'x-session-token': Client.token});

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var self = User.fromJson(json);
        print("got self!");

        ClientController.controller.selectUser(self);
        fetchSelfProfile();
      }
    } catch (e) {
      print(e);
    }
  }

  static fetchSelfProfile() async {
    try {
      var url = Uri.https(api,
          '/users/${ClientController.controller.selectedUser.value.id}/profile');

      final response =
          await http.get(url, headers: {'x-session-token': Client.token});

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        Profile profile = Profile.fromJson(json);
        print("[success] fetch self profile! ");
        print(profile);
        ClientController.controller.selectedUser.value.profile = profile;
      }
    } catch (e) {
      print(e);
    }
  }

  static fetchProfile(
    final String target, {
    int? index,
  }) async {
    Profile? profile;
    // try {
    var url = Uri.https(api, '/users/$target/profile');

    final response = await http.get(url, headers: {
      'x-session-token': Client.token,
      'Content-Type': 'application/json; charset=utf-8'
    });

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      profile = Profile.fromJson(json);
      print("[success] fetch user profile! ");
      if (index != null) {
        if (!ClientController.controller.home.value) {
          ServerController.controller.setProfile(profile, index);
          // print(ServerController
          //     .controller.selected.value.users[index].profile?.background?.id);
        } else {
          ChannelController.controller.selected.value.users[index].profile =
              profile;
        }
      }

      // }
      // } catch (e) {
      //   print(e);
    }
    return profile;
  }

  static update(dynamic data, User user) {
    if (data['content'] != null) {
      final Profile profile = data;
      if (profile.content != null) {
        user.profile?.content = profile.content;
        if (user.id == ClientController.controller.selectedUser.value.id) {
          ClientController.controller.selectedUser.value.profile?.content =
              profile.content;
        }
      }
    }
  }

  static view(
    BuildContext context,
    int? index,
    User user,
    String? avatar,
    String presence,
    String text,
    String id,
    List<Role> roles,
  ) {
    if (Client.isMobile) {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return DraggableScrollableSheet(
              maxChildSize: 0.8,
              initialChildSize: 0.6,
              minChildSize: 0.4,
              expand: false,
              builder: (context, ScrollController scrollController) {
                return SingleChildScrollView(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    // padding: const EdgeInsets.symmetric(
                    //     // horizontal: 16,
                    //     // vertical: 8,
                    //     ),
                    child: Container(
                      color: Dark.accent.value,
                      child: UserProfile(
                        user: user,
                        displayName: user.displayName,
                        username: user.name,
                        discriminator: user.discriminator,
                        userIndex: index ?? -1,
                        avatar: avatar,
                        presence: presence,
                        text: text,
                        id: id,
                        roles: roles,
                      ),
                    ),
                  ),
                );
              });
        },
      );
    } else {
      MyApp.showPopup(
        context: context,
        widget: UserProfile(
          user: user,
          username: user.name,
          discriminator: user.discriminator,
          userIndex: index ?? -1,
          presence: presence,
          text: text,
          id: id,
          roles: roles,
        ),
      );
    }
  }
}

class Avatar {
  late String id;
  late String tag;
  late String filename;
  late String metadata;
  late String contentType;
  late int size;
  late bool deleted;
  late bool reported;
  late String messageId;
  late String userId;
  late String serverId;
  late String objectId;

  Avatar.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    tag = json['tag'];
    filename = json['filename'];
    metadata = json['metadata']['type'];
    contentType = json['content_type'];
    size = json['size'];
    deleted = json['deleted'];
    reported = json['reported'];
    messageId = json['message_id'];
    userId = json['user_id'];
    serverId = json['server_id'];
    objectId = json['object_id'];
  }
}

class Relations {
  late String id;
  late String status;

  Relations(
    this.id,
    this.status,
  );
  Relations.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    status = json['status'];
  }
}

class Status {
  late String? text = '';
  late String presence = '';
  Status(
    this.text,
    this.presence,
  );
  Status.fromJson(Map<String, dynamic> json) {
    if (json['text'] != null) {
      text = json['text'];
    }
    if (json['presence'] != null) {
      presence = json['presence'];
    }
  }
}

class Profile {
  String? content;
  Background? background;

  Profile({
    this.content,
    this.background,
  });
  Profile.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    if (json['background'] != null) {
      background = Background.fromJson(json['background']);
    }
  }

  static editDescription(String content, BuildContext context) async {
    String id = ClientController.controller.selectedUser.value.id;
    try {
      Uri url = Uri.https(api, '/users/$id');

      var response = await http.patch(url,
          headers: {
            'x-session-token': Client.token,
          },
          body: jsonEncode({
            'profile': {'content': content}
          }));
      if (response.statusCode == 200) {
        print('[success] edited user content');
        ClientController.controller.selectedUser.value.profile?.content =
            content;
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }
}

class Background {
  late String id;
  late String tag;
  late String filename;

  Background(
    this.id,
    this.tag,
    this.filename,
  );
  Background.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    tag = json['tag'];
    filename = json['filename'];
  }
}
