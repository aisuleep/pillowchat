import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/components/headers/tab_header.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/themes/ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  TabHeader(
                    leading: Platform.isAndroid || Platform.isIOS
                        ? null
                        : Icons.close,
                    onPressed: Platform.isAndroid || Platform.isIOS
                        ? null
                        : () {
                            Navigator.popAndPushNamed(context, '/');
                          },
                    title: 'Settings',
                    color: Dark.foreground.value,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(
                        () => ListView(
                          children: [
                            // USER CARD
                            const UserCard(),
                            // ICON RADIUS SLIDER
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                children: [
                                  const Text('Icon Radius'),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Slider(
                                      value: IconBorder.radius.value,
                                      max: 50,
                                      divisions: 5,
                                      label: '${IconBorder.radius.value}',
                                      thumbColor: Dark.accent.value,
                                      activeColor: Dark.accent.value,
                                      inactiveColor: Dark.background.value,
                                      onChanged: (double value) {
                                        IconBorder.radius.value = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // TIME FORMAT SWITCH
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                children: [
                                  const Text('Use 12-Hour Time'),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Checkbox(
                                      value: ClientController
                                                  .controller.time.value ==
                                              0
                                          ? true
                                          : false,
                                      activeColor: Dark.accent.value,
                                      onChanged: (value) {
                                        if (ClientController
                                                .controller.time.value ==
                                            0) {
                                          ClientController
                                              .controller.time.value = 1;
                                        } else {
                                          ClientController
                                              .controller.time.value = 0;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color: Dark.background.value,
                                      child: SettingsTab(
                                        icon: Icons.record_voice_over_sharp,
                                        title: 'Status',
                                        trailingIcon: Icons.edit,
                                        isSubpage: true,
                                        text: Row(
                                          children: [
                                            Text(ClientController
                                                .controller
                                                .selectedUser
                                                .value
                                                .status
                                                .presence),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                radius: 5,
                                                backgroundColor: ClientController
                                                            .controller
                                                            .selectedUser
                                                            .value
                                                            .status
                                                            .presence ==
                                                        'Online'
                                                    ? Dark.online.value
                                                    : ClientController
                                                                .controller
                                                                .selectedUser
                                                                .value
                                                                .status
                                                                .presence ==
                                                            'Idle'
                                                        ? Dark.away.value
                                                        : ClientController
                                                                    .controller
                                                                    .selectedUser
                                                                    .value
                                                                    .status
                                                                    .presence ==
                                                                'Busy'
                                                            ? Dark.dnd.value
                                                            : ClientController
                                                                        .controller
                                                                        .selectedUser
                                                                        .value
                                                                        .status
                                                                        .presence ==
                                                                    'Focus'
                                                                ? Dark
                                                                    .focus.value
                                                                : Dark.offline
                                                                    .value,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        color: Dark.background.value,
                                        child: const Column(
                                          children: [
                                            SettingsTab(
                                              icon: Icons.person,
                                              title: 'My Account',
                                              trailingIcon: Icons.arrow_forward,
                                            ),
                                            SettingsTab(
                                              icon: Icons.badge,
                                              title: 'Profile',
                                              trailingIcon: Icons.arrow_forward,
                                              isSubpage: true,
                                            ),
                                            SettingsTab(
                                              icon: Icons.verified_user,
                                              title: 'Sessions',
                                              trailingIcon: Icons.arrow_forward,
                                              isSubpage: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        color: Dark.background.value,
                                        child: const Column(
                                          children: [
                                            SettingsTab(
                                              icon: Icons.palette,
                                              title: 'Appearance',
                                              trailingIcon: Icons.arrow_forward,
                                              // page: SettingsPage(),
                                            ),
                                            SettingsTab(
                                              icon: Icons.language,
                                              title: 'Language',
                                              trailingIcon: Icons.arrow_forward,
                                              // page: SettingsPage(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        color: Dark.background.value,
                                        child: const Column(
                                          children: [
                                            SettingsTab(
                                              icon: Icons.smart_toy,
                                              title: 'My Bots',
                                              trailingIcon: Icons.arrow_forward,
                                              // page: SettingsPage(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        color: Dark.background.value,
                                        child: SettingsTab(
                                          title: 'Logout',
                                          color: Dark.error.value,
                                          icon: Icons.logout,
                                          trailingIcon: Icons.arrow_forward,
                                          logout: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
            if (Platform.isAndroid || Platform.isIOS)
              BottomNavigationBar(
                  onTap: (value) {
                    if (value == 0) {
                      Navigator.popAndPushNamed(context, '/'
                          // PageRouteBuilder(
                          //   pageBuilder: (_, __, ___) => Panels(
                          //       server: ServerController.controller.selected.value),
                          // ),
                          );
                    }
                    if (value == 1) {
                      Navigator.popAndPushNamed(context, '/'
                          // PageRouteBuilder(
                          // pageBuilder: (_, __, ___) => const NotificationsPage(),
                          // ),
                          );
                    }
                    if (value == 2) {
                      Navigator.popAndPushNamed(context, '/'
                          // PageRouteBuilder(
                          // pageBuilder: (_, __, ___) => const FriendsPage(),
                          // ),
                          );
                    }
                    if (value == 3) {
                      // nothing
                    }
                  },
                  currentIndex: 3,
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.chat),
                      label: 'chat',
                      tooltip: '',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.notifications),
                      label: 'mentions',
                      tooltip: '',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.emoji_people),
                      label: 'friends',
                      tooltip: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Visibility(
                        visible: ClientController.controller.logged.value &&
                            ClientController
                                    .controller.selectedUser.value.avatar !=
                                null,
                        child: UserIcon(
                          user: ClientController.controller.selectedUser.value,
                          radius: 36,
                          hasStatus: true,
                        ),
                      ),
                      label: 'settings',
                      tooltip: '',
                    ),
                  ]),
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Dark.background.value,
          child: ListTile(
            onTap: () {},
            title: Container(
              padding: const EdgeInsets.all(0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(IconBorder.radius.value),
                      child: Image.network(
                        '$autumn/avatars/${ClientController.controller.selectedUser.value.avatar}',
                        height: 54,
                        width: 54,
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ClientController
                                    .controller.selectedUser.value.displayName
                                    ?.trim() ??
                                ClientController
                                    .controller.selectedUser.value.name
                                    .trim(),
                            style: TextStyle(
                              fontSize:
                                  ClientController.controller.fontSize.value,
                            ),
                          ),
                          Text(
                            '${ClientController.controller.selectedUser.value.name}#${ClientController.controller.selectedUser.value.discriminator}',
                            style: TextStyle(
                              fontSize:
                                  ClientController.controller.fontSize.value *
                                      0.8,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  color: Dark.foreground.value,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  child: Text(
                                    'ID',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Dark.background.value,
                                      fontSize: ClientController
                                              .controller.fontSize.value *
                                          0.8,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    ClientController
                                        .controller.selectedUser.value.id,
                                    style: TextStyle(
                                      fontSize: ClientController
                                              .controller.fontSize.value *
                                          0.8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({
    super.key,
    required this.title,
    this.trailingIcon,
    this.icon,
    this.logout,
    // this.page,
    this.text,
    this.color,
    this.isSubpage,
  });

  final String title;
  final IconData? trailingIcon;
  final IconData? icon;
  final bool? logout;
  final bool? isSubpage;
  final Widget? text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (logout == null) {
          if (isSubpage == true) {
            Navigator.pushNamed(context, '/settings/${title.toLowerCase()}');
          }
        } else {
          Client.logout(context);
        }
      },
      minLeadingWidth: 20,
      leading: Icon(
        icon,
        size: 20,
        color: color ?? Dark.foreground.value,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Dark.foreground.value,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (text != null) text!,
          Icon(
            trailingIcon,
            size: 20,
            color: color ?? Dark.foreground.value,
          ),
        ],
      ),
    );
  }
}

class SettingsSubPage extends StatelessWidget {
  const SettingsSubPage({
    super.key,
    required this.title,
    required this.page,
    this.leading,
    this.isSubpage,
  });

  final String title;
  final Widget page;
  final IconData? leading;
  final bool? isSubpage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TabHeader(
              leading: leading,
              onPressed: isSubpage == true
                  ? () {
                      Navigator.pop(context);
                    }
                  : null,
              title: title,
              color: Dark.foreground.value,
            ),
            Expanded(child: page),
          ],
        ),
      ),
    );
  }
}
