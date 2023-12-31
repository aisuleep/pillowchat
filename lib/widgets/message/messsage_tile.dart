import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/widgets/message/attachments.dart';
// import 'package:pillowchat/components/message/attachments.dart';
import 'package:pillowchat/widgets/message/embeds/index.dart';
import 'package:pillowchat/widgets/reactions/reactor_tile.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/models/message/parts/reactions.dart';
import 'package:pillowchat/models/server.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/themes/markdown.dart';
import 'package:pillowchat/themes/ui.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pillowchat/models/message/parts/embeds.dart';

// ignore: must_be_immutable
class MessageTile extends StatelessWidget {
  MessageTile({
    super.key,
    required this.author,
    required this.sentDay,
    required this.time,
    required this.previousAuthor,
    required this.currentDay,
    required this.yesterDay,
    this.messageIndex,
    this.reactedTo,
    required this.index,
    required this.userIndex,
    required this.user,
    this.content,
    this.member,
    this.reactions,
    // required this.fiveMinutes,
    // required this.fromSentTime,
  });
  final dynamic messageIndex;
  final int index;
  final int userIndex;
  final bool? reactedTo;
  final String author;
  final String previousAuthor;
  final String sentDay;
  final String currentDay;
  final String yesterDay;
  final String time;
  final User user;
  final Member? member;
  final String? content;
  RxList<Reaction>? reactions;
  // final bool fromSentTime;
  // final bool fiveMinutes;

