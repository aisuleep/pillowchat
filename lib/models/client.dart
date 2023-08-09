// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pillowchat/components/home_channels.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/l10n/en.dart';
import 'package:pillowchat/main.dart';
import 'package:pillowchat/models/channel/channels.dart';
import 'package:pillowchat/models/emoji.dart';
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/models/sessions.dart';
import 'package:pillowchat/models/unreads.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/models/server.dart';
import 'package:pillowchat/pages/login.dart';
import 'package:pillowchat/pages/settings/pages/sessions_page.dart';
import 'package:pillowchat/themes/ui.dart';
import 'package:pillowchat/util/events.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
// ignore: unused_import
import 'package:web_socket_channel/web_socket_channel.dart';

get emailController => LoginPage.emailController;
get passController => LoginPage.passController;
get api => Client.api;
get autumn => Client.autumn;

class Client {
  static String token = '';
  static late List<Channel> channels;
  static List<Categories> categories = [];
  static List<User> relations = [];
  static RxList<Session> sessions = <Session>[].obs;
  static Rx<Session> currentSession = Session(null, null).obs;
  static const String api = 'api.revolt.chat';
  static const String ws = 'wss://ws.revolt.chat';
  static const String autumn = 'https://autumn.revolt.chat';
  static String getAvatar(User user, {String? id}) {
    String url;
    if (user.avatar != null) {
      url = '$autumn/avatars/${user.avatar}';
    } else {
      if (id == null && user.id != '') {
        url = 'https://$api/users/${user.id}/default_avatar';
      } else {
        url = 'https://$api/users/$id/default_avatar';
      }
    }

    return url;
  }

  static RxInt pushed = 0.obs;

  static late Channel dms;
  static Channel savedNotes = Channel(
    id: 'SavedNotes',
    name: En.savedNotes,
    type: 'SavedMessages',
    members: <Member>[].obs,
    users: <User>[].obs,
    messages: <Message>[].obs,
    isUnread: false.obs,
  );
  static late List<Emoji> emojis;

  static logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var url = Uri.https(api, '/auth/session/logout');

      http.Response response =
          await http.post(url, headers: {'x-session-token': Client.token});

