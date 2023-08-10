// ignore_for_file:

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/models/client.dart';
import 'package:http/http.dart' as http;
import 'package:pillowchat/models/server.dart';
import 'package:pillowchat/models/user.dart';

class Member {
  late String serverId;
  late String userId = '';
  late String joinedAt;
  String? nickname;
  String? avatar;
  List<dynamic> roleIds = [];
  RxList<Role> roles = <Role>[].obs;
  // late String timeout;

  Member(
    this.joinedAt,
    this.avatar,
  );
  Member.fromJson(Map<String, dynamic> json) {
    // dynamic id;
    if (json['_id'] != null) {
      // id = json['_id'];
      userId = json['_id']['user'];
    }

    // joinedAt = json['joined_at'];

    // if (json['nickname'] != null) {
    nickname = json['nickname'];
    // }
    if (json['avatar'] != null) {
      final avatars = json['avatar'];
      avatar = avatars['_id'];
    }

    if (json['roles'] != null) {
      roleIds = json['roles'];
    }

    // timeout = json['timeout'];
  }
  static fetch(String target) async {
    try {
      // final queryParameters = {'exclude_offline': 'false'};
      var url = Uri.https(
        api,
        '/servers/$target/members',
        // queryParameters,
      );

      var response = await http.get(url, headers: {
        'x-session-token': Client.token,
      });
      if (response.statusCode == 200) {
        final dynamic json = jsonDecode(utf8.decode(response.bodyBytes));

        if (kDebugMode) print('[success] members fetch');
        final members = json['members'];
        final users = json['users'];

        final memberList =
            List<Member>.from(members.map((m) => Member.fromJson(m)));
        ServerController.controller.updateMemberList(memberList);

        final List<User> userList =
            List<User>.from(users.map((u) => User.fromJson(u))).toList();
        ServerController.controller.updateUserList(userList);

        // GET SERVER MEMBERS NAME COLOR
        for (Member member
            in ServerController.controller.selected.value.members) {
          Member.getColor(member.userId, member);
        }
      }

      if (response.statusCode == 0) {
      } else if (response.statusCode == 1) {
        if (kDebugMode) print(response.body);
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  static String getColor(String userId, Member member) {
    String roleColor = '';
    final roleIds = member.roleIds;
    List<Role> serverRoles = ServerController.controller.selected.value.roles;

    for (Role role in ServerController.controller.selected.value.roles) {
      if (member.userId == userId) {
        int? roleIndex = roleIds.indexWhere((roleId) => roleId == role.id);

        // SORT SERVER ROLES BY RANK
        serverRoles.sort((a, b) => (a.rank).compareTo(b.rank));

        // SORT MEMBERS ROLES ACCORDING TO RANK
        for (Role serverRole in serverRoles) {
          roleIds.sort((a, b) =>
              serverRole.id.indexOf(a).compareTo(serverRole.id.indexOf(b)));

          if (role.color != null) {
            roleColor = role.color!;
          }
        }
        // if (kDebugMode) print(roleIndex);
        if (roleIndex != -1) {
          member.roles.add(role);
        }
      }
    }
    return roleColor;
  }
}
