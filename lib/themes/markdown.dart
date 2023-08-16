// ignore_for_file:  , prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:markdown/markdown.dart' as md;
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/themes/ui.dart';

// ignore: camel_case_types
class markdown {
  static md.ExtensionSet extensionSet = md.ExtensionSet(
    md.ExtensionSet.gitHubFlavored.blockSyntaxes,
    [
      md.EmojiSyntax(),
      ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
      CustomEmoteSyntax(),
      // UserMentionSyntax(),
      ChannelMentionSyntax(),
      SpoilerSyntax(),
    ],
  );

  static Map<String, MarkdownElementBuilder> builders = {
    'emote': CustomEmoteBuilder(),
    // 'mentions': UserMentionBuilder(),
    'channels': ChannelMentionBuilder(),
    'spoiler': SpoilerBuilder(hidden: true.obs),
  };

  static MarkdownStyleSheet styleSheet = MarkdownStyleSheet(
    p: TextStyle(
      color: Dark.foreground.value,
      fontSize: ClientController.controller.fontSize.value,
      decorationColor: Dark.foreground.value,
    ),
    h1: TextStyle(
      color: Dark.accent.value,
      fontWeight: FontWeight.bold,
    ),
    h2: TextStyle(
      color: Dark.foreground.value,
      fontWeight: FontWeight.bold,
    ),
    h3: TextStyle(
      color: Dark.foreground.value,
      fontWeight: FontWeight.bold,
    ),
    h4: TextStyle(
      color: Dark.foreground.value,
      fontWeight: FontWeight.bold,
    ),
    h5: TextStyle(
      color: Dark.foreground.value,
      fontWeight: FontWeight.bold,
    ),
    h6: TextStyle(
      color: Dark.foreground.value,
      fontWeight: FontWeight.bold,
    ),
    checkbox: TextStyle(
      color: Dark.accent.value,
    ),
    codeblockDecoration: BoxDecoration(
      color: Dark.background.value,
    ),
    blockquoteDecoration: BoxDecoration(
      color: Dark.secondaryForeground.value.withOpacity(0.2),
      borderRadius: BorderRadius.circular(
        8,
      ),
      gradient: LinearGradient(
        stops: const [0.02, 0.02],
        colors: [Dark.foreground.value.withOpacity(0.2), Dark.background.value],
      ),
    ),
    code: TextStyle(
      color: Dark.foreground.value,
      backgroundColor: Dark.secondaryHeader.value,
    ),
    a: TextStyle(
      color: Dark.accent.value,
      decoration: TextDecoration.underline,
      decorationColor: Dark.accent.value,
      decorationThickness: 2,
      decorationStyle: TextDecorationStyle.solid,
    ),
  );
}

class CustomEmoteSyntax extends md.InlineSyntax {
// The pattern identifies an ulid wrapped between a colon on both sides
  static const String _pattern = r':([a-zA-Z0-9]+):';
  CustomEmoteSyntax() : super(_pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    parser.addNode(
      md.Element.text('emote', match.group(1)!),
    );

    return true;
  }
}

class CustomEmoteBuilder extends MarkdownElementBuilder {
  @override
  Widget visitElementAfter(element, preferredStyle) {
    final String ulid = element.textContent;

    if (element.tag == 'emote') {
      // Replace the emote tag with an image
      // is only inline when selectable test but it can cause errors :/
      return CustomEmote(ulid: ulid);
    } // Return the default implementation for other elements
    return super.visitElementAfter(element, preferredStyle)!;

    // TODO: make emote bigger when no other text

    // if (text == '') {
    //   SelectableText.rich(TextSpan(children: [
    //     WidgetSpan(
    //       child: Image.network(
    //         url,
    //         width: 80,
    //         height: 80,
    //         filterQuality: FilterQuality.medium,
    //       ),
    //     ),
    //   ]));
    // }
  }
}

class CustomEmote extends StatelessWidget {
  const CustomEmote({
    super.key,
    required this.ulid,
  });

