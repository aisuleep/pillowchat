// ignore_for_file: avoid_print

import 'dart:io';

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

// get channels => Client.channels;

// ignore: must_be_immutable
class ServerChannels extends StatelessWidget {
  ServerChannels({
    super.key,
  });
  List<Channel> categorizedChannels = [];
  List<Channel> uncategorizedChannels = [];
  List<int> catChannelIndices = [];
  List<int> uncatChannelIndices = [];
  int catChannelIndex = -1;
  int uncatChannelIndex = -1;
  int channelsLength =
      ServerController.controller.selected.value.channels.length;
  List<int> channelIndices = [];

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < channelsLength; i++) {
      channelIndices.add(i);
    }
    // print(channelIndices);
    // STORE ALL CHANNELS INSIDE A CATEGORY

    for (var i = 0;
        i < ServerController.controller.selected.value.channels.length;
        i++) {
      for (var cat in ServerController.controller.selected.value.categories) {
        for (var channel in cat.channelId) {
          if (channel ==
              ServerController.controller.selected.value.channels[i].id) {
            catChannelIndex = i;
            catChannelIndices.add(i);
            // print('catChanIndices: $catChannelIndices');
          }
        }
        for (var index in channelIndices) {
          bool shouldAdd = true;
          if (catChannelIndices.contains(index)) {
            shouldAdd = false;
            // print(index);
            break;
          }
          if (shouldAdd) {
            uncatChannelIndices.add(index);
            // print('uncatChanIndices: $uncatChannelIndices');
          }
        }
      }
    }
    if (catChannelIndex != -1) {
      categorizedChannels.add(
          ServerController.controller.selected.value.channels[catChannelIndex]);
    }

    // print(categorizedChannels.length);
    for (var v = 0; v < categorizedChannels.length; v++) {
      // todo: for some reason duplicates one of the channels

      print('catted channels: ${categorizedChannels[v].name}');
    }

    for (var i = 0;
        i < ServerController.controller.selected.value.channels.length;
        i++) {
      for (var channel in categorizedChannels) {
        // if (channel.id != ServerController.controller.selected.value.channels[i].id) {
        // uncatChannelIndex = categorizedChannels.indexWhere((element) =>
        // element.id !=
        // );
        // }
        if (uncatChannelIndex != -1) {
          uncategorizedChannels.add(channel);
          // }// STORE ALL CHANNELS NOT INSIDE A CATEGORY

          // if (uncatChannelIndex != -1) {
          uncategorizedChannels.add(channel);
          // print('non catted channels: ');
          // ignore: unused_local_variable
          for (var channel in uncategorizedChannels) {
            // print(channel.name);
          }
        }
        // print(uncatChannelIndex);
      }
    }

    return Container(
      padding: !Platform.isAndroid && !Platform.isIOS
          ? null
          : const EdgeInsets.only(bottom: 70),
      child: Column(
        children: [
          if (uncategorizedChannels.isNotEmpty)
            Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: uncategorizedChannels.length,
                  itemBuilder: (context, index) {
                    int nonMatchIndex = -1;
                    List<Channel> cats = [];
                    String? channelIcon = uncategorizedChannels[index].icon;
                    for (var channel in categorizedChannels) {
                      nonMatchIndex = uncategorizedChannels
                          .indexWhere((element) => element.id == channel.id);

                      cats.add(uncategorizedChannels[nonMatchIndex]);
                    }
                    // if (uncategorizedChannels[index] !=
                    //     uncategorizedChannels[nonMatchIndex]) {
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
                              uncategorizedChannels[index].type ==
                                      'VoiceChannel'
                                  ? Icons.mic
                                  : Icons.numbers_rounded,
                              color: Dark.foreground.value,
                            ),
                      channel: uncategorizedChannels[index],
                      onTap: () {
                        ChannelController.controller.changeChannel(
                            context, uncategorizedChannels[index]);
                      },
                    );
                    // } else {
                    //   Container();
                    // }
                  }),
            ),
          Obx(
            () => Expanded(
              child: ListView.builder(
                itemCount: ServerController
                    .controller.selected.value.categories.length,
                itemBuilder: (context, index) {
                  final categories = ServerController
                      .controller.selected.value.categories[index];
                  final channelsId = ServerController
                      .controller.selected.value.categories[index].channelId;
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
                          itemCount: categories.channelId.length,
                          itemBuilder: (context, index) {
                            final channelIndex = Client.channels.indexWhere(
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
                            );
                            if (channelIndex != -1) {
                              channel = Client.channels[channelIndex];

                              channelsIcon =
                                  Client.channels[channelIndex].icon!;
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
                                        Client.channels[channelIndex].type ==
                                                'VoiceChannel'
                                            ? Icons.mic
                                            : Icons.numbers_rounded,
                                      ),
                                channel: channel,
                                onTap: () {
                                  ChannelController.controller
                                      .changeChannel(context, channel);
                                  print('[channel] change');
                                  ClientController.controller.home.value =
                                      false;
                                  print(ClientController.controller.home.value);
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
            ),
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
    int serverIndex;
    serverIndex = ServerController.controller.serversList
        .indexWhere((server) => server.id == channel.server);
    int result = 2;
    bool unread = false;
    int channelIndex = ServerController
        .controller.serversList[serverIndex].channels
        .indexWhere((c) => c.id == channel.id);
    RxString lastId = ''.obs;
    RxString lastMessage = ''.obs;
    if (channelIndex != -1 &&
        ServerController.controller.serversList[serverIndex]
                .channels[channelIndex].unreads[0].lastId.value !=
            '') {
      lastId = ServerController.controller.serversList[serverIndex]
          .channels[channelIndex].unreads[0].lastId;
      lastMessage = ServerController.controller.serversList[serverIndex]
          .channels[channelIndex].lastMessage.obs;
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
              selected: ChannelController.controller.selected.value.id ==
                  ServerController.controller.serversList[serverIndex]
                      .channels[channelIndex].id,
              // selected: isUnread().value,
              // selectedColor: Dark.secondaryForeground.value.withOpacity(0.5),
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
                ServerController.controller.serversList[serverIndex]
                    .channels[channelIndex].name!,
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
}
