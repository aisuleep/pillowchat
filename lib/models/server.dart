import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

    if (json['categories'] != null) {
      categories = List<Categories>.from(
          (json['categories']).map((e) => Categories.fromJson(e)).toList());
    }
    if (json['roles'] != null) {
      RoleJson roleJson;
      roleJson = RoleJson.fromJson(json['roles']);
      roles.value = roleJson.roles.values.toList();
      List<Role> convertRoleJsonToList(RoleJson roleJson) {
        return roleJson.roles.values.toList();
      }

      roles.value = (convertRoleJsonToList(roleJson));
    }
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

  static bool isCssGradient(String color) {
    return color.startsWith('linear-gradient');
  }

  static List<Color> getCssGradient(String cssGradient) {
    List<Color> colors = [];
    // Remove 'linear-gradient' and parentheses
    if (isCssGradient(cssGradient)) {
      cssGradient = cssGradient.replaceAll('linear-gradient', '');
      cssGradient = cssGradient.replaceFirst('(', '');
      cssGradient = cssGradient.replaceAll(')', '');

      // Split the gradient into components (direction and color stops)
      List<String> gradientComponents = cssGradient.split(',');

      // Extract the color values

      for (String component in gradientComponents) {
        String trimmedComponent = component.trim();
        if (!trimmedComponent.contains('deg')) {
          // Assuming any component without 'deg' is a color stop
          // Convert color stop to Color object and add to the list
          colors.add(parseColor(trimmedComponent, colors));
        }
      }
    }
    return colors;
  }

  static Color parseColor(String colorValue, List<Color> gradientColors) {
    if (kDebugMode) print("COLORVALUE1: $colorValue");
    colorValue = colorValue.trim();

    // Check if the colorValue is an RGB format

    if (colorValue.startsWith('rgb(')) {
      colorValue = colorValue.replaceAll("rgb(", '');

      List<int> rgbComponents = colorValue.split(',').map(int.parse).toList();
      if (kDebugMode) print(rgbComponents);
      if (rgbComponents.length == 3) {
        return Color.fromRGBO(
            rgbComponents[0], rgbComponents[1], rgbComponents[2], 1);
      }
    }

    // if (colorValue.startsWith('rgb(')) {
    //   colorValue = colorValue.replaceAll("rgb(", '');
    //   print(" COLORVALUE2:$colorValue");
    //   List<int> rgb = [];
    //   rgb.add(int.parse(colorValue));
    //   print(rgb);
    //   // String rgbValues = colorValue.substring(4, colorValue.length - 1);
    //   // print(rgbValues);
    //   // List<String> rgbComponents =
    //   //     rgbValues.split(',').map((value) => value.trim()).toList();

    //   return Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1);
    // }

    // Check if the colorValue is a hex value
    if (colorValue.startsWith('#')) {
      return Color(int.parse(colorValue.replaceAll('#', ''), radix: 16));
    }

    // Check if the colorValue is a color name
    if (colorNames.containsKey(colorValue)) {
      // Use the color mapping
      return colorNames[colorValue]!;
    }

    // If no match is found, use a default color
    return Colors.cyan;
  }

  static Map<String, Color> colorNames = {
    'black': Colors.black,
    'white': Colors.white,
    'red': Colors.red,
    'green': Colors.green,
    'blue': Colors.blue,
    'yellow': Colors.yellow,
    'orange': Colors.orange,
    'purple': Colors.purple,
    'pink': Colors.pink,
    'grey': Colors.grey,
    'brown': Colors.brown,
  };
}
