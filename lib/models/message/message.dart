// ignore_for_file:

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/widgets/message/message_options.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/message/parts/message_components.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/message/parts/attachments.dart';
import 'package:http/http.dart' as http;
import 'package:pillowchat/themes/markdown.dart';
import 'package:pillowchat/themes/ui.dart';
import 'package:pillowchat/models/message/parts/embeds.dart';

import 'parts/reactions.dart';

class Message {
  String? id;
  late String channel;
  String? author;
  String? content;
  System? system;
  List<Attachment>? attachments = [];
  String? edited = '';
  List<dynamic>? embeds = [];
  List<dynamic>? mentions = [];
  static List<dynamic>? replies;
  List<dynamic>? repliesId = [];
  Masquerade? masquerade = Masquerade('', '', '');
  RxList<Reaction>? reactions = <Reaction>[].obs;
  late List<Member> channelMembers;

  Message(
    this.id,
    this.content,
    this.author,
    this.embeds,
    this.repliesId,
    this.mentions,
    this.attachments,
    this.reactions,
    this.channel,
    this.edited,
    this.masquerade,
    this.system,
  );

  Message.fromJson(Map<String, dynamic> json) {
    id = json['_id'];

    content = json['content'];

    if (json['edited'] != null) {
      edited = json['edited'];
      // if (kDebugMode) print(edited);
    }

    if (json['mentions'] != null) {
      mentions = json['mentions'];
    }
    author = json['author'];
    repliesId = json['replies'];

    channel = json['channel'];

    // system = json['system'];

    if (json['embeds'] != null) {
      embeds = List<Embeds>.from(json['embeds'].map((e) => Embeds.fromJson(e)));
      // if (kDebugMode) print(embeds);
    }

    if (json['attachments'] != null) {
      attachments = List<Attachment>.from(
          json['attachments'].map((e) => Attachment.fromJson(e)));
    }

    if (json['masquerade'] != null) {
      masquerade = Masquerade.fromJson(json['masquerade']);
    }

    if (json['reactions'] != null) {
      // reactions?.value = Reaction.fromJson(json['reactions']);

      reactions = (json['reactions'] as Map<String, dynamic>)
          .entries
          .map((entry) => Reaction.fromJson(entry.key, entry.value))
          .toList()
          .obs;
    }
  }

