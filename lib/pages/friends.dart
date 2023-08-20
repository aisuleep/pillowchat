import 'package:flutter/material.dart';
import 'package:pillowchat/widgets/headers/tab_header.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/themes/ui.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TabHeader(
            title: 'Friends',
            icon: Icons.person_add,
            color: Dark.foreground.value,
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 100,
                      color: Dark.accent.value,
                      child: const Center(child: Text('Pending Requests')),
                    ),
                  ),
                ),
                const Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CategoryTile(
                          title: 'online',
                        ),
                        CategoryTile(
                          title: 'offline',
                        ),
                        CategoryTile(
                          title: 'blocked',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (Client.isMobile)
            BottomNavigationBar(
                onTap: (value) {
                  if (value == 0) {}
                  if (value == 1) {}
                  if (value == 2) {}
                  if (value == 3) {}
                },
                currentIndex: 2,
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
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String title;

  const CategoryTile({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    int userIndex =
        Client.relations.indexWhere((user) => user.relationship == "Friend");
    return ExpansionTile(
      iconColor: Dark.foreground.value,
      collapsedIconColor: Dark.accent.value,
      textColor: Dark.foreground.value,
      collapsedTextColor: Dark.secondaryForeground.value,
      initiallyExpanded: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // ignore: prefer_const_constructors
          Text(Client.relations.length.toString()),
        ],
      ),
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            if (userIndex != -1) {
              User user = Client.relations[userIndex];
              if (user.status.presence != 'Offline') {
                return UserTile(
                  user: user,
                );
              }
            }
            return null;
          },
        )
      ],
    );
  }
}

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 0,
      leading: UserIcon(
        user: user,
        hasStatus: true,
        radius: 30,
      ),
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ClientController.controller.fontSize.value,
                  ),
                ),
                Text(
                  user.status.text ?? user.status.presence,
                  style: TextStyle(
                    color: Dark.secondaryForeground.value,
                    fontSize: ClientController.controller.fontSize.value * 0.8,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {},
            icon: const Icon(Icons.call),
            iconSize: 20,
            color: Dark.primaryHeader.value,
          ),
          IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {},
            icon: const Icon(Icons.email),
            iconSize: 20,
            color: Dark.primaryHeader.value,
          ),
          IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {},
            icon: const Icon(Icons.person_remove),
            iconSize: 20,
          ),
        ],
      ),
    );
  }
}
