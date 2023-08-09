// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/events.dart';
import 'package:pillowchat/main.dart';
import 'package:pillowchat/models/message/message.dart';

eventsHandler(dynamic json, var socket) {
  switch (json['type']) {
    // MESSAGE

    case 'Message':
      Message message = Message.fromJson(json);
      Events.addMessage(message);
      // print('[events]: Message');
      break;

    case 'MessageUpdate':
      Events.updateMessage(json);
      // print('[events]: Message Update');

      break;

    case 'MessageAppend':
      // Events.appendMessage(json);
      // print('[events]: Message Append');

      break;

    case 'MessageDelete':
      Events.deleteMessage(json);
      // print('[events]: Message Delete');

      break;

    case 'MessageReact':
      if (json['channel_id'] ==
          ChannelController.controller.selected.value.id) {
        print('[events]: Message React');
      }
      break;

    case 'MessageUnreact':
      print('[events]: Message Unreact');
      Events.unreact(json);

      break;

    case 'MessageRemoveReaction':
      if (json['channel'] == ChannelController.controller.selected.value.id) {
        print('[events]: Message RemoveReaction');
      }
      break;

    // CHANNEL

    case 'ChannelStartTyping':
      Events.startTyping(json);
      if (json['id'] == ChannelController.controller.selected.value.id) {
        // print('[events]: Message Start Typing');
        ChannelController.controller.triggerTyping(true);
        // ChannelController.controller.typingUsers(json['user']);
      }
      break;

    case 'ChannelStopTyping':
      Events.stopTyping(json);
      if (json['id'] == ChannelController.controller.selected.value.id) {
        // print('[events]: Message Stop Typing');
        ChannelController.controller.triggerTyping(false);
      }
      break;

    case 'ChannelAck':
      print('[events]: Message Ack');
      Events.ackMessage(json);

      break;

    // SERVER

    case 'ServerCreate':
      // print('[events]: Server Create');
      // Events.serverCreate(json);
      break;
    case 'ServerUpdate':
      // print('[events]: Server Update');
      // Events.serverUpdate(json);
      break;
    case 'ServerDelete':
      // print('[events]: Server Delete');
      // Events.serverDelete(json);
      break;

    case 'ServerMemberUpdate':
      // print('[events]: Server Member Update');
      // Events.memberUpdate(json);
      break;
    case 'ServerMemberJoin':
      print('[events]: Server Member Join');
      Events.memberJoin(json);
      break;

    case 'ServerMemberLeave':
      // print('[events]: Server Member Leave');
      // Events.memberLeave(json);
      break;
    // USER
    case 'UserUpdate':
      // Events.updateUser(json);
      // print('[events]: User Update');
      break;
    case 'UserRelationship':
      break;
    case 'UserPlatformWipe':
      break;

    // EMOJI
    case 'EmojiCreate':
      break;
    case 'EmojiDelete':
      break;
    // AUTH

    case 'Auth':
      print('[events]: Auth');
      switch (json["event_type"]) {
        case 'DeleteSession':
          print('[events]: Session Deleted');
          Events.revokeSession(json);
          break;
        case 'DeleteAllSessions':
          print('[events]: Deleted All Session');
          Events.revokeAllSessions(json);
          break;
      }

      break;
  }
  if (ClientController.controller.logged.value == false) {
    print("[isNotLogged]");
    Navigator.pushReplacementNamed(
        MyApp.navigatorKey.currentState!.context, '/login');
    socket.sink.close();
  }
}
