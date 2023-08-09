// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:pillowchat/components/reactions/reactor_tile.dart';
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
  const Replies(this.messageIndex, this.itemScrollController, {super.key});
  final dynamic messageIndex;
  final ItemScrollController itemScrollController;

  @override
  Widget build(BuildContext context) {
    late String content = '';
    late int contentIndex;
    late int userIndex;
    late int memberIndex;
    // late int nicknameIndex;
    // late int masqueradeIndex;
    late String author;
    late bool hasAttachment = false;
    late Message replyIndex;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: messageIndex.repliesId.length,
      itemBuilder: (context, index) {
        // MATCH MESSAGES TO REPLIES

        if (ChannelController.controller.selected.value.messages
            .any((message) => message.id == messageIndex.repliesId[index])) {
          contentIndex = ChannelController.controller.selected.value.messages
              .indexWhere((message) =>
                  messageIndex.repliesId[index].contains(message.id));
        } else {
          // IF NO MATCH IN MESSAGE LIST
          contentIndex = 0;
        }
        replyIndex =
            ChannelController.controller.selected.value.messages[contentIndex];
        author = ChannelController
            .controller.selected.value.messages[contentIndex].author!;
        {
          // IF MESSAGE IS A MATCH

          if (contentIndex != 0) {
            // IF MESSAGE MATCHES AND DOES NOT HAVE ATTACHMENTS

            if (ChannelController.controller.selected.value.messages.any(
              (message) =>
                  message.id == messageIndex.repliesId[index] &&
                  message.attachments?.length == 0,
            )) {
              // if (content != '') {
              content = ChannelController
                  .controller.selected.value.messages[contentIndex].content!;
              // }
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
                content = ChannelController
                    .controller.selected.value.messages[contentIndex].content!;
              } else {
                hasAttachment = true;
                content = '';
              }
            } // IF MESSAGE IS NOT IN LIST, CONTENT DOES NOT EXIST
          } else {
            content = '';
          }
          // MATCH REPLY AUTHOR TO PAST MESSAGE

          if (ChannelController.controller.selected.value.messages.any(
                  (message) => message.id == messageIndex.repliesId[index]) &&
              contentIndex != 0) {
            author = replyIndex.author!;
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
            serverMember: member, messageIndex: replyIndex);

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
                      width: 14,
                      height: 2,
                      decoration: BoxDecoration(
                        color: Dark.primaryHeader.value,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25)),
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 8,
                      color: Dark.primaryHeader.value,
                    )
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
                      user.avatar,
                      user.status.presence,
                      user.status.text ?? '',
                      user.id,
                      member!.roles,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // REPLIED USER ICON
                      if (contentIndex != 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: UserIcon(
                            url: url,
                            hasStatus: false,
                            radius: 15,
                          ),
                        ),
                      if (messageIndex.mentions.length != 0 &&
                          contentIndex != 0)
                        Text(
                          '@',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ClientController.controller.home.value ||
                                    user.bot != null &&
                                        replyIndex.masquerade?.name != ''
                                ? Dark.foreground.value
                                : member != null &&
                                        member.roles.isNotEmpty &&
                                        member.roles[0].color != '' &&
                                        member.roles[0].color?.length == 7
                                    ? Color(
                                        int.parse(
                                            '0xff${member.roles[0].color?.replaceAll("#", "")}'),
                                      )
                                    : Dark.foreground.value,
                          ),
                        ),
                      if (contentIndex != 0)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: GradientText(
                            member?.nickname != null
                                ? member!.nickname!.trim()
                                : user.bot == null ||
                                        replyIndex.masquerade?.name == ''
                                    ? user.displayName != null
                                        ? user.displayName!.trim()
                                        : user.name.trim()
                                    : replyIndex.masquerade!.name.trim(),
                            colors: member != null &&
                                    member.roles.isNotEmpty &&
                                    member.roles[0].color != null &&
                                    member.roles[0].color!.contains("gradient")
                                ? Role.getCssGradient(member.roles[0].color!)
                                : ClientController.controller.home.value ||
                                        user.bot != null &&
                                            replyIndex.masquerade?.name != ''
                                    ? [
                                        Dark.foreground.value,
                                        Dark.foreground.value
                                      ]
                                    : member != null &&
                                            member.roles.isNotEmpty &&
                                            member.roles[0].color != '' &&
                                            member.roles[0].color?.length == 7
                                        ? [
                                            Color(
                                              int.parse(
                                                  '0xff${member.roles[0].color?.replaceAll("#", "")}'),
                                            ),
                                            Color(
                                              int.parse(
                                                  '0xff${member.roles[0].color?.replaceAll("#", "")}'),
                                            )
                                          ]
                                        : [
                                            Dark.foreground.value,
                                            Dark.foreground.value
                                          ],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      // BOT OR BRIDGE ICON

                      if (user.bot != null &&
                          replyIndex.masquerade?.name == '' &&
                          contentIndex != 0)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.smart_toy,
                            color: Dark.accent.value,
                            size: 15,
                          ),
                        )
                      else if (user.bot != null &&
                          replyIndex.masquerade?.name != '' &&
                          contentIndex != 0)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.link,
                            color: Dark.accent.value,
                            size: 15,
                          ),
                        ),
                      Flexible(
                        child: InkWell(
                          hoverColor: Dark.accent.value.withOpacity(0.2),
                          onTap: () {
                            // SCROLL TO REPLIED TO MESSAGE

                            itemScrollController.scrollTo(
                                index: contentIndex,
                                duration: const Duration(milliseconds: 100));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (hasAttachment && contentIndex != 0)
                                const Flexible(
                                  child: Icon(
                                    Icons.sticky_note_2_rounded,
                                    size: 15,
                                  ),
                                ),
                              if (hasAttachment && contentIndex != 0)
                                const Flexible(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: CustomMarkdownBody(
                                      data: '*Sent an attachment*',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              if (content != '' && !content.contains("[]"))
                                Expanded(
                                  flex: 4,
                                  child: CustomMarkdownBody(
                                    onTapLink: (text, href, title) {
                                      jumpToReply() {
                                        itemScrollController.jumpTo(
                                            index: contentIndex);
                                      }

                                      jumpToReply();
                                    },
                                    data: contentIndex != 0
                                        ? content.replaceAll("\n", ' ')
                                        : "*Couldn't load message*",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    styleSheet: markdown.styleSheet,
                                    builders: markdown.builders,
                                    extensionSet: markdown.extensionSet,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