  final String ulid;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          WidgetSpan(
            child: InkWell(
              onTap: () {
                Message.showEmote(context, ulid);
              },
              child: Emote(
                ulid: ulid,
                size: 1.5,
                onTap: () {
                  Message.showEmote(context, ulid);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Emote extends StatelessWidget {
  Emote({
    super.key,
    required this.ulid,
    required this.size,
    this.onTap,
  });
  final String url = '$autumn/emojis/';
  final String ulid;
  final double size;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Image.network(
        url + ulid,
        width: ClientController.controller.fontSize.value * size,
        height: ClientController.controller.fontSize.value * size,
        filterQuality: FilterQuality.medium,
        fit: BoxFit.contain,
      ),
    );
  }
}

class UserMentionSyntax extends md.InlineSyntax {
// The pattern identifies an ulid wrapped between <@ and >
  static const String _pattern = '<@([a-zA-Z0-9]+)>';
  UserMentionSyntax() : super(_pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    parser.addNode(
      md.Element.text('mentions', match[1]!),
    );

    return true;
  }
}

class UserMentionBuilder extends MarkdownElementBuilder {
  @override
  Widget visitElementAfter(element, preferredStyle) {
    final String ulid = element.textContent;
    int? userIndex;
    String? url;
    User? user;
    fetchId() async {
      user = await User.fetch(element.textContent);
    }

    if (!ClientController.controller.home.value) {
      userIndex = ServerController.controller.selected.value.users
          .indexWhere((user) => user.id == ulid);
    }
    if (userIndex != -1 &&
        userIndex != null &&
        !ClientController.controller.home.value) {
      user = ServerController.controller.selected.value.users[userIndex];
    } else {
      fetchId();
      if (kDebugMode) print('is in dm');
    }

    url = Client.getAvatar(user!);
    Member? member;
    if (!ClientController.controller.home.value) {
      int memberIndex;
      memberIndex = ServerController.controller.selected.value.members
          .indexWhere((member) => member.userId == ulid);

      if (memberIndex != -1) {
        member =
            ServerController.controller.selected.value.members[memberIndex];
      }
    }

    if (element.tag == 'mentions') {
      // MENTIONS ARE INLINE BUT CRASH IF CLIPPED ITSELF IN REPLIES

      if (user != null) {
        return UserMentionBlock(
          userIndex: userIndex,
          user: user!,
          avatar: user?.avatar,
          member: member?.avatar != '' ? member : null,
          url: url,
        );
      } else {
        return Text("<@${element.textContent}>");
      }
    } // Return the default implementation for other elements
    return super.visitElementAfter(element, preferredStyle)!;
  }
}

class UserMentionBlock extends StatelessWidget {
  const UserMentionBlock({
    super.key,
    required this.user,
    this.avatar,
    this.member,
    this.url,
    this.userIndex,
  });

  final int? userIndex;
  final User user;
  final String? avatar;
  final Member? member;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          WidgetSpan(
            child: InkWell(
              onTap: () {
                User.view(
                  context,
                  userIndex,
                  user,
                  avatar ?? user.avatar,
                  user.status.presence,
                  user.status.text ?? '',
                  user.id,
                  member?.roles ?? [],
                );
              },
              onHover: (color) {},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color: Dark.background.value,
                  padding: EdgeInsets.all(2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: UserIcon(
                          user: user,
                          hasStatus: false,
                          radius: 18,
                          url: url,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 2,
                          right: 4,
                        ),
                        child: Text(
                          member == null ||
                                  member?.avatar == '' ||
                                  member?.nickname == null
                              ? user.displayName?.trim() ?? user.name.trim()
                              : member!.nickname!.trim(),
                          style: TextStyle(
                            fontSize:
                                ClientController.controller.fontSize.value,
                            color: member != null &&
                                    member!.roles.isNotEmpty &&
                                    member?.roles[0].color?.length == 7
                                ? Color(int.parse(
                                    '0xff${member?.roles[0].color?.replaceAll("#", "")}'))
                                : Dark.foreground.value,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                      if (user.bot != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.smart_toy,
                            color: Dark.accent.value,
                            size: 15,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChannelMentionSyntax extends md.InlineSyntax {
// The pattern identifies an ulid wrapped between <# and >
  static const String _pattern = '<#([a-zA-Z0-9]+)>';
  ChannelMentionSyntax() : super(_pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    parser.addNode(
      md.Element.text('channels', match[1]!),
    );
    // if (kDebugMode) print(match[1]);
    return true;
  }
}

class ChannelMentionBuilder extends MarkdownElementBuilder {
  @override
  Widget visitElementAfter(element, preferredStyle) {
    final String ulid = element.textContent;
    dynamic channelIndex;
    String channelName;

    channelIndex = Client.channels.indexWhere((channel) => channel.id == ulid);
    channelName = Client.channels[channelIndex].name!;

    if (element.tag == 'channels') {
      return ChannelMention(
          channelIndex: channelIndex, channelName: channelName);
    } // Return the default implementation for other elements
    return super.visitElementAfter(element, preferredStyle)!;
  }
}

class ChannelMention extends StatelessWidget {
  const ChannelMention({
    super.key,
    required this.channelIndex,
    required this.channelName,
  });

  final int channelIndex;
  final String channelName;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: InkWell(
                onTap: () {
                  final channel = Client.channels[channelIndex];
                  ChannelController.controller.changeChannel(context, channel);
                },
                child: Text(
                  '#$channelName',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: ClientController.controller.fontSize.value,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SpoilerSyntax extends md.InlineSyntax {
// The pattern identifies any text wrapped between !!s
  static const String _pattern = '!!(.+?)!!';
  SpoilerSyntax() : super(_pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    parser.addNode(
      md.Element.text('spoiler', match[1]!),
    );

    return true;
  }
}

class SpoilerBuilder extends MarkdownElementBuilder {
  RxBool hidden = true.obs;
  static final SpoilerBuilder controller =
      Get.put(SpoilerBuilder(hidden: true.obs));
  SpoilerBuilder({
    required this.hidden,
  });
  @override
  Widget visitElementAfter(element, preferredStyle) {
    final String text = element.textContent;
    if (element.tag == 'spoiler') {
      // Replace the spoiler with widget

      // late List<bool> hiddenTestList = [];
      // hiddenList.add(true.obs);
      // if (kDebugMode) print(hiddenList);
      // int index = hiddenList.length;
      // late int index = 0;
      // late bool isHidden = true;
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   index = hiddenList.length;
      //   hiddenList.add(true.obs);
      //   isHidden = hiddenList[index].value;
      // });
      return Obx(() {
        return RichText(
          text: TextSpan(
            children: <InlineSpan>[
              WidgetSpan(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          if (kDebugMode) print(hidden);
                          // hiddenList[index].value = true;
                          if (SpoilerBuilder.controller.hidden.value == false) {
                            SpoilerBuilder.controller.hidden.value = true;
                            // hidden.value = true;
                          }
                        },
                        child: Visibility(
                          visible: !SpoilerBuilder.controller.hidden.value,
                          child: Container(
                            color: Dark.secondaryBackground.value,
                            padding: EdgeInsets.all(2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                        fontSize: ClientController
                                            .controller.fontSize.value),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (kDebugMode) print(hidden);
                          // hiddenList[index].value = false;
                          // // Get the index and number of spans
                          // List<InlineSpan> spans =
                          //     (_key.currentWidget as RichText).text
                          //         as List<TextSpan>;
                          // int index = spans.indexOf(widgetSpan);
                          // int numberOfSpans = spans.length;
                          // // if (kDebugMode) print(
                          // //     'Index: ${hidden.key}, Number of Spans: $numberOfSpans');
                          if (SpoilerBuilder.controller.hidden.value == true) {
                            SpoilerBuilder.controller.hidden.value = false;
                            //   hidden.value = false;
                          }
                        },
                        child: Visibility(
                          visible: SpoilerBuilder.controller.hidden.value,
                          //       SpoilerBuilder.controller.hiddenList[index].value,
                          child: Container(
                            // ignore: use_full_hex_values_for_flutter_colors
                            color: Color(0xfff151515),
                            padding: EdgeInsets.all(2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // INVISIBLE TEXT FOR SIZING
                                Flexible(
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      fontSize: ClientController
                                          .controller.fontSize.value,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
      });
    } // Return the default implementation for other elements
    return super.visitElementAfter(element, preferredStyle)!;
  }
}
