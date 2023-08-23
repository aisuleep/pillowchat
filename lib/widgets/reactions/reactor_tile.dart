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
    RxString url = Client.getAvatar(user, id: reactor).obs;

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

    if (member?.avatar.value?.id != null && member?.avatar.value?.id != '') {
      // IF SERVER AVATAR

      url.value = '$autumn/avatars/${member?.avatar.value?.id}';
    } else if (isMessage) {
      if (user.bot != null && messageIndex?.masquerade?.avatar != '') {
        // IF IS A MASQUERADE

        url.value = messageIndex!.masquerade!.avatar.toString();
      }
    }
    return url.value;
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
          user.avatar?.value.id,
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
                      reactor: user.id == '' ? reactors[index] : null)
                  .obs,
              hasStatus: false,
              radius: 32)),
      // NAMES
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DISPLAYNAME OR USERNAME
          if (user.id == reactors[index] && member == null)
            Text(
              user.displayName != null
                  ? user.displayName!.trim()
                  : user.name.trim(),
              style: TextStyle(
                color: Dark.foreground.value,
              ),
            ),
          // NICKNAME OR DISPLAYNAME OR USERNAME
          if (user.id == reactors[index] &&
              member != null &&
              !ClientController.controller.home.value)
            Text(
              member!.nickname?.value != ''
                  ? member!.nickname!.value.trim()
                  : user.displayName?.trim() ?? user.name.trim(),
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
