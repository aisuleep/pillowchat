// ignore_for_file:

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/widgets/message/message_box.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/pages/server/chat_page.dart';
import 'package:pillowchat/themes/ui.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key, required this.leading, this.trailing});
  final IconData leading;
  final IconData? trailing;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(15)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 5),
            child: Container(
              height: 50,
              color: Dark.background.value.withOpacity(0.5),
              child: Material(
                type: MaterialType.transparency,
                child: ListTile(
                  minLeadingWidth: 0,
                  horizontalTitleGap: 8,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  tileColor: Dark.background.value.withOpacity(0.7),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        leading,
                      ),
                      onPressed: () {
                        Panels.slideRight(context);
                      },
                    ),
                  ),
                  title: Obx(
                    () => Row(
                      children: [
                        if (ChannelController.controller.selected.value.icon ==
                                '' &&
                            ServerController.controller.homeIndex.value != -3)
                          Icon(
                            ChannelController.controller.selected.value.type ==
                                    "VoiceChannel"
                                ? Icons.mic
                                : ChannelController
                                            .controller.selected.value.type ==
                                        "Group"
                                    ? Icons.group
                                    : ChannelController.controller.selected
                                                .value.type ==
                                            "DirectMessage"
                                        ? Icons.alternate_email
                                        : ChannelController.controller.selected
                                                    .value.type ==
                                                "SavedMessages"
                                            ? Icons.calendar_today
                                            : Icons.numbers,
                          )
                        else if (ServerController.controller.homeIndex.value !=
                            -3)
                          Image.network(
                            "$autumn/icons/${ChannelController.controller.selected.value.icon}",
                            height: 20,
                            width: 20,
                            filterQuality: FilterQuality.medium,
                          ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              ServerController.controller.homeIndex.value !=
                                          -3 ||
                                      !ClientController.controller.home.value
                                  ? ChannelController
                                              .controller.selected.value.name !=
                                          null
                                      ? ChannelController
                                          .controller.selected.value.name!
                                      : ChannelController.controller.selected
                                                  .value.type ==
                                              "SavedMessages"
                                          ? "Saved Notes"
                                          : "Friend"
                                  : "Home",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize:
                                    ClientController.controller.fontSize.value,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: trailing != null
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(
                                () => Visibility(
                                  visible: ChannelController
                                          .controller.selected.value.type !=
                                      "VoiceChannel",
                                  child: IconButton(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    icon: Icon(
                                      ChannelController
                                                  .controller.unlocked.value ==
                                              true
                                          ? Icons.lock_open
                                          : Icons.lock,
                                      color: ChannelController
                                                  .controller.unlocked.value ==
                                              true
                                          ? Dark.secondaryForeground.value
                                          : Dark.accent.value,
                                    ),
                                    onPressed: () {
                                      MessageBox.unlocked = !unlocked;
                                      ChannelController.controller
                                          .toggleLock(unlocked);
                                    },
                                  ),
                                ),
                              ),
                              // VIEW MEMBERS BUTTON

                              Visibility(
                                visible: ChannelController
                                        .controller.selected.value.type !=
                                    'SavedMessages',
                                child: IconButton(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  icon: const Icon(
                                    Icons.people,
                                  ),
                                  onPressed: () {
                                    if (Client.isMobile) {
                                      Panels.slideLeft(context);
                                    } else {
                                      ChannelController
                                              .controller.showMembers.value =
                                          !ChannelController
                                              .controller.showMembers.value;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
