// ignore_for_file:

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:pillowchat/widgets/home_channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/message/parts/embeds.dart';
import 'package:pillowchat/models/server.dart';
import 'package:pillowchat/widgets/server_sidebar.dart';
import 'package:pillowchat/widgets/dm_channels.dart';
import 'package:pillowchat/themes/markdown.dart';
import 'package:pillowchat/themes/ui.dart';

import '../../widgets/server_channels.dart';

class ServersPage extends StatelessWidget {
  const ServersPage({super.key, this.server});
  final Server? server;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Dark.background.value,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => Expanded(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(15)),
                        child: Stack(
                          children: [
                            if (ServerController
                                        .controller.selected.value.banner !=
                                    null &&
                                !ClientController.controller.home.value)
                              Positioned.fill(
                                child: Image.network(
                                  '$autumn/banners/${ServerController.controller.selected.value.banner}',
                                  filterQuality: FilterQuality.medium,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (ServerController
                                        .controller.selected.value.banner !=
                                    null &&
                                !ClientController.controller.home.value)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.5),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Visibility(
                                    visible: ClientController
                                        .controller.logged.value,
                                    child: const HomeIcon()),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Text(
                                              ServerController.controller
                                                  .selected.value.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (!ClientController
                                          .controller.home.value)
                                        IconButton(
                                          padding: const EdgeInsets.all(0),
                                          icon: const Icon(
                                            Icons.more_horiz,
                                            size: 24,
                                          ),
                                          onPressed: () {
                                            showModalBottomSheet(
                                              backgroundColor:
                                                  Dark.background.value,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              isScrollControlled: true,
                                              showDragHandle: true,
                                              context: context,
                                              builder: (context) {
                                                return DraggableScrollableSheet(
                                                    initialChildSize: 0.6,
                                                    // minChildSize: 0.4,
                                                    // maxChildSize: 0.8,
                                                    expand: false,
                                                    builder: (context,
                                                        ScrollController
                                                            scrollController) {
                                                      return SingleChildScrollView(
                                                          child: ServerInfo());
                                                    });
                                              },
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const ServerSidebar(),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    // child: ClipRRect(
                                    //   borderRadius: const BorderRadius.horizontal(
                                    //     left: Radius.circular(15),
                                    //     right: Radius.circular(15),
                                    //   ),
                                    child: ClientController
                                            .controller.home.value
                                        ? Container(
                                            padding: Client.isDesktop
                                                ? null
                                                : const EdgeInsets.only(
                                                    bottom: 65),
                                            child: Column(
                                              children: [
                                                const HomeChannels(),
                                                // DM CHANNELS
                                                Obx(
                                                  () => Expanded(
                                                    child: ListView.builder(
                                                        itemCount:
                                                            ServerController
                                                                .controller
                                                                .dmsList
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return DmChannels(
                                                              index);
                                                        }),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : ServerChannels(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 8,
                color: Dark.primaryBackground.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServerInfo extends StatelessWidget {
  ServerInfo({super.key});
  final server = ServerController.controller.selected.value;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Container(
            constraints: const BoxConstraints(maxHeight: 150),
            child: Stack(
              children: [
                if (server.banner != null &&
                    !ClientController.controller.home.value)
                  Positioned.fill(
                    child: Image.network(
                      '$autumn/banners/${ServerController.controller.selected.value.banner}',
                      filterQuality: FilterQuality.medium,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (server.banner != null &&
                    !ClientController.controller.home.value)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ServerIconButton(
                          dimension: 25,
                          offset: 1.15,
                          icon: server.iconUrl,
                          padding: const EdgeInsets.all(8),
                          onPressed: () {
                            Picture.view(context, server.iconUrl!, server.name,
                                isServer: true);
                          },
                        ),
                        Text(
                          ServerController.controller.selected.value.name,
                          style: TextStyle(
                            fontSize:
                                ClientController.controller.fontSize.value *
                                    1.1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Dark.offline.value,
                                radius: 5,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text("${server.members.length} Members"),
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
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          color: Dark.background.value,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.flag,
                      size: 24,
                      color: Dark.accent.value,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.drive_file_rename_outline_rounded,
                      size: 24,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.settings,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          color: Dark.primaryBackground.value,
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (server.description != null)
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Dark.background.value,
                      child: MarkdownBody(
                        data: server.description!,
                        softLineBreak: true,
                        styleSheet: markdown.styleSheet,
                        extensionSet: markdown.extensionSet,
                        builders: markdown.builders,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class HomeIcon extends StatelessWidget {
  const HomeIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // MAKE AVATAR CHANGE DEPENDING ON SERVER

    // final memberIndex = ServerController.controller.selected.value.members
    //     .indexWhere((member) =>
    //         member.userId == ClientController.controller.selectedUser.value.id);
    // String avatar = '';
    // String getAvatar() {
    //   if (memberIndex != -1 && !ClientController.controller.home.value) {
    //     avatar = ServerController
    //         .controller.selected.value.members[memberIndex].avatar;
    //   } else {
    //     avatar = ClientController.controller.selectedUser.value.avatar != ''
    //         ? ClientController.controller.selectedUser.value.avatar
    //         : "$autumn/default_avatar/${ClientController.controller.selectedUser.value.id}";
    //   }
    //   return avatar;
    // }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Obx(
        () => Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                IconBorder.radius.toDouble(),
              ),
              child: Container(
                width: 54,
                height: 54,
                color: ClientController.controller.home.value
                    ? Dark.accent.value
                    : Colors.transparent,
              ),
            ),
            InkWell(
              onTap: () {
                ServerController.controller.selected.value =
                    ClientController.controller.selectedUser.value.homeServer;
                ServerController.controller.selected.value.index = -1;
                Navigator.popAndPushNamed(context, '/');

                ClientController.controller.home.value = true;
              },
              child: Stack(
                children: [
                  UserIcon(
                    user: ClientController.controller.selectedUser.value,
                    hasStatus: true,
                    radius: 48,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
