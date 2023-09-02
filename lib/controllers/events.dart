// ignore_for_file:

import 'package:flutter/foundation.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/models/channel/channels.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/message/parts/embeds.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/models/message/parts/reactions.dart';
import 'package:pillowchat/models/server.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/widgets/home_channels.dart';

class Events {
  // MESSAGES
  static addMessage(Message message) async {
    int channelIndex;
    Channel channel;
    int serverIndex;
    int userIndex;
    User? user;
    int memberIndex;
    Member? member;

    channelIndex =
        Client.channels.indexWhere((channel) => channel.id == message.channel);

    if (channelIndex != -1) {
      // if (kDebugMode) print(message);
      // if (kDebugMode) print(channelIndex);
      channel = Client.channels[channelIndex];
      // if (kDebugMode) print(channel);
      if (!ClientController.controller.home.value) {
        serverIndex = ServerController.controller.serversList
            .indexWhere((server) => server.id == channel.server);

        // if (kDebugMode) print(serverIndex);

        // FIND USER
        if (serverIndex != -1 &&
                channel.id == ChannelController.controller.selected.value.id ||
            serverIndex != -1 &&
                Client.channels[channelIndex].messages.isNotEmpty) {
          userIndex = ServerController.controller.serversList[serverIndex].users
              .indexWhere((user) => user.id == message.author);
          if (userIndex != -1) {
            user = ServerController
                .controller.serversList[serverIndex].users[userIndex];
          } else {
            user = await User.fetch(message.author!);
            ServerController.controller.serversList[serverIndex].users
                .add(user);
            ServerController.controller.serversList[serverIndex].users
                .refresh();
          }
          // FIND MEMBER
          memberIndex = ServerController
              .controller.serversList[serverIndex].members
              .indexWhere((member) => member.userId == message.author);
          if (userIndex != -1 && memberIndex != -1) {
            member = ServerController
                .controller.serversList[serverIndex].members[memberIndex];
          }
          channelIndex = ServerController
              .controller.serversList[serverIndex].channels
              .indexWhere((channel) => channel.id == message.channel);
          // ADD USER/MEMBER IF NEW CHATTER
          // if (kDebugMode) print(userIndex);
          if (ServerController.controller.serversList[serverIndex]
                  .channels[channelIndex].users
                  .indexWhere((users) => users.id == user?.id) ==
              -1) {
            ServerController.controller.serversList[serverIndex]
                .channels[channelIndex].users
                .add(user);
            ServerController.controller.serversList[serverIndex]
                .channels[channelIndex].users
                .refresh();
            if (memberIndex != -1 &&
                ServerController.controller.serversList[serverIndex]
                        .channels[channelIndex].members
                        .indexWhere(
                            (members) => members.userId == member?.userId) ==
                    -1) {
              ServerController.controller.serversList[serverIndex]
                  .channels[channelIndex].members
                  .add(member!);
              ServerController.controller.serversList[serverIndex]
                  .channels[channelIndex].members
                  .refresh();
            }
          }
          // ADD MESSAGE

          if (!ServerController.controller.serversList[serverIndex]
              .channels[channelIndex].messages
              .contains(message)) {
            ServerController.controller.serversList[serverIndex]
                .channels[channelIndex].messages
                .insert(0, message);
            ServerController.controller.serversList[serverIndex]
                .channels[channelIndex].messages
                .refresh();
          }
        }
      } else {
        if (ServerController.controller.homeIndex.value != 0) {
          Home.dms![channelIndex].messages.insert(0, message);
          Home.dms![channelIndex].messages.refresh();

          // if (!Home.dms![channelIndex].users.contains(user) && user != null) {
          //   Home.dms![channelIndex].users.add(user);
          //   Home.dms![channelIndex].users.refresh();
          // }
        } else {
          Client.savedNotes.value.messages.insert(0, message);
          Client.savedNotes.value.messages.refresh();
          // if (!Client.savedNotes.value.users.contains(user)) {
          //   Client.savedNotes.value.users.add(user!);
          //   Client.savedNotes.value.users.refresh();
          // }
        }
      }
    }
  }

