// ignore_for_file:

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/models/channel/channels.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/themes/ui.dart';

// ignore: must_be_immutable
class ServerChannels extends StatelessWidget {
  ServerChannels({
    super.key,
  });
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        padding: Client.isDesktop ? null : const EdgeInsets.only(bottom: 70),
        controller: _controller,
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ServerController
                  .controller.selected.value.uncategorizedChannels!.length,
              itemBuilder: (context, index) {
                String? channelIcon;
                if (channelIcon != '') {
                  channelIcon = ServerController.controller.selected.value
                      .uncategorizedChannels?[index].icon!;
                }
                return ChannelTile(
                  icon: channelIcon != ''
                      ? SizedBox(
                          height: 25,
                          width: 25,
                          child: Image.network(
                            '$autumn/icons/$channelIcon?',
                            filterQuality: FilterQuality.medium,
                          ),
                        )
                      : Icon(
                          ServerController.controller.selected.value
                                      .uncategorizedChannels![index].type ==
                                  'VoiceChannel'
                              ? Icons.mic
                              : Icons.numbers_rounded,
                          color: Dark.foreground.value,
                        ),
                  channel: ServerController
                      .controller.selected.value.uncategorizedChannels![index],
                  onTap: () {
                    ChannelController.controller.changeChannel(
                        context,
                        ServerController.controller.selected.value
                            .uncategorizedChannels![index]);
                  },
                );
              }),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                ServerController.controller.selected.value.categories.length,
            itemBuilder: (context, index) {
              final categories =
                  ServerController.controller.selected.value.categories[index];
              final channelsId = ServerController
                  .controller.selected.value.categories[index].channels;
              {
                return ExpansionTile(
                  // controlAffinity: ListTileControlAffinity.leading,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 8),
                  initiallyExpanded: true,
                  textColor: Dark.accent.value,
                  iconColor: Dark.accent.value,
                  collapsedTextColor: Dark.secondaryForeground.value,
                  collapsedIconColor: Dark.secondaryForeground.value,
                  title: Text(
                    categories.title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  children: [
                    // CHANNELS

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.channels.length,
                      itemBuilder: (context, index) {
                        int channelIndex = ServerController
                            .controller.selected.value.categorizedChannels!
                            .indexWhere(
                                (channel) => channel.id == channelsId[index]);
                        String channelsIcon = '';
                        Channel channel = Channel(
                          id: '',
                          name: '',
                          type: '',
                          users: <User>[].obs,
                          members: <Member>[].obs,
                          messages: <Message>[].obs,
                          isUnread: false.obs,
                          recipients: <User>[].obs,
                        );
                        if (channelIndex != -1) {
                          channel = ServerController.controller.selected.value
                              .categorizedChannels![channelIndex];

                          channelsIcon = ServerController.controller.selected
                              .value.categorizedChannels![channelIndex].icon!;
                        }
                        if (channelIndex != -1) {
                          return ChannelTile(
                            icon: channelsIcon != ''
                                ? SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Image.network(
                                      '$autumn/icons/$channelsIcon',
                                      filterQuality: FilterQuality.medium,
                                    ),
                                  )
                                : Icon(
                                    ServerController
                                                .controller
                                                .selected
                                                .value
                                                .categorizedChannels![
                                                    channelIndex]
                                                .type ==
                                            'VoiceChannel'
                                        ? Icons.mic
                                        : Icons.numbers_rounded,
                                  ),
                            channel: channel,
                            onTap: () {
                              ChannelController.controller
                                  .changeChannel(context, channel);
                              if (kDebugMode) print('[channel] change');
                              ClientController.controller.home.value = false;
                              if (kDebugMode) {
                                print(ClientController.controller.home.value);
                              }
                            },
                          );
                        } else {
                          const SizedBox();
                        }
                        return null;
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class ChannelTile extends StatelessWidget {
  const ChannelTile({
    super.key,
    required this.icon,
    required this.onTap,
    required this.channel,
  });
  final Widget icon;
  final VoidCallback onTap;
  final Channel channel;
  @override
  Widget build(BuildContext context) {
    int serverIndex = ServerController.controller.serversList
        .indexWhere((server) => server.id == channel.server);
    int result = 2;
    bool unread = false;
    int channelIndex = -1;
    if (serverIndex != -1) {
      channelIndex = ServerController
          .controller.serversList[serverIndex].channels
          .indexWhere((c) => c.id == channel.id);
    }
    RxString lastId = ''.obs;
    RxString lastMessage = ''.obs;
    if (channelIndex != -1 &&
        serverIndex != -1 &&
        channel.unreads[0].lastId.value != '') {
      lastId = channel.unreads[0].lastId;
      lastMessage = channel.lastMessage.obs;
    }
    RxBool isUnread() {
      if (lastId.value != '' && lastMessage.value != '') {
        result = lastId.value.compareTo(lastMessage.value);
      }
      if (result == 0) {
        unread = true;
        return unread.obs;
      } else {
        return false.obs;
      }
    }

    isUnread();
    if (channel.name != null) {
      return Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 8,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              type: MaterialType.transparency,
              child: ListTile(
                hoverColor: Dark.primaryBackground.value,
                selected: serverIndex != -1 && channelIndex != -1
                    ? ChannelController.controller.selected.value.id ==
                        channel.id
                    : false,
                selectedColor: Dark.accent.value,
                selectedTileColor: Dark.primaryBackground.value,
                tileColor: Dark.background.value,
                iconColor: isUnread().value
                    ? Dark.foreground.value
                    : Dark.secondaryForeground.value,
                textColor: Dark.secondaryForeground.value,
                horizontalTitleGap: 0,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                leading: icon,
                title: Text(
                  channel.name!,
                  style: TextStyle(
                      color: isUnread().value
                          ? Dark.secondaryForeground.value.withOpacity(0.5)
                          : Dark.foreground.value),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: !isUnread().value
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CircleAvatar(
                          backgroundColor: Dark.foreground.value,
                          radius: 4,
                        ),
                      )
                    : null,
                onTap: onTap,
                // onLongPress: () {
                //   // TODO: CONTEXT MENU
                // },
              ),
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
