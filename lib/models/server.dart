import 'package:get/get.dart';
import 'package:pillowchat/models/channel/channels.dart';
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/user.dart';

class Server {
  int? index;
  late String id;
  late String name;
  List<Categories> categories = [];
  String? iconUrl;
  String? banner;
  String? description;
  List<Channel> channels = [];
  RoleJson? roleJson;
  RxList<Role> roles = <Role>[].obs;
  RxList<Member> members = <Member>[].obs;
  RxList<User> users = <User>[].obs;
  Server(
    this.id,
    this.index,
    this.name,
    this.iconUrl,
    this.banner,
    this.description,
    this.channels,
    this.categories,
  );
  Server.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    if (json["icon"] != null) {
      final icon = json["icon"];
      if (icon["_id"] != null) {
        iconUrl = icon['_id'];
      }
    }
    if (json['banner'] != null) {
      banner = json['banner']['_id'];
    }
    description = json['description'];
    // channels = json['channels'];

    // if (json['categories'] != null) {
    categories = List<Categories>.from(
        (json['categories']).map((e) => Categories.fromJson(e)).toList());
    // }
    RoleJson roleJson;
    roleJson = RoleJson.fromJson(json['roles']);
    roles.value = roleJson.roles.values.toList();
    List<Role> convertRoleJsonToList(RoleJson roleJson) {
      return roleJson.roles.values.toList();
    }

    roles.value = (convertRoleJsonToList(roleJson));

    // for (Role role in roles) {
    //   print("roles: ${role.rank}, ${role.color}");
    // }
  }
}

class Categories {
  Categories(
    this.id,
    this.title,
    this.channels,
  );
  late String id;
  late String title;
  late List<dynamic> channels = [];
  late List<String> channelIcons;
  late List<String> channelsName = [];
  late List<dynamic> channelId = [];
  late List<String> channelType = [];
  // late List<String> channelDescription = [];

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    channelId = json['channels'];
  }
}

class RoleJson {
  Map<String, Role> roles;

  RoleJson({required this.roles});

  factory RoleJson.fromJson(Map<String, dynamic> json) {
    Map<String, Role> roles = {};

    json.forEach((key, value) {
      roles[key] = Role.fromJson(value, key);
    });
    return RoleJson(roles: roles);
  }
}

class Role {
  Role({
    required this.id,
    required this.name,
    required this.rank,
    required this.permissions,
    this.color,
    this.hoist,
  });

  // object items
  final String name;
  // map
  final Map<String, int> permissions;
  final int rank;
  final String id;
  final String? color;
  final bool? hoist;

  factory Role.fromJson(Map<String, dynamic> json, String id) {
    return Role(
      id: id,
      name: json['name'],
      permissions: Map<String, int>.from(json['permissions']),
      color: json['colour'],
      hoist: json['hoist'],
      rank: json['rank'],
    );
  }
}