      if (response.statusCode == 204) {
        print('[$response] successful logout ');
        ClientController.controller.updateLogStatus(false);
        // REMOVE SAVED SESSION

        await prefs.remove("token");
        await prefs.remove("user");
        await prefs.remove("userId");
        // SAVE VC SETTINGS

        await prefs.setDouble("iconRadius", IconBorder.radius.value);
        await prefs.setBool("muted", ChannelController.controller.muted.value);
        await prefs.setBool(
            "defeaned", ChannelController.controller.deafened.value);
        // ServerController.controller.dispose();
        // ChannelController.controller.dispose();
        // PanelController.controller.dispose();
        // TODO: CLOSE WEBSOCKET?
      }
    } catch (e) {
      print(e);
    }
  }

  static saveInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", Client.token);

    final double? radius = prefs.getDouble("iconRadius");
    if (radius != null) {
      IconBorder.controller.setRadius(radius);
    }
    final bool? muted = prefs.getBool("muted");
    if (muted != null) {
      ChannelController.controller.toggleMute(muted);
    }
    final bool? deafened = prefs.getBool("deafened");
    if (deafened != null) {
      ChannelController.controller.toggleDeafen(deafened);
    }
    await prefs.setBool('logged', ClientController.controller.logged.value);
    await prefs.setString(
        "userId", ClientController.controller.selectedUser.value.id);
    // String user = jsonEncode(ClientController.controller.selectedUser.value);
    // await prefs.setString("user", user);
    // if (prefs.getString("user") != null) {
    //   print("[Saved] user");
    // }
    String servers = jsonEncode(ServerController.controller.serversList);
    await prefs.setString("servers", servers);
    if (prefs.getString("servers") != null) {
      print("[Saved] servers");
    }
  }

  static login(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var url = Uri.https(api, 'auth/session/login');
      Map body = {
        'email': emailController.text.trim(),
        'password': passController.text,
        'friendly_name': 'Pillow Client'
      };
      // if (prefs.getString("token") == null) {
      print('not null');
      http.Response response = await http.post(url, body: jsonEncode(body));
      if (response.statusCode == 200) {
        print('successful login');
        final json = jsonDecode(response.body);
        print(json);
        final t = json['token'];
        Client.token = t;
        final i = json['_id'];
        Client.currentSession.value.id = i;
        ClientController.controller.updateLogStatus(true);
        ClientController.controller.home.value = true;
        User.fetchSelf();
        await prefs.setString(
            "userId", ClientController.controller.selectedUser.value.id);
        List<Session> sesh = await fetchSessions();
        sessions.assignAll(sesh);
        // await Server.fetchMembers();
        Client.connect();
        saveInfo();

        emailController.clear();
        passController.clear();
      }
      if (response.statusCode == 0) {
        print(response.body);
        emailController.clear();
        passController.clear();
      } else if (response.statusCode == 1) {
        print(response.body);
        throw jsonDecode(response.body)['message'];
      }
      // }
    } catch (e) {
      print(e);
    }
  }

  static void onDone() {
    print('socket done');
  }

  static connect() async {
    // iowebsocket does not work for flutter web
    // emojis are black and white for flutter web
    var socket = IOWebSocketChannel.connect(
        Uri.parse('$ws?version=1&format=json&token=${Client.token}'),
        pingInterval: const Duration(seconds: 18),
        headers: {'Content-Type': 'application/json; charset=utf-8'});
    // .stream.asBroadcastStream();

    socket.stream.listen(
        (event) => _handleSocket(
            event, socket, MyApp.navigatorKey.currentState!.context),
        cancelOnError: true,
        onDone: onDone,
        onError: (e) {});

    await Future.delayed(const Duration(seconds: 0));
  }

  static _handleSocket(event, socket, BuildContext context) {
    final json = jsonDecode(utf8.decode(utf8.encode(event)));

    // print(json);
    // stores onReady event into a List of Server objects
    if (ClientController.controller.logged.value == true) {
      if (pushed.value == 0) {
        print(pushed);
        Navigator.popAndPushNamed(context, '/');
        pushed.value = 1;
        print(pushed);
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
    if (json['type'] == 'Ready') {
      print('servers success');
      // print(json);

      // GET RELATIONSHIPS
      List<dynamic> relationsList = json['users'];
      Client.relations = relationsList.map((e) => User.fromJson(e)).toList();

      // GET SERVERS

      List<dynamic> data = json['servers'];
      var servers = data.map((s) => Server.fromJson(s)).toList();

      // CLIENT SERVER LIST

      ServerController.controller.updateServerList(servers);
      print(servers);
      ServerController.controller.selected.value =
          ClientController.controller.selectedUser.value.homeServer;

      // GET CHANNELS

      List<dynamic> channelsList = json['channels'];
      late List<Channel> channels;

      channels = channelsList.map((e) => Channel.fromJson(e)).toList();
      Client.channels = channels;

      // SORT CHANNELS TO THEIR SERVERS

      sortChannels() {
        late int serverIndex = 0;
        for (int c = 0; c < Client.channels.length; c++) {
          // IF SERVER ID MATCHES CHANNEL'S SERVER
          if (ServerController.controller.serversList
              .any((server) => server.id == Client.channels[c].server)) {
            serverIndex = ServerController.controller.serversList
                .indexWhere((server) => server.id == Client.channels[c].server);
          }
          ServerController.controller.serversList[serverIndex].channels
              .add(Client.channels[c]);
        }
      }

      // GET SAVED NOTES

      Client.savedNotes = Client.channels[0];

      getChannels();
      getDms();
      getUnreads();
      sortChannels();

      // GET EMOJIS
      final emojis = json['emojis'];
      Client.emojis = List<Emoji>.from(emojis.map((e) => Emoji.fromJson(e)));
      // print(Client.emojis);
      //
    } else {
      eventsHandler(json, socket);
    }
  }

  static Future<List<Channel>> getChannels() async {
    return Client.channels;
  }

  static getDms() async {
    try {
      var url = Uri.https(api, '/users/dms');
      var response =
          await http.get(url, headers: {'x-session-token': Client.token});
      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        // print(json);
        var dms = json.map((e) => Channel.fromJson(e)).toList();
        // print(dms);
        Home.dms = dms;
        ServerController.controller.updateDmsList(dms);
      }
    } catch (e) {
      print(e);
    }
    return Home.dms;
  }

  static getUnreads() async {
    try {
      var url = Uri.https(api, '/sync/unreads');
      var response =
          await http.get(url, headers: {'x-session-token': Client.token});
      if (response.statusCode == 200) {
        print("[success] got unreads!");
        List<dynamic> json = jsonDecode(response.body);
        // print(json);
        List<Unread> unreads = json.map((e) => Unread.fromJson(e)).toList();
        // print(unreads);

        ServerController.controller.updateUnreadsList(unreads);

        // SORT UNREADS TO THEIR CHANNELS

        late int channelIndex = 0;
        for (int c = 0; c < Client.channels.length; c++) {
          // IF CHANNEL ID MATCHES UNREAD'S CHANNEL
          if (ServerController.controller.unreadsList
              .any((unread) => unread.id?.channel == Client.channels[c].id)) {
            channelIndex = ServerController.controller.unreadsList.indexWhere(
                (unread) => unread.id?.channel == Client.channels[c].id);
          }
          // ADD UNREAD TO CHANNEL'S UNREADS LIST
          Client.channels[c].unreads
              .add(ServerController.controller.unreadsList[channelIndex]);
          // print(ServerController.controller.unreadsList[channelIndex]);
          // print(Client.channels[c].unreads);
          // Client.channels[c].lastMessage =
          //     ServerController.controller.unreadsList[channelIndex].lastId!;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  // static uploadAttachment() {
  //   String filename;
  // }
}
