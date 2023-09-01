// ignore_for_file:

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/themes/ui.dart';
import 'package:pillowchat/widgets/message/replies.dart';
import 'package:pillowchat/widgets/reactions/reactor_tile.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({super.key});

  static TextEditingController messageController = TextEditingController();
  static bool unlocked = true;
  static bool editing = false;
  static late String id;
  static late String initialContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 2,
        bottom: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Dark.secondaryHeader.value,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Obx(
          () => Column(
            children: [
              if (ChannelController.controller.editing.value)
                // EDITING BANNER

                Material(
                  type: MaterialType.transparency,
                  child: ListTile(
                      textColor: Dark.secondaryHeader.value,
                      leading: const Icon(Icons.edit),
                      title: const Text('Editing'),
                      trailing: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Dark.accent.value,
                          ),
                          onPressed: () {
                            editing = false;
                            ChannelController.controller.toggleEditing(editing);
                            messageController.clear();
                          })),
                ),

              if (ChannelController
                  .controller.selected.value.replyList.isNotEmpty)

                // REPLYING BANNER

                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: ChannelController
                        .controller.selected.value.replyList.length,
                    itemBuilder: (context, index) {
                      Message message = ChannelController
                          .controller.selected.value.replyList[index];
                      User? user;
                      int userIndex = ChannelController
                          .controller.selected.value.users
                          .indexWhere((users) => users.id == message.author);
                      if (userIndex != -1) {
                        user = ChannelController
                            .controller.selected.value.users[userIndex];
                      }
                      Member? member;
                      int memberIndex = ChannelController
                          .controller.selected.value.members
                          .indexWhere(
                              (members) => members.userId == message.author);
                      if (memberIndex != -1) {
                        member = ChannelController
                            .controller.selected.value.members[memberIndex];
                      }
                      return MessageBanner(
                        icon: Icons.reply_rounded,
                        hasTrailing: true,
                        trailingColor: Dark.secondaryForeground.value,
                        index: index,
                        message: message,
                        url: ReactorTile.getUrl(
                          true,
                          user!,
                          messageIndex: message,
                          serverMember: member,
                        ),
                        user: user,
                        member: member,
                        messages: ChannelController
                            .controller.selected.value.replyList,
                        onPressed: () {
                          ChannelController.controller.removeReply(message);
                        },
                      );
                    },
                  ),
                ),
              // BOX
              ListTile(
                horizontalTitleGap: 0,
                minVerticalPadding: 0,
                minLeadingWidth: 0,
                contentPadding: const EdgeInsets.all(0),
                title: TextField(
                  controller: messageController,
                  maxLines: null,
                  maxLength: 2000,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  readOnly: !ChannelController.controller.unlocked.value,
                  decoration: InputDecoration(
                      filled: false,
                      constraints: const BoxConstraints(maxHeight: 220),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: unlocked ? 4 : 8,
                      ),
                      border: InputBorder.none,

                      // SAVED NOTES HINT TEXT

                      hintText: ClientController.controller.home.value &&
                              ChannelController
                                      .controller.selected.value.type ==
                                  'SavedMessages'
                          ? "Save to your notes"

                          // CHANNEL HINT TEXT

                          : ChannelController.controller.unlocked.value == false
                              ? ''
                              : ClientController.controller.home.value &&
                                      ChannelController
                                              .controller.selected.value.name !=
                                          null
                                  ? 'Message ${ChannelController.controller.selected.value.name}'
                                  : ChannelController
                                              .controller.selected.value.type ==
                                          "DirectMessage"
                                      ? 'Message friend'
                                      : 'Message #${ChannelController.controller.selected.value.name}',
                      hintStyle: TextStyle(
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                          color: Dark.secondaryForeground.value),
                      counterText: ''),
                ),
                leading: Visibility(
                  visible: unlocked,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                    ),
                  ),
                ),
                trailing: unlocked && !editing
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.emoji_emotions,
                            ),
                          ),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(
                              Icons.send,
                            ),
                            onPressed: () {
                              // MAKE MESSAGE BOX CONTROLLER TEXT = CONTENT

                              final content = messageController.text;
                              if (content.trim() != '') {
                                Message.send(content,
                                    replyList: ChannelController
                                        .controller.selected.value.replyList);
                                messageController.clear();
                              }
                              ChannelController
                                  .controller.selected.value.replyList
                                  .clear();
                              ChannelController
                                  .controller.selected.value.mentionList
                                  ?.clear();

                              // ItemScrollController().jumpTo(index: 0);
                            },
                          ),
                        ],
                      )
                    : editing == true
                        ? IconButton(
                            onPressed: () {
                              if (messageController.text != initialContent) {
                                final content = messageController.text;
                                Message.edit(content, id);
                              }

                              editing = false;
                              ChannelController.controller
                                  .toggleEditing(editing);
                              messageController.clear();
                            },
                            icon: Icon(
                              Icons.send,
                              color: Dark.accent.value,
                            ))
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.lock_rounded,
                              color: Dark.accent.value,
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBanner extends StatelessWidget {
  const MessageBanner({
    super.key,
    this.title,
    this.icon,
    required this.trailingColor,
    required this.hasTrailing,
    required this.onPressed,
    this.message,
    this.url,
    this.user,
    this.member,
    this.messages,
    this.index,
  });
  final String? title;
  final IconData? icon;
  final Color trailingColor;
  final bool hasTrailing;
  final dynamic onPressed;
  final Message? message;
  final String? url;
  final User? user;
  final Member? member;
  final dynamic messages;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Obx(
        () => ListTile(
            dense: message != null ? true : false,
            minLeadingWidth: 0,
            horizontalTitleGap: 4,
            textColor: Dark.secondaryHeader.value,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon),
                if (message != null &&
                    message?.author !=
                        ClientController.controller.selectedUser.value.id)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.alternate_email,
                        color: ChannelController
                                .controller.selected.value.mentionList![index!]
                            ? Dark.accent.value
                            : Dark.secondaryForeground.value,
                      ),
                      onPressed: () {
                        ChannelController.controller.selected.value
                                .mentionList![index!] =
                            !ChannelController
                                .controller.selected.value.mentionList![index!];
                      },
                    ),
                  ),
              ],
            ),
            title: title != null
                ? Text(title!)
                : ReplyTile(
                    url: url!,
                    user: user!,
                    member: member,
                    messages: message!,
                    reply: message!,
                    // ignore: prefer_is_empty
                    hasAttachment: message?.attachments?.length != 0,
                  ),
            trailing: hasTrailing
                ? IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: trailingColor,
                    ),
                    onPressed: onPressed)
                : null),
      ),
    );
  }
}
