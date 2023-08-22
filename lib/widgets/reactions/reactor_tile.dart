import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/themes/ui.dart';

class ReactorTile extends StatelessWidget {
  const ReactorTile({
    super.key,
    required this.userIndex,
    required this.index,
    required this.user,
    required this.member,
    required this.reactors,
  });

  final int userIndex;
  final int index;
  final User user;
  final Member? member;
  final RxList<String> reactors;
  static String getUrl(bool isMessage, User user,
      {Member? serverMember, Message? messageIndex, String? reactor}) {
    Member? member;
    int memberIndex;
    String url = Client.getAvatar(user, id: reactor);

    if (serverMember == null) {
      memberIndex = ServerController.controller.selected.value.members
          .indexWhere((member) => member.userId == reactor);
      if (memberIndex != -1) {
        member =
            ServerController.controller.selected.value.members[memberIndex];
      }
    } else {
      // IS NOT A MEMBER OF THE SERVER

      member = serverMember;
    }
    // GET AVATAR URL

    if (member?.avatar != null && member?.avatar != '') {
      // IF SERVER AVATAR

      url = '$autumn/avatars/${member!.avatar!}';
    } else if (isMessage) {
      if (user.bot != null && messageIndex?.masquerade?.avatar != '') {
        // IF IS A MASQUERADE

        url = messageIndex!.masquerade!.avatar.toString();
      }
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(4),
      horizontalTitleGap: 8,
      onTap: () {
        Navigator.of(context).pop();

        User.view(
          context,
          userIndex,
          user,
          user.avatar,
          user.status.presence,
          user.status.text!,
          user.id,
          member!.roles,
          // serverRoles,
        );
      },
      // USER ICON
      leading: SizedBox(
          width: 50,
          child: UserIcon(
              url: getUrl(false, user,
                  reactor: user.id == '' ? reactors[index] : null),
              hasStatus: false,
              radius: 32)),
      // NAMES
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NICKNAME OR DISPLAYNAME
          if (user.id == reactors[index] && member == null)
            Text(
              user.displayName != null
                  ? user.displayName!.trim()
                  : user.name.trim(),
              style: TextStyle(
                color: ClientController.controller.home.value ||
                        member!.roles.isEmpty
                    ? Dark.foreground.value
                    : member?.roles.length != null &&
                            member?.roles[0].color != null &&
                            member?.roles[0].color?.length == 7
                        ? Color(
                            int.parse(
                                '0xff${member?.roles[0].color?.replaceAll("#", "")}'),
                          )
                        : Dark.foreground.value,
              ),
            ),
          if (user.id == reactors[index] &&
              member != null &&
              !ClientController.controller.home.value)
            Text(
              member!.nickname?.trim() ??
                  user.displayName?.trim() ??
                  user.name.trim(),
              style: TextStyle(
                color: ClientController.controller.home.value ||
                        member!.roles.isEmpty
                    ? Dark.foreground.value
                    : member?.roles[0].color != null &&
                            member?.roles[0].color?.length == 7
                        ? Color(
                            int.parse(
                                '0xff${member?.roles[0].color?.replaceAll("#", "")}'),
                          )
                        : Dark.foreground.value,
                fontWeight: FontWeight.bold,
              ),
            ),
          // USERNAME
          if (user.id == reactors[index])
            Text(
              "@${user.name.trim()}#${user.discriminator}",
              style: TextStyle(
                color: Dark.secondaryForeground.value,
              ),
            ),
        ],
      ),
    );
  }
}