  static fetch(String channel, int index, {String? oldestMessage}) async {
    final queryParameters = {
      'limit': '25',
      'sort': 'Latest',
      'include_users': 'true',
      // 'before': null,
    };
    if (oldestMessage != null) {
      queryParameters['before'] = oldestMessage;
      // if (kDebugMode) print(queryParameters);
    }
    try {
      var url = Uri.https(
        api,
        '/channels/$channel/messages',
        queryParameters,
      );
      final response = await http.get(url, headers: {
        'x-session-token': Client.token,
      });
      if (response.statusCode == 200) {
        if (kDebugMode) print('[success] message fetch');
        var json = jsonDecode(utf8.decode(response.bodyBytes));

        // if (kDebugMode) print(json);
        late List<Message> messages;
        if (json['messages'] != null) {
          List<dynamic> messageList = json['messages'];
          // if (kDebugMode) print(messageList);
          messages = messageList
              .map((messages) => Message.fromJson(messages))
              .toList();
        }
        late List<User> users;
        // if (json['users'] != null) {
        List usersList = json['users'];
        users = usersList.map((users) => User.fromJson(users)).toList();

        late List<Member> members;
        if (json['members'] != null) {
          List membersList = json['members'];
          members =
              membersList.map((members) => Member.fromJson(members)).toList();

          if (!ClientController.controller.home.value &&
                  ServerController.controller.selected.value.channels[index]
                      .users.isNotEmpty ||
              ServerController
                  .controller.selected.value.channels[index].users.isEmpty) {
            ServerController.controller.updateMessageList(
              index,
              messages,
              users,
              members,
            );
          }
        } else {
          if (kDebugMode) print("DM");
          ChannelController.controller.updateMessageList(
            index,
            messages,
            users,
          );
        }
        // }
      } else {}
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  static send(String content) async {
    final channel = ChannelController.controller.selected.value.id;
    Map body = {
      'content': content,
    };
    try {
      var url = Uri.https(
        api,
        '/channels/$channel/messages',
      );
      final response = await http.post(
        url,
        headers: {
          'x-session-token': Client.token,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) print('successful message send');
        var json = jsonDecode(response.body);
        if (kDebugMode) print(json);
      } else {
        if (kDebugMode) print('some send error..');
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  static edit(String content, String messageId) async {
    final channel = ChannelController.controller.selected.value.id;
    Map body = {
      'content': content,
      // 'embeds': [],
    };
    try {
      var url = Uri.https(
        api,
        '/channels/$channel/messages/$messageId',
      );
      final response = await http.patch(url,
          headers: {
            'x-session-token': Client.token,
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (kDebugMode) print('successful edit');
        if (kDebugMode) print(json);
      } else {
        if (kDebugMode) print('some edit error..');
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  static delete(String messageId) async {
    final channel = ChannelController.controller.selected.value.id;

    try {
      var url = Uri.https(
        api,
        '/channels/$channel/messages/$messageId',
      );
      final response = await http.delete(url, headers: {
        'x-session-token': Client.token,
      });

      if (response.statusCode == 204) {
        if (kDebugMode) print('successful message delete');
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  //
  static reply(String messageId) async {}
  //
  static getReplies(String channel, String messageId) async {
    try {
      var url = Uri.https(api, '/channels/$channel/messages/$messageId');
      final response = await http.get(
        url,
        headers: {
          'x-session-token': Client.token,
        },
      );
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        var replies = Reply.fromJson(json);

        Message.replies?.add(replies);
        // }
      }
    } catch (e) {
      if (kDebugMode) print(api + '/channels/$channel/messages/$messageId');
      if (kDebugMode) print(e);
    }
  }

  static ack(String messageId) async {
    final channel = ChannelController.controller.selected.value.id;

    try {
      var url = Uri.https(
        api,
        '/channels/$channel/ack/$messageId',
      );
      final response = await http.put(url, headers: {
        'x-session-token': Client.token,
      });

      if (response.statusCode == 204) {
        if (kDebugMode) print('successful message ack');
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  static openMenu(
    String messageId,
    String? content,
    BuildContext context,
    String author,
    String? editTime,
    RxList<Reaction>? reactions,
    bool? reactedTo,
    List<dynamic>? emotes,
    dynamic messageIndex,
  ) {
    showModalBottomSheet(
      backgroundColor: Dark.background.value,
      isScrollControlled: true,
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(15),
          right: Radius.circular(15),
        ),
        child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.7,
            snap: true,
            snapSizes: const [0.9],
            expand: false,
            builder: (context, scrollController) {
              return MessageOptions(
                messageId: messageId,
                content: content ?? '',
                author: author,
                editTime: editTime ?? '',
                reactions: reactions,
                reactedTo: reactedTo ?? false,
                messageIndex: messageIndex,
              );
            }),
      ),
    );
  }

  static showEmote(BuildContext context, String ulid) {
    showModalBottomSheet(
        backgroundColor: Dark.background.value,
        context: context,
        builder: (context) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 8,
            ),
            leading: Emote(
              ulid: ulid,
              size: 2,
              onTap: () {
                Picture.view(context, '$autumn/emojis/$ulid', ulid);
              },
            ),
            title: Text(ulid),
          );
        });
  }

  static showEmoteMenu(
      BuildContext context, String messageId, bool? reactedTo) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(15),
          ),
          child: Container(
            color: Dark.background.value,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 8,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisExtent: 30,
                mainAxisSpacing: 8,
                maxCrossAxisExtent: 50,
                crossAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemCount: Client.emojis.length,
              // scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Emote(
                  ulid: Client.emojis[index].id,
                  size: 30,
                  onTap: () {
                    if (!reactedTo!) {
                      Reaction.add(
                          ChannelController.controller.selected.value.id,
                          messageId,
                          Client.emojis[index].id);
                    }
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
