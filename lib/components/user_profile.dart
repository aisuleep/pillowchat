// ignore_for_file: prefer_is_empty, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/server.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/themes/markdown.dart';
import 'package:pillowchat/themes/ui.dart';
import 'package:pillowchat/models/message/parts/embeds.dart';

// ignore: must_be_immutable
class UserProfile extends StatelessWidget {
  UserProfile({
    super.key,
    required this.user,
    required this.username,
    required this.discriminator,
    required this.userIndex,
    required this.presence,
    required this.text,
    required this.id,
    required this.roles,
    this.displayName,
    this.avatar,
    this.profile,
  });
  final String? displayName;
  final String username;
  final String discriminator;
  final int userIndex;
  final String? avatar;
  final String presence;
  final String text;
  final String id;
  final double dimension = 30;
  List<Role> roles;
  Rx<int> tabIndex = 0.obs;
  Profile? profile;
  final User user;
  @override
  Widget build(BuildContext context) {
    setProfile() {
      User.fetchProfile(id, index: userIndex);
    }

    if (ServerController.controller.selected.value.users[userIndex].profile ==
        null) {
      setProfile();
    }

    String? content = profile?.content;
    return Obx(
      () => Container(
        color: Dark.background.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: 130,
                child: Stack(
                  children: [
                    if (ServerController.controller.selected.value
                            .users[userIndex].profile?.background !=
                        null)
                      Positioned.fill(
                        child: AspectRatio(
                          aspectRatio: 1 / 3,
                          child: Image.network(
                            '$autumn/backgrounds/${ServerController.controller.selected.value.users[userIndex].profile?.background?.id}',
                            filterQuality: FilterQuality.medium,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.black.withOpacity(0.5),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Picture.view(
                                      context,
                                      avatar ?? '',
                                      username,
                                      user: user,
                                      isServer: false,
                                    );
                                  },
                                  child: UserIcon(
                                    hasStatus: true,
                                    radius: 60,
                                    user: user,
                                    url: Client.getAvatar(user),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  bottom: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            displayName ?? user.name,
                                            style: TextStyle(
                                              fontSize: ClientController
                                                  .controller.fontSize.value,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '$username#$discriminator',
                                            style: TextStyle(
                                              color: Dark
                                                  .secondaryForeground.value,
                                              fontSize: ClientController
                                                  .controller.fontSize.value,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: id !=
                                          ClientController
                                              .controller.selectedUser.value.id,
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        icon: Icon(
                                          Icons.person_add_alt_1_rounded,
                                          color: Dark.foreground.value,
                                        ),
                                        onPressed: () {
                                          // IF NOT FRIENDS
                                          // User.add();
                                        },
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
              ),
            ),

            // USER STATUS

            // IF USER HAS CUSTOM STATUS
            if (text != "")
              Container(
                color: Colors.black,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Dark.secondaryForeground.value,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // TABS

            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: DefaultTabController(
                length: 4,
                child: TabBar(
                  physics: const BouncingScrollPhysics(),
                  isScrollable: true,
                  // indicatorWeight: 1,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Dark.primaryBackground.value,
                  ),
                  labelColor: Dark.foreground.value,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  onTap: (int index) {
                    tabIndex.value = index;
                  },
                  tabs: const [
                    Tab(
                      text: 'Profile',
                    ),
                    Tab(
                      text: 'Mutual Friends',
                    ),
                    Tab(
                      text: 'Mutual Groups',
                    ),
                    Tab(
                      text: 'Mutual Servers',
                    ),
                  ],
                ),
              ),
            ),

            if (tabIndex.toInt() == 0)
              Flexible(
                child: ProfileTab(
                  user: user,
                  content: content,
                  roles: roles,
                ),
              ),
            if (tabIndex.toInt() == 1) const Flexible(child: Friends()),
            if (tabIndex.toInt() == 2) const Flexible(child: Groups()),
            if (tabIndex.toInt() == 3) const Flexible(child: Servers()),
          ],
        ),
      ),
    );
  }
}

class Servers extends StatelessWidget {
  const Servers({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 7,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text('server'),
            ),
          );
        });
  }
}

class Groups extends StatelessWidget {
  const Groups({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 7,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text('group'),
            ),
          );
        });
  }
}

class Friends extends StatelessWidget {
  const Friends({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 7,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text('friend'),
            ),
          );
        });
  }
}

// ignore: must_be_immutable
class ProfileTab extends StatelessWidget {
  ProfileTab({
    super.key,
    required this.user,
    required this.content,
    required this.roles,
  });
  User user = User(id: '', name: '');
  final String? content;
  List<Role> roles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          if (roles.length != 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'Roles'.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

          if (roles.length != 0)
            RoleList(
              roles: roles,
            ),
          // BIO

          Text(
            'Information'.toUpperCase(),
            style: TextStyle(
              color: Dark.secondaryForeground.value,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (user.profile?.content != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Dark.primaryBackground.value,
                  padding: const EdgeInsets.all(8),
                  child: MarkdownBody(
                    data: user.profile?.content ?? '',
                    softLineBreak: true,
                    styleSheet: markdown.styleSheet,
                    builders: markdown.builders,
                    extensionSet: markdown.extensionSet,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RoleList extends StatelessWidget {
  const RoleList({
    super.key,
    required this.roles,
  });
  final List<Role> roles;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(
        roles.length,
        (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    color: roles[index].color?.length == 7
                        ? Color(
                            int.parse(
                                '0xff${roles[index].color!.replaceAll("#", "")}'),
                          ).withOpacity(0.5)
                        : Dark.primaryBackground.value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  IconBorder.radius.value),
                              child: Container(
                                height: 15,
                                width: 15,
                                color: roles[index].color?.length == 7
                                    ? Color(
                                        int.parse(
                                            '0xff${roles[index].color!.replaceAll("#", "")}'),
                                      )
                                    : Dark.foreground.value,
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              Text(
                                roles[index].name,
                                style: TextStyle(
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 2
                                    ..color = roles[index].color?.length == 7
                                        ? Color(
                                            int.parse(
                                                '0xff${roles[index].color!.replaceAll("#", "")}'),
                                          )
                                        : Dark.primaryBackground.value,
                                ),
                              ),
                              Text(
                                roles[index].name,
                                style: TextStyle(
                                  color: Dark.foreground.value,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
