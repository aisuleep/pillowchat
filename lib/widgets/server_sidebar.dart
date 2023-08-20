import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/custom/hole_puncher.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/models/server.dart';
import 'package:pillowchat/themes/ui.dart';

class ServerSidebar extends StatelessWidget {
  const ServerSidebar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      padding: Client.isMobile ? const EdgeInsets.only(bottom: 64) : null,
      child: Column(
        children: [
          // DIVIDER

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8),
          //   child: Divider(
          //     thickness: 3,
          //     color: Dark.secondaryForeground.value.withOpacity(0.5),
          //   ),
          // ),

          // SERVER AND OPTION ICONS

          Obx(
            () => Expanded(
              child: ListView.builder(
                itemCount: ServerController.controller.serversList.length + 1,
                itemBuilder: (context, index) {
                  if (index == ServerController.controller.serversList.length) {
                    // ignore:
                    return Center(
                      child: OptionIconButton(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        onPressed: () {},
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: Dark.accent.value,
                        ),
                      ),
                    );
                  } else {
                    final server =
                        ServerController.controller.serversList[index];

                    RxList<bool>? isHovered = List<bool>.generate(
                        ServerController.controller.serversList.length,
                        (index) => false).obs;

                    return ServerIcon(
                      server: server,
                      isHovered: isHovered,
                      index: index,
                    );
                  }
                },
              ),
            ),
          ),
          if (Client.isDesktop)
            Center(
              child: OptionIconButton(
                padding: const EdgeInsets.symmetric(vertical: 8),
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/settings');
                },
                child: Icon(
                  Icons.settings,
                  size: 20,
                  color: Dark.accent.value,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ServerIcon extends StatelessWidget {
  const ServerIcon({
    super.key,
    required this.server,
    required this.isHovered,
    required this.index,
  });

  final Server server;
  final RxList<bool>? isHovered;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        alignment: Alignment.center,
        children: [
          Visibility(
            visible: server == ServerController.controller.selected.value &&
                !ClientController.controller.home.value,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                IconBorder.radius.toDouble(),
              ),
              child: Container(
                width: 54,
                height: 54,
                color: Dark.accent.value,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: MouseRegion(
              // onEnter: (event) {
              //   isHovered?[index] = true;
              // },
              // onExit: (event) {
              //   isHovered?[index] = false;
              // },
              child: ServerIconButton(
                dimension: 25,
                offset: -1.15,
                isHovered: isHovered,
                index: index,
                right: 0,
                server: server,
                icon: server.iconUrl,
                color: Dark.foreground.value,
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  // SET SELECTED SERVER
                  ServerController.controller.selected.value = server;
                  ServerController.controller.selected.value.index =
                      server.index;

                  if (!ClientController.controller.home.value) {
                    // ignore:
                    if (ServerController
                        .controller.selected.value.members.isEmpty) {
                      Member.fetch(server.id);
                    }
                  }
                  // FETCH CHANNEL MESSAGES
                  int channelIndex = -1;
                  for (var channel in server.channels) {
                    channelIndex = server.channels
                        .indexWhere((element) => element.id == channel.id);
                    if (channelIndex != -1 &&
                        ServerController
                            .controller.selected.value.members.isEmpty) {
                      Message.fetch(
                          server.channels[channelIndex].id, channelIndex);
                      ChannelController.controller.selected.value =
                          server.channels[channelIndex];
                      // Navigator.popAndPushNamed(context, '/');
                      ClientController.controller.home.value = false;
                    }
                  }

                  // CHANGE ROUTE
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ServerIconButton extends StatelessWidget {
  int? index;
  RxList? isHovered = <bool>[].obs;
  final Server? server;
  final VoidCallback onPressed;
  final String? icon;
  final String? avatar;
  final Color? color;
  final EdgeInsets padding;
  // final bool isServer;
  final double dimension;
  final double offset;
  final double? bottom;
  final double? right;

  ServerIconButton({
    super.key,
    required this.onPressed,
    required this.padding,
    required this.dimension,
    required this.offset,
    this.index,
    this.isHovered,
    this.server,
    this.icon,
    this.avatar,
    this.color,
    this.bottom,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    String lastMessage = '';
    String lastId = '';

    int serverIndex = 0;
    serverIndex = ServerController.controller.serversList
        .indexWhere((server) => server.id == server.id);

    for (var channel
        in ServerController.controller.serversList[serverIndex].channels) {
      if (channel.unreads.isNotEmpty) {
        lastId = channel.unreads[0].lastId.value;
      }
      lastMessage = channel.lastMessage;
      if (lastMessage == lastId) {
        channel.isUnread.value = false;
      }
    }

    return Stack(
      children: [
        ClipPath(
          clipper: color != null
              ? HolePuncher(
                  dimension: dimension,
                  offset: offset,
                )
              : null,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: padding,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  IconBorder.radius.toDouble(),
                ),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: icon != null || avatar != null
                      ? Image.network(
                          filterQuality: FilterQuality.medium,
                          fit: BoxFit.cover,
                          isHovered != null &&
                                  index != null &&
                                  isHovered![index!] == true
                              ? '$autumn/icons/$icon'
                              : '$autumn/icons/$icon?max_side=256',
                        )
                      : Container(
                          color: Dark.primaryBackground.value,
                          child: Center(
                            child: Text(server!.name[0]),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        // if (color != null &&
        //     ServerController.controller.serversList[serverIndex].channels
        //         .any((channel) => channel.isUnread.value))
        //   Positioned(
        //     bottom: bottom,
        //     right: right,
        //     child: CircleAvatar(
        //       backgroundColor: color,
        //       radius: 8,
        //     ),
        //   ),
      ],
    );
  }
}

class OptionIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? child;
  final EdgeInsets padding;

  const OptionIconButton({
    super.key,
    required this.onPressed,
    required this.padding,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: padding,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              IconBorder.radius.toDouble(),
            ),
            child: Container(
              width: 48,
              height: 48,
              color: Dark.primaryBackground.value,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
