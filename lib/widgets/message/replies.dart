// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/widgets/reactions/reactor_tile.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/custom/markdown.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/models/server.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/themes/ui.dart';
import 'package:pillowchat/themes/markdown.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Replies extends StatelessWidget {
  const Replies(this.messages, this.itemScrollController, {super.key});
  final dynamic messages;
  final ItemScrollController itemScrollController;

  @override
  Widget build(BuildContext context) {
    late int contentIndex;
    late int userIndex;
    late int memberIndex;
    late String author;
    bool hasAttachment = false;

    late Message reply;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: messages.repliesId.length,
      itemBuilder: (context, index) {
        // MATCH MESSAGES TO REPLIES

        if (ChannelController.controller.selected.value.messages
            .any((message) => message.id == messages.repliesId[index])) {
          contentIndex = ChannelController.controller.selected.value.messages
              .indexWhere(
                  (message) => messages.repliesId[index].contains(message.id));
        } else {
          // IF NO MATCH IN MESSAGE LIST
          contentIndex = 0;
        }
        reply =
            ChannelController.controller.selected.value.messages[contentIndex];
        author = ChannelController
            .controller.selected.value.messages[contentIndex].author!;
        {
          // IF MESSAGE IS A MATCH

          if (contentIndex != 0) {
            // IF MESSAGE MATCHES AND DOES NOT HAVE ATTACHMENTS

            if (ChannelController.controller.selected.value.messages.any(
              (message) =>
                  message.id == messages.repliesId[index] &&
                  message.attachments?.length == 0,
            )) {
              // content = ChannelController
              // .controller.selected.value.messages[contentIndex].content!;
            }
            // IF MESSAGE HAS ATTACHMENTS

            else if (ChannelController.controller.selected.value
                        .messages[contentIndex].attachments?.length !=
                    0 &&
                contentIndex != 0) {
              if (ChannelController.controller.selected.value
                      .messages[contentIndex].content !=
                  '') {
                hasAttachment = true;
                // content = ChannelController
                //     .controller.selected.value.messages[contentIndex].content!;
              } else {
                hasAttachment = true;
                // content = '';
              }
            } // IF MESSAGE IS NOT IN LIST, CONTENT DOES NOT EXIST
          } else {
            // content = '';
          }
          // MATCH REPLY AUTHOR TO PAST MESSAGE

          if (ChannelController.controller.selected.value.messages
                  .any((message) => message.id == messages.repliesId[index]) &&
              contentIndex != 0) {
            author = reply.author!;
            userIndex = ChannelController.controller.selected.value.users
                .indexWhere((user) => user.id == author);
          }
          userIndex = ChannelController.controller.selected.value.users
              .indexWhere((user) => user.id == author);
          memberIndex = ServerController.controller.selected.value.members
              .indexWhere((member) => member.userId == author);
        }
        // GET USER OBJECT

        late User user = User(id: '', name: '');
        if (userIndex != -1) {
          user = ChannelController.controller.selected.value.users[userIndex];
        }

        // GET MEMBER OBJECT

        Member? member;
        if (memberIndex != -1) {
          member =
              ServerController.controller.selected.value.members[memberIndex];
        }

        // GET AVATAR URL
        String url = ReactorTile.getUrl(true, user,
            serverMember: member, messageIndex: reply);

        return Padding(
          padding: EdgeInsets.only(
            top: index == 0 ? 8 : 0,
            left: 8,
            bottom: 2,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // REPLY LINES

              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 12,
                      height: 2,
                      decoration: const BoxDecoration(
                        // color: Dark.primaryHeader.value,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25)),
                      ),
                    ),
                    // Container(
                    //   width: 2,
                    //   height: 8,
                    //   color: Dark.primaryHeader.value,
                    // )
                  ],
                ),
              ),

              // REPLY

              Flexible(
                child: InkWell(
                  onTap: () {
                    User.view(
                      context,
                      userIndex,
                      user,
                      user.avatar?.value.id,
                      user.status.presence,
                      user.status.text ?? '',
                      user.id,
                      member!.roles,
                    );
                  },
                  child: ReplyTile(
                    contentIndex: contentIndex,
                    url: url,
                    user: user,
                    member: member,
                    messages: messages,
                    reply: reply,
                    itemScrollController: itemScrollController,
                    hasAttachment: hasAttachment,
                    // content: content,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class ReplyTile extends StatelessWidget {
  ReplyTile({
    super.key,
    this.contentIndex,
    this.itemScrollController,
    this.showMention,
    required this.url,
    required this.user,
    required this.member,
    required this.messages,
    required this.reply,
    required this.hasAttachment,
  });

  final int? contentIndex;
  final String url;
  final User user;
  final Member? member;
  final Message messages;
  final Message reply;
  final ItemScrollController? itemScrollController;
  final bool hasAttachment;
  bool mentions = false;
  bool? showMention = true;

  @override
  Widget build(BuildContext context) {
    if (messages.mentions?.length != 0) {
      mentions = messages.mentions!.contains(reply.author);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // REPLIED USER ICON
        if (contentIndex != 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: UserIcon(
              url: url.obs,
              user: user,
              hasStatus: false,
              radius: 15,
            ),
          ),

        if (contentIndex != 0)
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GradientText(
              member?.nickname?.value != '' && member?.nickname?.value != null
                  ? mentions && showMention!
                      ? "@${member?.nickname!.value.trim()}"
                      : member!.nickname!.value.trim()
                  : user.bot == null || reply.masquerade?.name == ''
                      ? user.displayName != null
                          ? mentions && showMention != false
                              ? "@${user.displayName!.trim()}"
                              : user.displayName!.trim()
                          : mentions && showMention!
                              ? "@${user.name.trim()}"
                              : user.name.trim()
                      : mentions && showMention!
                          ? "@${reply.masquerade!.name.trim()}"
                          : reply.masquerade!.name.trim(),
              colors: member != null &&
                      member!.roles.isNotEmpty &&
                      member!.roles[0].color != null &&
                      member!.roles[0].color!.contains("gradient")
                  ? Role.getCssGradient(member!.roles[0].color!)
                  : ClientController.controller.home.value ||
                          user.bot != null &&
                              reply.masquerade?.name != '' &&
                              reply.masquerade?.color == null
                      ? [Dark.foreground.value, Dark.foreground.value]
                      : reply.masquerade?.color != null &&
                              reply.masquerade?.color!.length == 7
                          ? [
                              Color(int.parse(
                                  "0xff${reply.masquerade!.color!.replaceAll('#', '')}")),
                              Color(int.parse(
                                  "0xff${reply.masquerade!.color!.replaceAll('#', '')}"))
                            ]
                          : member != null &&
                                  member!.roles.isNotEmpty &&
                                  member!.roles[0].color != '' &&
                                  member!.roles[0].color?.length == 7
                              ? [
                                  Color(
                                    int.parse(
                                        '0xff${member!.roles[0].color?.replaceAll("#", "")}'),
                                  ),
                                  Color(
                                    int.parse(
                                        '0xff${member!.roles[0].color?.replaceAll("#", "")}'),
                                  )
                                ]
                              : [Dark.foreground.value, Dark.foreground.value],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ClientController.controller.fontSize.value * .9,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

        // BOT OR BRIDGE ICON

        if (user.bot != null &&
            reply.masquerade?.name == '' &&
            contentIndex != 0)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              Icons.smart_toy,
              color: Dark.accent.value,
              size: ClientController.controller.fontSize.value * .9,
            ),
          )
        else if (user.bot != null &&
            reply.masquerade?.name != '' &&
            contentIndex != 0)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              Icons.link,
              color: Dark.accent.value,
              size: ClientController.controller.fontSize.value * .9,
            ),
          ),
        Flexible(
          child: InkWell(
            hoverColor: Dark.accent.value.withOpacity(0.2),
            onTap: () {
              // SCROLL TO REPLIED TO MESSAGE

              if (contentIndex != null) {
                itemScrollController?.scrollTo(
                    index: contentIndex!,
                    duration: const Duration(milliseconds: 100));
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasAttachment && contentIndex != 0)
                  Flexible(
                    child: Icon(
                      Icons.sticky_note_2_rounded,
                      size: ClientController.controller.fontSize.value * .9,
                    ),
                  ),
                if (hasAttachment && contentIndex != 0)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CustomMarkdownBody(
                        data: '*Sent an attachment*',
                        overflow: TextOverflow.ellipsis,
                        styleSheet: markdown.replyStyleSheet,
                      ),
                    ),
                  ),
                if (contentIndex != 0 &&
                        reply.content != null &&
                        !reply.content!.contains("[]") &&
                        reply.content != ' ' &&
                        reply.content != '' ||
                    contentIndex != 0 &&
                        reply.content != null &&
                        reply.content != ' ' &&
                        reply.content != '' ||
                    contentIndex == 0)
                  Expanded(
                    flex: 4,
                    child: CustomMarkdownBody(
                      onTapLink: (text, href, title) {
                        if (contentIndex != 0) {
                          jumpToReply() {
                            itemScrollController?.jumpTo(index: contentIndex!);
                          }

                          jumpToReply();
                        }
                      },
                      data: contentIndex != 0 &&
                              reply.content != null &&
                              reply.content != ' '
                          ? reply.content!.replaceAll("\n", ' ')
                          : "  *Couldn't load message*",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      styleSheet: markdown.replyStyleSheet,
                      builders: markdown.builders,
                      extensionSet: markdown.extensionSet,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