  @override
  Widget build(BuildContext context) {
    // LIST OF EMOTE REACTIONS ON MESSAGE
    if (messageIndex.reactions != null) {
      // emotes = messageIndex.reactions.reactionMap.keys.map((l) => l).toList();
    }

    if (author == '00000000000000000000000000') {
      return const ListTile(
          minLeadingWidth: 4,
          contentPadding: EdgeInsets.only(left: 16),
          leading: Icon(
            Icons.task_alt,
            size: 24,
          ),
          title: Text('todo: make system message'));
    } else {
      // GET USER AVATAR
      String url = ReactorTile.getUrl(true, user,
          serverMember: member, messageIndex: messageIndex);
      return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            if (previousAuthor != author && messageIndex?.repliesId == null)
              const SizedBox(
                height: 10,
                width: 2,
              ),
            Container(
              // IF MESSAGE MENTIONS CLIENT USER

              color: messageIndex.mentions?.length != 0 &&
                      messageIndex.mentions!.any((id) =>
                          id ==
                          ClientController.controller.selectedUser.value.id)
                  ? Dark.accent.value.withOpacity(0.3)
                  : Colors.transparent,
              child: InkWell(
                onLongPress: () {
                  Message.openMenu(
                    messageIndex.id,
                    content,
                    context,
                    author,
                    messageIndex.edited,
                    messageIndex.reactions,
                    reactedTo,
                    reactions,
                    messageIndex,
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (previousAuthor != author ||
                        messageIndex.repliesId != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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
                          onLongPress: () {
                            if (member != null) {
                              if (member!.roles.isNotEmpty) {
                                if (kDebugMode) print(member?.roles[0].color);
                              }
                            }

                            Picture.view(
                              context,
                              url,
                              user: user,
                              'message avatar',
                            );
                          },
                          child: UserIcon(
                            url: url.obs,
                            user: user,
                            hasStatus: false,
                            radius: 36,
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          height: 20,
                          width: 36,
                          child: messageIndex.edited != '' &&
                                  previousAuthor == author
                              ? const Icon(
                                  Icons.edit,
                                  size: 14,
                                )
                              : null,
                        ),
                      ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (previousAuthor != author ||
                                  messageIndex.repliesId != null
                              //  ||  fromSentTime && fiveMinutes
                              )
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // AUTHOR

                                Flexible(
                                  child: InkWell(
                                    onTap: () {
                                      User.view(
                                        context,
                                        userIndex,
                                        user,
                                        user.avatar?.value.id,
                                        user.status.presence,
                                        user.status.text!,
                                        user.id,
                                        member!.roles,
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: Obx(
                                              () => GradientText(
                                                member?.nickname?.value != ''
                                                    ? member?.nickname?.value
                                                        .trim()
                                                    : user.bot == null ||
                                                            messageIndex
                                                                    .masquerade
                                                                    .name ==
                                                                ''
                                                        ? user.displayName
                                                                ?.trim() ??
                                                            user.name.trim()
                                                        : messageIndex
                                                            .masquerade.name
                                                            .trim(),
                                                colors: member != null &&
                                                        member!
                                                            .roles.isNotEmpty &&
                                                        member!.roles[0].color !=
                                                            null &&
                                                        member!.roles[0].color!
                                                            .contains(
                                                                "gradient")
                                                    ? Role.getCssGradient(
                                                        member!.roles[0].color!)
                                                    : ClientController
                                                                .controller
                                                                .home
                                                                .value ||
                                                            user.bot != null &&
                                                                messageIndex
                                                                        .masquerade
                                                                        .name !=
                                                                    '' &&
                                                                messageIndex
                                                                        .masquerade
                                                                        .color ==
                                                                    null ||
                                                            member == null ||
                                                            member != null &&
                                                                member!.roles
                                                                    .isEmpty
                                                        ? [
                                                            Dark.foreground
                                                                .value,
                                                            Dark.foreground
                                                                .value
                                                          ]
                                                        : member != null &&
                                                                member!.roles.isNotEmpty &&
                                                                member?.roles[0].color != null &&
                                                                member?.roles[0].color?.length == 7 &&
                                                                messageIndex.masquerade.name == ''
                                                            ? [
                                                                Color(
                                                                  int.parse(
                                                                      '0xff${member?.roles[0].color?.replaceAll("#", "")}'),
                                                                ),
                                                                Color(
                                                                  int.parse(
                                                                      '0xff${member?.roles[0].color?.replaceAll("#", "")}'),
                                                                )
                                                              ]
                                                            : messageIndex.masquerade.color != null && messageIndex.masquerade.color.length == 7
                                                                ? [
                                                                    Color(int.parse(
                                                                        '0xff${messageIndex.masquerade.color?.replaceAll("#", "")}')),
                                                                    Color(int.parse(
                                                                        '0xff${messageIndex.masquerade.color?.replaceAll("#", "")}'))
                                                                  ]
                                                                : [
                                                                    Dark.foreground
                                                                        .value,
                                                                    Dark.foreground
                                                                        .value,
                                                                  ],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (user.bot != null)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: Icon(
                                              messageIndex.masquerade.name == ''
                                                  ? Icons.smart_toy
                                                  : Icons.link,
                                              size: 15,
                                              color: Dark.accent.value,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                // TIME
                                Text(
                                  currentDay == sentDay
                                      ? 'Today at $time'
                                      : yesterDay == sentDay
                                          ? 'Yesterday at $time'
                                          : '$sentDay $time',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Dark.secondaryForeground.value,
                                  ),
                                ),
                                if (messageIndex.edited != '')
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: Icon(
                                      Icons.edit,
                                      size: 14,
                                    ),
                                  ),
                              ],
                            ),
                          MessageContent(
                            content: content,
                            messageIndex: messageIndex,
                            index: index,
                            user: user,
                            member: member,
                            previousAuthor: previousAuthor,
                            author: author,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

class MessageContent extends StatelessWidget {
  const MessageContent({
    super.key,
    required this.messageIndex,
    required this.index,
    required this.user,
    this.member,
    required this.previousAuthor,
    required this.author,
    this.content,
  });
  final String? content;
  final dynamic messageIndex;
  final int index;
  final User user;
  final Member? member;
  final String previousAuthor;
  final String author;
  @override
  Widget build(BuildContext context) {
    if (messageIndex.attachments.isNotEmpty) {}
    return Padding(
      padding: EdgeInsets.only(
        bottom:
            previousAuthor != author || messageIndex.repliesId != null ? 8 : 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkdownBody(
            data: content != null
                ? content!.contains('https://gifbox.me/view/')
                    ? ''
                    : content!
                : '',
            softLineBreak: true,
            selectable: true,
            extensionSet: markdown.extensionSet,
            builders: markdown.builders,
            styleSheet: markdown.styleSheet,
            onTapLink: (text, href, title) {
              // ignore: no_leading_underscores_for_local_identifiers
              Future<void> _launchUrl() async {
                if (!await launchUrl(Uri.parse(href!))) {
                  throw Exception('Could not launch $href');
                }
              }

              _launchUrl();
              // if (kDebugMode) print(href);
            },
          ),
          // IF MESSAGE HAS ATTATCHMENTS

          // IMAGE & VIDEO ATTACHMENTS
          if (messageIndex.attachments?.length != 0)
            for (int e = 0; e < messageIndex.attachments!.length; e++)
              if (messageIndex.attachments?[e].type == 'Image')
                Attachments(messageIndex, e),
          // TODO: AUDIO/FILE/VIDEO ATTACHMENTS

          // FILE ATTACHMENTS
          if (messageIndex.attachments?.length != 0)
            for (int e = 0; e < messageIndex.attachments!.length; e++)
              if (messageIndex.attachments?[e].type != 'Image')
                const Text('**todo: make file/audio/video attachments**'),

          //       FileAttachments(
          //         messageIndex,
          //         messageIndex.attachments?[e].url,
          //       ),
          // IF MESSAGE HAS EMBEDS

          // TEXT EMBEDS
          if (messageIndex.embeds?.length != 0)
            for (int e = 0; e < messageIndex.embeds!.length; e++)
              if (messageIndex.embeds?[e].type == 'Text')
                TextEmbeds(messageIndex, index),

          // LINK EMBEDS
          if (messageIndex.embeds?.length != 0)
            for (int e = 0; e < messageIndex.embeds!.length; e++)
              if (messageIndex.embeds?[e].description != null &&
                  messageIndex.embeds?[e].color == null &&
                  messageIndex.embeds?[e].type != 'Website')
                LinkEmbeds(messageIndex, e, index),

          // IMAGE EMBED
          if (messageIndex.embeds?.length != 0)
            for (int e = 0; e < messageIndex.embeds!.length; e++)
              if (messageIndex.embeds?[e].type == 'Image')
                ImageEmbeds(messageIndex, index),

          // WEBSITE EMBEDS
          if (messageIndex.embeds?.length != 0)
            for (int e = 0; e < messageIndex.embeds!.length; e++)
              if (messageIndex.embeds?[e].type == 'Website')
                WebsiteEmbeds(messageIndex, e, index),

          // IF MESSAGE HAS REACTIONS
          if (messageIndex.reactions.length != 0)

            // REACTION LIST BUILDER

            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(
                children: List.generate(
                  messageIndex.reactions.length + 1,
                  (index) {
                    if (index == messageIndex.reactions.length) {
                      // ADD EMOTE BUTTON

                      return Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Dark.secondaryHeader.value,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          height: 28,
                          width: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    Message.showEmoteMenu(
                                      context,
                                      messageIndex.id,
                                      false,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    size: 24,
                                    color: Dark.accent.value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      // REACTIONS
                      String emote = messageIndex.reactions[index].emote;

                      List<String> reactors =
                          messageIndex.reactions[index].reactors;

                      // REACTION COUNT

                      int reactCount =
                          messageIndex.reactions[index].reactors.length;

                      // IF CLIENT IS ONE OF REACTORS AT REACTION INDEX

                      RxBool reactedTo = false.obs;
                      reactedTo.value = messageIndex.reactions[index].reactors
                          .any((reactor) =>
                              reactor ==
                              ClientController
                                  .controller.selectedUser.value.id);

                      // CONTROLLERS

                      final ItemScrollController itemScrollController =
                          ItemScrollController();
                      final ItemPositionsListener itemPositionsListener =
                          ItemPositionsListener.create();
                      final ScrollOffsetListener scrollOffsetListener =
                          ScrollOffsetListener.create();
                      return Obx(
                        () => InkWell(
                          onTap: () {
                            // if (kDebugMode) print('$reactedTo reacted');
                            if (!reactedTo.value) {
                              Reaction.add(
                                ChannelController.controller.selected.value.id,
                                messageIndex.id!,
                                emote,
                              );
                              reactedTo.value = true;

                              if (Client.isMobile) {
                                Navigator.pop(context);
                              }
                              if (kDebugMode) print('$reactedTo reacted');
                            } else if (reactedTo.value) {
                              Reaction.remove(
                                ChannelController.controller.selected.value.id,
                                messageIndex.id!,
                                emote,
                              );
                              reactedTo.value = false;
                            }
                          },
                          onSecondaryTap: () {
                            Reaction.showInfo(
                              context,
                              reactors.obs,
                              messageIndex.reactions!,
                              messageIndex,
                              index.obs,
                              itemScrollController,
                              itemPositionsListener,
                              scrollOffsetListener,
                            );
                          },
                          onLongPress: () {
                            Reaction.showInfo(
                              context,
                              reactors.obs,
                              messageIndex.reactions!,
                              messageIndex,
                              index.obs,
                              itemScrollController,
                              itemPositionsListener,
                              scrollOffsetListener,
                            );
                            // itemScrollController.scrollTo(
                            //   index: index,
                            //   duration: const Duration(milliseconds: 300),
                            // );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: reactedTo.value
                                    ? Dark.accent.value.withOpacity(0.5)
                                    : Dark.secondaryHeader.value,
                                border: Border.all(
                                    color: reactedTo.value
                                        ? Dark.accent.value
                                        : Dark.primaryBackground.value),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (emote.length == 26)
                                    Emote(
                                      ulid: emote,
                                      size: 1.3,
                                    )
                                  else
                                    Text(
                                      emote,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text(
                                      reactCount.toString(),
                                      style: TextStyle(
                                          fontSize: ClientController
                                                  .controller.fontSize.value *
                                              0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
