// ignore_for_file:

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/l10n/en.dart';
import 'package:pillowchat/models/channel/channels.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/themes/ui.dart';

class Home {
  static int index = -3;
  static List<Channel>? dms;
}

class HomeChannels extends StatelessWidget {
  const HomeChannels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        minLeadingWidth: 0,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Icon(
          Icons.home,
          size: 25,
          color: Dark.foreground.value,
        ),
        title: const Text('Home'),
        onTap: () {
          Home.index = -3;
          ServerController.controller.changeDm(-3);
          if (kDebugMode) print(ServerController.controller.homeIndex.value);
        },
      ),
      ListTile(
        minLeadingWidth: 0,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Icon(
          Icons.explore,
          color: Dark.foreground.value,
          size: 25,
        ),
        title: const Text('Discover'),
        onTap: () {
          ChannelController.controller.selected.value.name = 'Discover';
          Home.index = -2;
          ServerController.controller.changeDm(-2);
          if (kDebugMode) print(ServerController.controller.homeIndex.value);
        },
      ),
      ListTile(
        minLeadingWidth: 0,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Icon(
          Icons.calendar_today,
          color: Dark.foreground.value,
          size: 25,
        ),
        title: const Text('Saved Notes'),
        onTap: () {
          // ChannelController.controller.selected.value = Client.savedNotes;
          ChannelController.controller.selected.value.name = En.savedNotes;

          Home.index = -1;
          ServerController.controller.changeDm(-1);
          if (kDebugMode) print(ServerController.controller.homeIndex.value);
          // Message.fetch(Client.savedNotes.id);
          ChannelController.controller
              .changeChannel(context, Client.savedNotes);
        },
      ),
      ListTile(
        dense: true,
        minLeadingWidth: 0,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Text(
          'conversations'.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        trailing: InkWell(
          child: Icon(
            Icons.add,
            size: 20,
            color: Dark.accent.value,
          ),
          onTap: () {},
        ),
      ),
    ]);
  }
}