  static updateMessage(dynamic json) {
    int channelIndex;
    Channel channel;
    int serverIndex;
    int messageIndex;
    channelIndex =
        Client.channels.indexWhere((channel) => channel.id == json["channel"]);
    final String messageId = json["id"];
    final dynamic data = json["data"];
    final String content = data["content"];
    final String edited = data["edited"];
    List<Embeds> embeds = [];
    if (data["embeds"].length != 0) {
      embeds = data["embeds"];
    }

    if (channelIndex != -1) {
      // if (kDebugMode) print(json);

      channel = Client.channels[channelIndex];
      // if (kDebugMode) print(channel);
      serverIndex = ServerController.controller.serversList
          .indexWhere((server) => server.id == channel.server);
      // if (kDebugMode) print(serverIndex);
      channelIndex = ServerController
          .controller.serversList[serverIndex].channels
          .indexWhere((channel) => channel.id == json["channel"]);
      // if (kDebugMode) print(channelIndex);
      messageIndex = ServerController
          .controller.serversList[serverIndex].channels[channelIndex].messages
          .indexWhere((message) => message.id == messageId);
      // if (kDebugMode) print(messageIndex);
      if (messageIndex != -1) {
        ServerController.controller.serversList[serverIndex]
            .channels[channelIndex].messages[messageIndex].content = content;
        ServerController.controller.serversList[serverIndex]
            .channels[channelIndex].messages[messageIndex].edited = edited;
        if (data["embeds"].length != 0) {
          ServerController.controller.serversList[serverIndex]
              .channels[channelIndex].messages[messageIndex].embeds = embeds;
        }
        ServerController
            .controller.serversList[serverIndex].channels[channelIndex].messages
            .refresh();
      }
    }
  }

  static deleteMessage(dynamic json) {
    String messageId = json["id"];
    String channelId = json["channel"];
    int channelIndex;
    Channel channel;
    int serverIndex;
    Message message;
    int messageIndex;
    channelIndex =
        Client.channels.indexWhere((channel) => channel.id == channelId);

    if (channelIndex != -1) {
      // if (kDebugMode) print(message);
      if (kDebugMode) print(channelIndex);
      channel = Client.channels[channelIndex];
      // if (kDebugMode) print(channel);
      if (!ClientController.controller.home.value) {
        serverIndex = ServerController.controller.serversList
            .indexWhere((server) => server.id == channel.server);
        // if (kDebugMode) print(serverIndex);
        channelIndex = ServerController
            .controller.serversList[serverIndex].channels
            .indexWhere((channel) => channel.id == channelId);
        messageIndex = ServerController
            .controller.serversList[serverIndex].channels[channelIndex].messages
            .indexWhere((message) => message.id == messageId);

        if (messageIndex != -1) {
          message = ServerController.controller.serversList[serverIndex]
              .channels[channelIndex].messages[messageIndex];
          ServerController.controller.serversList[serverIndex]
              .channels[channelIndex].messages
              .remove(message);
          ServerController.controller.serversList[serverIndex]
              .channels[channelIndex].messages
              .refresh();
        }
      } else {
        if (ServerController.controller.homeIndex.value != 0) {
          channelIndex = ServerController.controller.homeIndex.value;
          messageIndex = Home.dms![channelIndex].messages
              .indexWhere((messages) => messages.id == messageId);
          if (messageIndex != -1) {
            message = Home.dms![channelIndex].messages[messageIndex];
            Home.dms![channelIndex].messages.remove(message);
            Home.dms![channelIndex].messages.refresh();
          }
        } else {
          messageIndex = Client.savedNotes.value.messages
              .indexWhere((messages) => messages.id == messageId);
          if (messageIndex != -1) {
            message = Client.savedNotes.value.messages[messageIndex];
            Client.savedNotes.value.messages.remove(message);
            Client.savedNotes.value.messages.refresh();
          }
        }
      }
    }
  }

  static ackMessage(dynamic json) {
    String messageId = json["message_id"];
    String channelId = json["id"];
    int channelIndex;
    Channel channel;
    int serverIndex;

    channelIndex =
        Client.channels.indexWhere((channel) => channel.id == channelId);

    if (channelIndex != -1) {
      // if (kDebugMode) print(message);
      // if (kDebugMode) print(channelIndex);
      channel = Client.channels[channelIndex];
      // if (kDebugMode) print(channel);
      serverIndex = ServerController.controller.serversList
          .indexWhere((server) => server.id == channel.server);
      // if (kDebugMode) print(serverIndex);

      if (serverIndex != -1) {
        channelIndex = ServerController
            .controller.serversList[serverIndex].channels
            .indexWhere((channel) => channel.id == channelId);
      }
      // if (kDebugMode) print(
      // "LAST ID: ${ServerController.controller.serversList[serverIndex].channels[channelIndex].unreads[0].lastId}");
      if (serverIndex != -1) {
        ServerController.controller.serversList[serverIndex]
            .channels[channelIndex].unreads[0].lastId.value = messageId;
      }
      // if (kDebugMode) print("ID: $messageId");
      // if (kDebugMode) print(
      // "LAST ID AFTER: ${ServerController.controller.serversList[serverIndex].channels[channelIndex].unreads[0].lastId}");
    }
  }

