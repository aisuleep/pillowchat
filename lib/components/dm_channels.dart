import 'package:flutter/material.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/components/home_channels.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/themes/ui.dart';

class DmChannels extends StatelessWidget {
  DmChannels(
    this.index, {
    super.key,
  });
  final int index;
  late final homeChannelSelected = Home.dms?[index];

  @override
  Widget build(BuildContext context) {
    User user = User(id: '', name: '');

    if (Home.dms?[index].recipients != null &&
        Home.dms?[index].type == 'DirectMessage') {
      int userIndex = -1;
      for (var recipient in Home.dms![index].recipients!) {
        // print(recipient);
        userIndex = Client.relations.indexWhere((user) =>
            user.id == recipient &&
            recipient != ClientController.controller.selectedUser.value.id);
        if (userIndex != -1) {
          user = Client.relations[userIndex];
        }
      }
    }
    if (index > 0) {
      return ListTile(
        dense: true,
        minLeadingWidth: 0,
        horizontalTitleGap: 8,
        visualDensity: const VisualDensity(
          vertical: -4,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

        leading: Home.dms?[index].type == 'Group'
            ? ClipRRect(
                borderRadius: BorderRadius.circular(IconBorder.radius.value),
                child: Container(
                    height: 32,
                    width: 32,
                    color: Home.dms?[index].type == 'Group'
                        ? Dark.accent.value
                        : Colors.transparent,
                    child: Icon(
                      Icons.people_alt_outlined,
                      color: Dark.background.value,
                    )),
              )
            : UserIcon(
                user: user,
                hasStatus: true,
                radius: 32,
              ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ServerController.controller.dmsList[index].name != null
                  ? ServerController.controller.dmsList[index].name!
                  : user.name,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                fontSize: ClientController.controller.fontSize.value,
              ),
            ),
            Text(
              ServerController.controller.dmsList[index].type == 'DirectMessage'
                  ? user.status.presence != ''
                      ? user.status.presence
                      : user.status.text!
                  : ServerController
                              .controller.dmsList[index].recipients!.length >
                          1
                      ? '${ServerController.controller.dmsList[index].recipients!.length} members'
                      : '${ServerController.controller.dmsList[index].recipients!.length} member',
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: ClientController.controller.fontSize.value * .8,
              ),
            ),
          ],
        ),

        // NOTIFICATION DOT

        // trailing: CircleAvatar(
        //   radius: 10,
        //   backgroundColor: Colors.transparent,
        //   child: CircleAvatar(
        //     radius: 4,
        //     backgroundColor: Dark.foreground.value,
        //   ),
        // ),
        onTap: () {
          Home.index = index;
          ServerController.controller.homeIndex.value = index;
          ClientController.controller.home.value = true;
          // FETCH MESSAGES
          ChannelController.controller
              .changeChannel(context, homeChannelSelected!);
          // ignore: avoid_print
          print("[dm channel] change $index");
          Message.fetch(Home.dms![index].id, index);
        },
      );
    }
    return const SizedBox();
  }
}
