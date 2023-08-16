import 'package:flutter/material.dart';
import 'package:pillowchat/widgets/headers/tab_header.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/themes/ui.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TabHeader(
                  title: 'Notifications',
                  color: Dark.foreground.value,
                  icon: Icons.settings,
                )
              ],
            ),
          ),
          BottomNavigationBar(
              onTap: (value) {
                if (value == 0) {
                  Navigator.popAndPushNamed(context, '/' // PageRouteBuilder(
                      // pageBuilder: (_, __, ___) => Panels(
                      // server: ServerController.controller.selected.value),
                      // ),
                      );
                }
                if (value == 1) {
                  // nothing
                }
                if (value == 2) {
                  Navigator.popAndPushNamed(context, '/'
                      // PageRouteBuilder(
                      // pageBuilder: (_, __, ___) => const FriendsPage(),
                      // ),
                      );
                }
                if (value == 3) {
                  Navigator.popAndPushNamed(context, '/'
                      // PageRouteBuilder(
                      // pageBuilder: (_, __, ___) => const SettingsPage(),
                      // ),
                      );
                }
              },
              currentIndex: 1,
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
                        ClientController.controller.selectedUser.value.avatar !=
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
    );
  }
}
