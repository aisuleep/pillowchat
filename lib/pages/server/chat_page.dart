// ignore_for_file:

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/components/headers/chat_header.dart';
import 'package:pillowchat/components/message/message_box.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/pages/server/members_page.dart';
import 'package:pillowchat/util/message_build.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/pages/server/voice_chat.dart';
import 'package:pillowchat/themes/ui.dart';

get unlocked => MessageBox.unlocked;
get editing => MessageBox.editing;

class ChatPage extends StatelessWidget {
  const ChatPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => SafeArea(
              child: ChannelController.controller.selected.value.type !=
                      'VoiceChannel'
                  ? Row(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              // MESSAGES

                              Container(
                                  padding: const EdgeInsets.only(
                                    bottom: 80,
                                  ),
                                  child: MessageBuild()),

                              // JUMP TO RECENT MESSAGES

                              // Visibility(
                              //   visible: MessageBuild.indices
                              //       .any((index) => index >= 15),
                              //   child: Positioned(
                              //       right: 0,
                              //       bottom: 0,
                              //       child: ClipRRect(
                              //         borderRadius: BorderRadius.circular(
                              //             IconBorder.radius.value),
                              //         child: Container(
                              //           padding: const EdgeInsets.all(16),
                              //           color: Dark.foreground.value,
                              //           child: IconButton(
                              //             onPressed: () {
                              //               // MessageBuild.itemController.scrollTo(
                              //               //     index: 0,
                              //               //     duration: const Duration(
                              //               //         milliseconds: 300));
                              //             },
                              //             icon: Icon(
                              //               Icons.arrow_downward,
                              //               color:
                              //                   Dark.primaryBackground.value,
                              //             ),
                              //           ),
                              //         ),
                              //       )),
                              // ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (ServerController.controller.selected
                                          .value.channels.isNotEmpty)
                                        Obx(() {
                                          final int channelIndex =
                                              ServerController.controller
                                                  .selected.value.channels
                                                  .indexWhere((channel) =>
                                                      channel.id ==
                                                      ChannelController
                                                          .controller
                                                          .selected
                                                          .value
                                                          .id);
                                          RxList<User>? users;
                                          if (channelIndex != -1) {
                                            users = ServerController
                                                .controller
                                                .selected
                                                .value
                                                .channels[channelIndex]
                                                .typingList;
                                          }
                                          return Visibility(
                                            visible: ChannelController
                                                .controller.typing.value,
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                height: 30,
                                                color: Dark
                                                    .secondaryBackground.value,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8),
                                                      child: Wrap(
                                                        children: List.generate(
                                                            ServerController
                                                                        .controller
                                                                        .selected
                                                                        .value
                                                                        .channels[
                                                                            channelIndex]
                                                                        .typingList
                                                                        .length <=
                                                                    4
                                                                ? ServerController
                                                                    .controller
                                                                    .selected
                                                                    .value
                                                                    .channels[
                                                                        channelIndex]
                                                                    .typingList
                                                                    .length
                                                                : 0, (index) {
                                                          if (index != -1) {
                                                            return UserIcon(
                                                              user:
                                                                  users![index],
                                                              radius: 14,
                                                              hasStatus: false,
                                                            );
                                                          } else {
                                                            return const SizedBox();
                                                          }
                                                        }),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        ServerController
                                                                    .controller
                                                                    .selected
                                                                    .value
                                                                    .channels[
                                                                        channelIndex]
                                                                    .typingList
                                                                    .length ==
                                                                1
                                                            ? '${users?[0].displayName?.trim() ?? users?[0].name.trim()} is typing...'
                                                            : ServerController
                                                                        .controller
                                                                        .selected
                                                                        .value
                                                                        .channels[
                                                                            channelIndex]
                                                                        .typingList
                                                                        .length ==
                                                                    2
                                                                ? '${users?[0].displayName?.trim() ?? users?[0].name.trim()} and ${users?[1].displayName?.trim() ?? users?[1].name.trim()} are typing...'
                                                                : ServerController
                                                                            .controller
                                                                            .selected
                                                                            .value
                                                                            .channels[
                                                                                channelIndex]
                                                                            .typingList
                                                                            .length ==
                                                                        3
                                                                    ? '${users?[0].displayName?.trim() ?? users?[0].name.trim()}, ${users?[1].displayName?.trim() ?? users?[1].name.trim()}, and ${users?[2].displayName?.trim() ?? users?[0].name.trim()} are typing...'
                                                                    : ServerController.controller.selected.value.channels[channelIndex].typingList.length ==
                                                                            4
                                                                        ? '${users?[0].displayName?.trim() ?? users?[0].name.trim()}, ${users?[1].displayName?.trim() ?? users?[1].name.trim()},  ${users?[2].displayName?.trim() ?? users?[0].name.trim()}, and ${users?[3].displayName?.trim() ?? users?[0].name.trim()} are typing...'
                                                                        : ServerController.controller.selected.value.channels[channelIndex].typingList.length >=
                                                                                5
                                                                            ? 'Several people are typing...'
                                                                            : '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      // Obx(
                                      //   () =>
                                      Visibility(
                                        visible: false,
                                        // MessageBuild.scrollIndex > 5,
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Material(
                                            type: MaterialType.transparency,
                                            child: ListTile(
                                              dense: true,
                                              visualDensity:
                                                  const VisualDensity(
                                                      vertical: -4),
                                              minLeadingWidth: 0,
                                              horizontalTitleGap: 4,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              tileColor: Dark
                                                  .secondaryForeground.value,
                                              title: const Text(
                                                  'Viewing old messages'),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // ),
                                      if (ChannelController
                                              .controller.selected.value.type !=
                                          'VoiceChannel')
                                        const MessageBox(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible:
                              ChannelController.controller.showMembers.value &&
                                  Client.isDesktop,
                          child: const SizedBox(
                            width: 250,
                            child: MembersPage(),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Flexible(child: VoiceChat()),
                        Visibility(
                          visible:
                              ChannelController.controller.showMembers.value &&
                                  Client.isDesktop,
                          child: const SizedBox(
                            width: 250,
                            child: MembersPage(),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SafeArea(
            child: ChatHeader(
              leading: Icons.menu,
              trailing: Icons.lock,
            ),
          ),
        ],
      ),
    );
  }
}
