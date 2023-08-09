import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:pillowchat/components/reactions/reactor_tile.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/custom/hole_puncher.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/themes/ui.dart';
import 'package:pillowchat/themes/markdown.dart';

class MembersPage extends StatelessWidget {
  const MembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 8,
              color: Dark.primaryBackground.value,
            ),
            Obx(
              () => Expanded(
                child: Container(
                  padding: Platform.isAndroid || Platform.isIOS
                      ? null
                      : const EdgeInsets.only(
                          top: 50,
                        ),
                  color: Dark.background.value,
                  child: Column(
                    children: [
                      // TITLE BAR
                      if (Platform.isAndroid || Platform.isIOS)
                        ListTile(
                          minVerticalPadding: 0,
                          horizontalTitleGap: 0,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          title: Text(
                            ClientController.controller.home.value &&
                                    ChannelController
                                            .controller.selected.value.name !=
                                        null
                                ? ChannelController
                                    .controller.selected.value.name!
                                // : ClientController.controller.home.value &&
                                //         ChannelController
                                //                 .controller.selected.value.user !=
                                //             null
                                //     ? ChannelController
                                //         .controller.selected.value.user!
                                : !ClientController.controller.home.value &&
                                        ChannelController.controller.selected
                                                .value.name !=
                                            null
                                    ? ChannelController
                                        .controller.selected.value.name!
                                    : ChannelController
                                        .controller.selected.value.id,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      // CHANNEL DESCRIPTION
                      if (Platform.isAndroid || Platform.isIOS)
                        if (ChannelController
                                .controller.selected.value.description !=
                            '')
                          ListTile(
                            minVerticalPadding: 0,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: MarkdownBody(
                              data: ChannelController
                                      .controller.selected.value.description ??
                                  '',
                              selectable: true,
                              softLineBreak: true,
                              extensionSet: markdown.extensionSet,
                              styleSheet: markdown.styleSheet,
                              builders: markdown.builders,
                            ),
                          ),

                      // BUTTON BAR
                      if (Platform.isAndroid || Platform.isIOS)
                        ListTile(
                          minVerticalPadding: 0,
                          horizontalTitleGap: 0,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (ClientController.controller.home.value &&
                                  ChannelController
                                          .controller.selected.value.type !=
                                      "DirectMessage")
                                IconButton(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  icon: Icon(
                                    Icons.group_add,
                                    color: Dark.foreground.value,
                                  ),
                                  onPressed: () {},
                                ),
                              if (ClientController.controller.home.value)
                                IconButton(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  icon: Icon(
                                    Icons.phone_in_talk,
                                    color: Dark.foreground.value,
                                  ),
                                  onPressed: () {},
                                ),
                              if (ChannelController
                                      .controller.selected.value.type !=
                                  "DirectMessage")
                                IconButton(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  icon: Icon(
                                    Icons.settings,
                                    color: Dark.foreground.value,
                                  ),
                                  onPressed: () {},
                                ),
                              IconButton(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                icon: Icon(
                                  Icons.search,
                                  color: Dark.foreground.value,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),

                      // SERVER MEMBERS LIST

                      if (!ClientController.controller.home.value)
                        Expanded(
                          child: ListView.builder(
                              itemCount: ServerController
                                  .controller.selected.value.members.length,
                              itemBuilder: (context, index) {
                                final Member member = ServerController
                                    .controller.selected.value.members[index];

                                User? user;
                                int userIndex = ServerController
                                    .controller.selected.value.users
                                    .indexWhere(
                                        (user) => user.id == member.userId);

                                if (userIndex != -1) {
                                  user = ServerController.controller.selected
                                      .value.users[userIndex];
                                }

                                String url;
                                if (user != null) {
                                  url = ReactorTile.getUrl(
                                    false,
                                    user,
                                    serverMember: member,
                                  );

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: ListTile(
                                        dense: true,
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        minLeadingWidth: 0,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 0,
                                          horizontal: 4,
                                        ),
                                        hoverColor:
                                            Dark.primaryBackground.value,
                                        onTap: () {
                                          User.view(
                                            context,
                                            userIndex,
                                            user!,
                                            user.avatar,
                                            user.status.presence,
                                            user.status.text!,
                                            user.id,
                                            member.roles,
                                          );
                                        },
                                        title: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: UserIcon(
                                                url: url,
                                                user: user,
                                                hasStatus: true,
                                                radius: 36,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          // IF USER HAS NICKNAME
                                                          member.nickname !=
                                                                  null
                                                              ? member.nickname!
                                                                  .trim()
                                                              : user.displayName !=
                                                                      null
                                                                  ? user
                                                                      .displayName!
                                                                      .trim()
                                                                  : user.name
                                                                      .trim(),
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: member.roles
                                                                        .isNotEmpty &&
                                                                    member
                                                                            .roles[
                                                                                0]
                                                                            .color !=
                                                                        null &&
                                                                    member
                                                                            .roles[
                                                                                0]
                                                                            .color!
                                                                            .length ==
                                                                        7
                                                                ? Color(
                                                                    int.parse(
                                                                        '0xff${member.roles[0].color?.replaceAll("#", "")}'),
                                                                  )
                                                                : Dark
                                                                    .foreground
                                                                    .value,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      if (user.bot != null)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      4),
                                                          child: Icon(
                                                            Icons.smart_toy,
                                                            color: Dark
                                                                .accent.value,
                                                            size: 15,
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                  Text(
                                                    // IF USER HAS CUSTOM STATUS
                                                    user.status.text != ''
                                                        ? user.status.text!
                                                        : user.status.presence,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return null;
                              }),
                        )

                      // HOME DM MEMBERS

                      else if (ClientController.controller.home.value)
                        Expanded(
                          child: ListView.builder(
                            itemCount: ChannelController
                                .controller.selected.value.users.length,
                            itemBuilder: (context, index) {
                              final presence = ChannelController.controller
                                  .selected.value.users[index].status.presence;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: ListTile(
                                  dense: true,
                                  visualDensity:
                                      const VisualDensity(vertical: -4),
                                  minLeadingWidth: 0,
                                  title: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Stack(
                                          children: [
                                            ClipPath(
                                              clipper: HolePuncher(
                                                  dimension: 15, offset: 1.15),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        IconBorder
                                                            .radius.value),
                                                child: SizedBox(
                                                  height: 32,
                                                  width: 32,
                                                  child: Image.network(
                                                    // IF USER HAS PFP

                                                    ChannelController
                                                                .controller
                                                                .selected
                                                                .value
                                                                .users[index]
                                                                .avatar !=
                                                            ''
                                                        ? '$autumn/avatars/${ChannelController.controller.selected.value.users[index].avatar}'
                                                        : 'https://$api/users/${ChannelController.controller.selected.value.users[index].id}/default_avatar',
                                                    filterQuality:
                                                        FilterQuality.medium,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    presence == 'Online'
                                                        ? Dark.online.value
                                                        : presence == 'Idle'
                                                            ? Dark.away.value
                                                            : presence == 'Busy'
                                                                ? Dark.dnd.value
                                                                : presence ==
                                                                        'Focus'
                                                                    ? Dark.focus
                                                                        .value
                                                                    : Dark
                                                                        .offline
                                                                        .value,
                                                radius: 5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ChannelController
                                                  .controller
                                                  .selected
                                                  .value
                                                  .users[index]
                                                  .name,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              // IF USER HAS CUSTOM STATUS

                                              ChannelController
                                                          .controller
                                                          .selected
                                                          .value
                                                          .users[index]
                                                          .status
                                                          .text !=
                                                      ''
                                                  ? ChannelController
                                                      .controller
                                                      .selected
                                                      .value
                                                      .users[index]
                                                      .status
                                                      .text!
                                                  : ChannelController
                                                      .controller
                                                      .selected
                                                      .value
                                                      .users[index]
                                                      .status
                                                      .presence,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    User.view(
                                      context,
                                      index,
                                      ChannelController.controller.selected
                                          .value.users[index],
                                      ChannelController.controller.selected
                                          .value.users[index].avatar,
                                      ChannelController.controller.selected
                                          .value.users[index].status.presence,
                                      ChannelController.controller.selected
                                          .value.users[index].status.text!,
                                      ChannelController.controller.selected
                                          .value.users[index].id,
                                      [],
                                    );
                                  },
                                ),
                              );
                            },
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
    );
  }
}