  static react(dynamic json) {
    String messageId = json["id"];
    String channelId = json["channel_id"];
    String userId = json["user_id"];
    String emojiId = json["emoji_id"];
    int channelIndex;
    Channel channel;
    int messageIndex;
    int serverIndex;

    channelIndex =
        Client.channels.indexWhere((channel) => channel.id == channelId);

    if (channelIndex != -1) {
      // if (kDebugMode) print(message);
      // if (kDebugMode) print(channelIndex);
      channel = Client.channels[channelIndex];
      // if (kDebugMode) print(channel);
      serverIndex = ServerController.controller.serversList
          .indexWhere((server) => server.id == channel.server);
      // if (kDebugMode) print(serverIndex);

      channelIndex = ServerController
          .controller.serversList[serverIndex].channels
          .indexWhere((channel) => channel.id == channelId);
      messageIndex = ServerController
          .controller.serversList[serverIndex].channels[channelIndex].messages
          .indexWhere((message) => message.id == messageId);

      final int reactionIndex = ServerController
          .controller
          .serversList[serverIndex]
          .channels[channelIndex]
          .messages[messageIndex]
          .reactions!
          .indexWhere((reaction) => reaction.emote == emojiId);

      if (reactionIndex != -1) {
        ServerController
            .controller
            .serversList[serverIndex]
            .channels[channelIndex]
            .messages[messageIndex]
            .reactions![reactionIndex]
            .reactors
            .add(userId);

        ServerController
            .controller.serversList[serverIndex].channels[channelIndex].messages
            .refresh();
      } else {
        ServerController.controller.serversList[serverIndex]
            .channels[channelIndex].messages[messageIndex].reactions
            ?.add(Reaction(emote: emojiId, reactors: [userId]));
        ServerController
            .controller.serversList[serverIndex].channels[channelIndex].messages
            .refresh();
      }
    }
  }

  static unreact(dynamic json) {
    String messageId = json["id"];
    String channelId = json["channel_id"];
    String userId = json["user_id"];
    String emojiId = json["emoji_id"];
    int channelIndex;
    Channel channel;
    int messageIndex;
    int serverIndex;

    channelIndex =
        Client.channels.indexWhere((channel) => channel.id == channelId);

    if (channelIndex != -1) {
      // if (kDebugMode) print(message);
      // if (kDebugMode) print(channelIndex);
      channel = Client.channels[channelIndex];
      // if (kDebugMode) print(channel);
      serverIndex = ServerController.controller.serversList
          .indexWhere((server) => server.id == channel.server);
      // if (kDebugMode) print(serverIndex);

      channelIndex = ServerController
          .controller.serversList[serverIndex].channels
          .indexWhere((channel) => channel.id == channelId);
      messageIndex = ServerController
          .controller.serversList[serverIndex].channels[channelIndex].messages
          .indexWhere((message) => message.id == messageId);

      final int reactionIndex = ServerController
          .controller
          .serversList[serverIndex]
          .channels[channelIndex]
          .messages[messageIndex]
          .reactions!
          .indexWhere((reaction) => reaction.emote == emojiId);
      final int reactorIndex = ServerController
          .controller
          .serversList[serverIndex]
          .channels[channelIndex]
          .messages[messageIndex]
          .reactions![reactionIndex]
          .reactors
          .indexWhere((reaction) => reaction == userId);

      ServerController
          .controller
          .serversList[serverIndex]
          .channels[channelIndex]
          .messages[messageIndex]
          .reactions![reactionIndex]
          .reactors
          .removeAt(reactorIndex);
      if (ServerController
          .controller
          .serversList[serverIndex]
          .channels[channelIndex]
          .messages[messageIndex]
          .reactions![reactionIndex]
          .reactors
          .isEmpty) {
        ServerController.controller.serversList[serverIndex]
            .channels[channelIndex].messages[messageIndex].reactions!
            .removeAt(reactionIndex);
      }

      ServerController
          .controller.serversList[serverIndex].channels[channelIndex].messages
          .refresh();
    }
  }

// TYPING EVENTS

