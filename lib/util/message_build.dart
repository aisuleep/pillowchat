// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pillowchat/components/message/replies.dart';
import 'package:pillowchat/components/message/messsage_tile.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/models/user.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:ulid/ulid.dart';

class MessageBuild extends StatelessWidget {
  MessageBuild({Key? key}) : super(key: key);

  final ItemScrollController itemController = ItemScrollController();
  final ItemPositionsListener itemListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollListener = ScrollOffsetListener.create();
  static Rx<int> scrollIndex = 0.obs;
  final RxList<Message> channelMessages =
      ChannelController.controller.selected.value.messages;
  static RxList<int> indices = <int>[].obs;
  @override
  Widget build(BuildContext context) {
    itemListener.itemPositions.addListener(() {
      indices = itemListener.itemPositions.value
          .where((item) {
            final isTopVisible = item.itemLeadingEdge >= 0;
            final isBottomVisible = item.itemTrailingEdge <= 1;
            return isTopVisible && isBottomVisible;
          })
          .map((item) => item.index)
          .toList()
          .obs;
      print(indices);
      if (indices.contains(0)) {
        int? isUnread;
        // IF MESSAGE IS NEWER THAN CHANNEL LAST UNREAD MESSAGE

        if (ChannelController.controller.selected.value.unreads.isNotEmpty) {
          isUnread = ChannelController.controller.selected.value.messages[0].id
              ?.compareTo(ChannelController
                  .controller.selected.value.unreads[0].lastId.value);
        }
        // IF MESSAGE IS UNREAD

        if (isUnread != 0 && indices.contains(0)) {
          Message.ack(
              ChannelController.controller.selected.value.messages[0].id!);
          ChannelController.controller.selected.value.unreads[0].lastId.value =
              ChannelController.controller.selected.value.messages[0].id!;
        }
      }
      if (indices.contains(channelMessages.length - 2)) {
        final String channelId = ChannelController.controller.selected.value.id;
        final int index = ServerController.controller.selected.value.channels
            .indexWhere((channel) => channel.id == channelId);
        print('at top');
        if (index != -1) {
          Message.fetch(channelId, index,
              oldestMessage: channelMessages[channelMessages.length - 2].id);
        }
      }
    });
    // LIST OF MESSAGES

    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(
          left: 8,
          bottom: 8,
        ),
        child: ScrollablePositionedList.builder(
          reverse: true,
          // initialScrollIndex: 4,
          initialAlignment: 0.5,
          itemScrollController: itemController,
          itemPositionsListener: itemListener,
          scrollOffsetListener: scrollListener,
          itemCount:
              ChannelController.controller.selected.value.messages.length,
          itemBuilder: (context, index) {
            scrollIndex = index.obs;

            final messageIndex = channelMessages[index];
            final messageAuthor = channelMessages[index].author!;
            final userIndex = ChannelController.controller.selected.value.users
                .indexWhere((user) => user.id == messageAuthor);
            // final recipientIndex = ChannelController
            //     .controller.selected.value.users
            //     .indexWhere((user) => user.id == messageAuthor);
            User user = User(id: '', name: '');
            if (userIndex != -1) {
              ServerController.controller.selected.value.users =
                  ChannelController.controller.selected.value.users;
              user =
                  ServerController.controller.selected.value.users[userIndex];

              // ChannelController.controller.selected.value.users[userIndex];
              // } else if (recipientIndex != -1) {
              //   final recipient = ChannelController
              //       .controller.selected.value.recipients?[recipientIndex];
              //   final matchIndex = ChannelController
              //       .controller.selected.value.users
              //       .indexWhere((user) => user.id == recipient);
              //   user =
              //       ChannelController.controller.selected.value.users[matchIndex];
            }
            final memberIndex = ServerController
                .controller.selected.value.members
                .indexWhere((member) => member.userId == messageAuthor);
            Member? member = Member('', '');
            if (memberIndex != -1) {
              member = ServerController
                  .controller.selected.value.members[memberIndex];
            }

            // IF MESSAGE SHOULD BE APPENDED

            String prevMessageAuthor = '';
            int previousIndex = index + 1;
            if (previousIndex != channelMessages.length) {
              if (channelMessages[index].author ==
                  channelMessages[previousIndex].author) {
                prevMessageAuthor = channelMessages[previousIndex].author!;
                // print('minus 1: $prevMessageAuthor ' + messageAuthor);
              }
            }
            previousIndex = index + 1;

            // PARSER TIME

            Ulid ulid = Ulid.parse(messageIndex.id!);
            DateTime timestamp =
                DateTime.fromMillisecondsSinceEpoch(ulid.toMillis()).toLocal();

            final String sentDay = DateFormat.Md().format(timestamp);
            final String currentDay = DateFormat.Md().format(DateTime.now());
            final String yesterDay = DateFormat.Md()
                .format(DateTime.now().subtract(const Duration(days: 1)));

            // 12 HOUR TIME
            late String time;
            if (ClientController.controller.time.value == 0) {
              time = DateFormat.jm().format(timestamp);
            }
            // 24 HOUR TIME

            else {
              time = DateFormat.Hm().format(timestamp);
            }
            // final DateTime fiveMinutesFrom =
            //     timestamp.add(const Duration(minutes: 5));
            // final fromSentTime = fiveMinutesFrom.isAfter(timestamp);
            // final toFiveMinutes = fiveMinutesFrom.isBefore(fiveMinutesFrom);
            // late dynamic reactIndex;

            return Column(
              children: [
                // IF MESSAGE HAS REPLIES
                if (messageIndex.repliesId != null)

                  //   // LIST OF REPLIES
                  Replies(
                    messageIndex,
                    itemController,
                  ),

                // MESSAGE

                MessageTile(
                  messageIndex: messageIndex,
                  index: index,
                  userIndex: userIndex,
                  author: messageAuthor,
                  // todo: previous avatar so bridge properly groups automod
                  previousAuthor: prevMessageAuthor,
                  sentDay: sentDay,
                  currentDay: currentDay,
                  yesterDay: yesterDay,
                  time: time,
                  // fromSentTime: fromSentTime,
                  // fiveMinutes: toFiveMinutes,
                  user: user,
                  member: member,
                  content: messageIndex.content,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
