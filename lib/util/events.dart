// ignore_for_file:

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/events.dart';
import 'package:pillowchat/models/message/message.dart';

eventsHandler(BuildContext context, dynamic json, var socket) {
  switch (json['type']) {
    // MESSAGE

    case 'Message':
      Message message = Message.fromJson(json);
      Events.addMessage(message);
      // if (kDebugMode) print('[events]: Message');
      break;

    case 'MessageUpdate':
      Events.updateMessage(json);
      // if (kDebugMode) print('[events]: Message Update');

      break;

    case 'MessageAppend':
      // Events.appendMessage(json);
      // if (kDebugMode) print('[events]: Message Append');

      break;

    case 'MessageDelete':
      Events.deleteMessage(json);
      if (kDebugMode) print('[events]: Message Delete');

      break;

    case 'MessageReact':
      if (kDebugMode) print('[events]: Message React');
      Events.react(json);

      break;

    case 'MessageUnreact':
      if (kDebugMode) print('[events]: Message Unreact');
      Events.unreact(json);

      break;

    case 'MessageRemoveReaction':
      if (json['channel'] == ChannelController.controller.selected.value.id) {
        if (kDebugMode) print('[events]: Message RemoveReaction');
      }
      break;

    // CHANNEL

    case 'ChannelStartTyping':
      Events.startTyping(json);
      if (json['id'] == ChannelController.controller.selected.value.id) {
        // if (kDebugMode) print('[events]: Message Start Typing');
        ChannelController.controller.triggerTyping(true);
        // ChannelController.controller.typingUsers(json['user']);
      }
      break;

    case 'ChannelStopTyping':
      Events.stopTyping(json);
      if (json['id'] == ChannelController.controller.selected.value.id) {
        // if (kDebugMode) print('[events]: Message Stop Typing');
        ChannelController.controller.triggerTyping(false);
      }
      break;

    case 'ChannelAck':
      if (kDebugMode) print('[events]: Message Ack');
      Events.ackMessage(json);

      break;

    // SERVER

    case 'ServerCreate':
      // if (kDebugMode) print('[events]: Server Create');
      // Events.serverCreate(json);
      break;
    case 'ServerUpdate':
      // if (kDebugMode) print('[events]: Server Update');
      // Events.serverUpdate(json);
      break;
    case 'ServerDelete':
      // if (kDebugMode) print('[events]: Server Delete');
      // Events.serverDelete(json);
      break;

    case 'ServerMemberUpdate':
      // if (kDebugMode) print('[events]: Server Member Update');
      // Events.memberUpdate(json);
      break;
    case 'ServerMemberJoin':
      if (kDebugMode) print('[events]: Server Member Join');
      Events.memberJoin(json);
      break;

    case 'ServerMemberLeave':
      // if (kDebugMode) print('[events]: Server Member Leave');
      // Events.memberLeave(json);
      break;
    // USER
    case 'UserUpdate':
      // Events.updateUser(json);
      // if (kDebugMode) print('[events]: User Update');
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
      if (kDebugMode) print('[events]: Auth');
      switch (json["event_type"]) {
        case 'DeleteSession':
          if (kDebugMode) print('[events]: Session Deleted');
          Events.revokeSession(json);
          break;
        case 'DeleteAllSessions':
          if (kDebugMode) print('[events]: Deleted All Session');
          Events.revokeAllSessions(json);
          break;
      }

      break;
  }
  if (ClientController.controller.logged.value == false) {
    if (kDebugMode) print("[isNotLogged]");
    Navigator.popAndPushNamed(context, '/login');
    socket.sink.close();
  }
}