  static startTyping(dynamic json) async {
    final String channelId = json["id"];
    final String userId = json["user"];
    final int userIndex;
    final User? user;
    // if (kDebugMode) print(userId);
    final channelIndex = ServerController.controller.selected.value.channels
        .indexWhere((channel) => channel.id == channelId);
    if (channelIndex != -1) {
      // if (kDebugMode) print(channelIndex);
      userIndex = ServerController.controller.selected.value.users
          .indexWhere((user) => user.id == userId);
      if (userIndex != -1) {
        user = ServerController.controller.selected.value.users[userIndex];
        // if (kDebugMode) print("user: $user");
        if (!ServerController
            .controller.selected.value.channels[channelIndex].typingList
            .contains(user)) {
          ServerController
              .controller.selected.value.channels[channelIndex].typingList
              .add(user);
          if (kDebugMode) {
            print(
                "add ${ServerController.controller.selected.value.channels[channelIndex].typingList}");
          }

          if (kDebugMode) {
            print(
                "add ${ServerController.controller.selected.value.channels[channelIndex].typingList.length}");
          }
        }
      } else {
        user = await User.fetch(userId);
        if (kDebugMode) print("user: ${user.name}");
        if (!ServerController
            .controller.selected.value.channels[channelIndex].typingList
            .contains(user)) {
          ServerController
              .controller.selected.value.channels[channelIndex].typingList
              .add(user);
          if (kDebugMode) {
            print(
                "add ${ServerController.controller.selected.value.channels[channelIndex].typingList}");
          }
          if (kDebugMode) {
            print(
                "add ${ServerController.controller.selected.value.channels[channelIndex].typingList.length}");
          }
        }
      }
    }
  }

  static stopTyping(dynamic json) {
    final String channelId = json["id"];
    final String userId = json["user"];
    final channelIndex = ServerController.controller.selected.value.channels
        .indexWhere((channel) => channel.id == channelId);
    if (channelIndex != -1) {
      ServerController
          .controller.selected.value.channels[channelIndex].typingList
          .removeWhere((person) => person.id == userId);
      if (kDebugMode) {
        print(
            "remove ${ServerController.controller.selected.value.channels[channelIndex].typingList}");
      }
      if (kDebugMode) {
        print(
            "remove ${ServerController.controller.selected.value.channels[channelIndex].typingList.length}");
      }
      // }
    }
  }

// SERVER EVENTS

  static memberUpdate(dynamic json) async {
    final Map id = json["id"];
    final String serverId = id["server"];
    final String userId = id["user"];
    final Map data = json["data"];
    final List<dynamic> clear = json["clear"];
    final int serverIndex;
    final Server? server;
    final int memberIndex;
    late final Member member;

    serverIndex = ServerController.controller.serversList
        .indexWhere((server) => server.id == serverId);
    if (serverIndex != -1) {
      memberIndex = ServerController.controller.serversList[serverIndex].members
          .indexWhere((member) => member.userId == userId);
      if (memberIndex != -1) {
        member = ServerController
            .controller.serversList[serverIndex].members[memberIndex];
        // if (kDebugMode) print(member.nickname?.value ?? member.userId);
      }
      server = ServerController.controller.serversList[serverIndex];
      if (data["nickname"] != null) {
        server.members[memberIndex].nickname?.value = data["nickname"];
        if (kDebugMode) print('[Updated] member nickname');
      }
      if (data["avatar"] != null) {
        server.members[memberIndex].avatar.value =
            Avatar.fromJson(data["avatar"]);
        if (kDebugMode) print('[Updated] member avatar');

        // }if (data["roles"]!= null) {
        //   server.members[memberIndex].roles = data["roles"];

        if (clear != []) {
          if (clear.contains("nickname")) {
            // server.members[memberIndex].nickname?.value = '';
          }
          if (clear.contains("avatar")) {
            server.members[memberIndex].avatar.value = null;
          }
        }
      }
    }
  }

  static memberJoin(dynamic json) async {
    final String serverId = json["id"];
    final String userId = json["user"];
    final int serverIndex;
    final Server? server;
    final User user;

    user = await User.fetch(userId);
    if (kDebugMode) print(user.name);
    serverIndex = ServerController.controller.serversList
        .indexWhere((server) => server.id == serverId);
    if (serverIndex != -1) {
      server = ServerController.controller.serversList[serverIndex];
      server.users.add(user);
      if (kDebugMode) print('[Added] user');
    }
  }

// USER EVENTS
  static updateUser(dynamic json) {
    final String userId = json['id'];
    final dynamic update = json['data'];
    final List<dynamic>? clear = json['clear'];
    if (kDebugMode) print("$userId, $update, $clear");
    for (Server server in ServerController.controller.serversList) {
      for (User user in server.users) {
        if (user.id == userId) {
          User.update(update, user);
        }
      }
    }
  }

// AUTH EVENTS
  static revokeSession(dynamic json) async {
    final sessionId = json["session_id"];
    // final userId= json["user_id"];
    if (kDebugMode) print(sessionId + Client.currentSession.value.id);
    Client.sessions.removeWhere((session) => session.id == sessionId);
    if (sessionId == Client.currentSession.value.id) {
      ClientController.controller.updateLogStatus(false);
    }
  }

  static revokeAllSessions(dynamic json) async {
    // final excludedSessionId = json["exclude_session_id"];
    // final userId= json["user_id"];
    // Client.sessions.removeWhere((session) => session.id == sessionId);
  }
}
