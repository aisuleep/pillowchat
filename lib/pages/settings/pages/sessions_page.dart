// TIME AGO CREDIT:
// Sxndrome on SO
// (https://stackoverflow.com/questions/62873902/how-to-display-time-ago-like-youtube-in-flutter)

// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/sessions.dart';
import 'package:http/http.dart' as http;
import 'package:pillowchat/themes/ui.dart';
import 'package:ulid/ulid.dart';

class SessionsPage extends StatelessWidget {
  const SessionsPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Expanded(
            child: ListView.builder(
                itemCount: Client.sessions.length,
                itemBuilder: (context, index) {
                  return SessionTile(
                    id: Client.sessions[index].id!,
                    name: Client.sessions[index].name!,
                  );
                }),
          ),
        ),
      ],
    );
  }
}

class SessionTile extends StatelessWidget {
  SessionTile({super.key, required this.id, required this.name});
  final String id;
  final String name;
  late final Ulid ulid;
  late final DateTime timestamp;
  late String timeAgo;

  @override
  Widget build(BuildContext context) {
    ulid = Ulid.parse(id);
    timestamp = DateTime.fromMillisecondsSinceEpoch(ulid.toMillis()).toLocal();

    String timeAgoFromTimestamp(String timestamp) {
      final year = int.parse(timestamp.substring(0, 4));
      final month = int.parse(timestamp.substring(5, 7));
      final day = int.parse(timestamp.substring(8, 10));
      final hour = int.parse(timestamp.substring(11, 13));
      final minute = int.parse(timestamp.substring(14, 16));

      final DateTime date = DateTime(year, month, day, hour, minute);
      final int diffInHours = DateTime.now().difference(date).inHours;
      final int diffInMinutes = DateTime.now().difference(date).inMinutes;
      final int diffInSeconds = DateTime.now().difference(date).inSeconds;
      String timeUnit = '';
      int timeValue = 0;
      if (diffInMinutes < 1) {
        timeValue = diffInSeconds;
        timeUnit = 'second';
      } else if (diffInHours < 1) {
        timeValue = diffInMinutes;
        timeUnit = 'minute';
      } else if (diffInHours < 24) {
        timeValue = diffInHours;
        timeUnit = 'hour';
      } else if (diffInHours >= 24 && diffInHours < 24 * 7) {
        timeValue = (diffInHours / 24).floor();
        timeUnit = 'day';
      } else if (diffInHours >= 24 * 7 && diffInHours < 24 * 30) {
        timeValue = (diffInHours / (24 * 7)).floor();
        timeUnit = 'week';
      } else if (diffInHours >= 24 * 30 && diffInHours < 24 * 12 * 30) {
        timeValue = (diffInHours / (24 * 30)).floor();
        timeUnit = 'month';
      } else {
        timeValue = (diffInHours / (24 * 365)).floor();
        timeUnit = 'year';
      }

      timeAgo = '$timeValue $timeUnit';
      timeAgo += timeValue > 1 ? 's' : '';

      return timeAgo;
    }

    timeAgo = timeAgoFromTimestamp(timestamp.toString());

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          color: Dark.background.value,
          child: ListTile(
            horizontalTitleGap: 8,
            minLeadingWidth: 0,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            leading: const Icon(
              Icons.verified_user,
              size: 20,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$timeAgo ago',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  iconSize: 20,
                ),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    deleteSession(id);
                  },
                  iconSize: 20,
                  icon: Icon(
                    Icons.logout,
                    color: Dark.error.value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

fetchSessions() async {
  late List<Session> session;

  Uri url = Uri.https(api, '/auth/session/all');
  final response = await http.get(url, headers: {
    'x-session-token': Client.token,
    'Content-Type': 'application/json; charset=utf-8'
  });
  if (response.statusCode == 200) {
    List<dynamic> json = jsonDecode(response.body);
    // ignore:
    if (kDebugMode) print('[sessions] successful fetch!');
    session = json.map((e) => Session.fromJson(e)).toList();
  }
  return session;
}

deleteSessions() async {
  Uri url = Uri.https(api, '/auth/session/all');
  final response = await http.delete(url, headers: {
    'x-session-token': Client.token,
  });
  if (response.statusCode == 204) {
    if (kDebugMode) print('[sessions] successful deletions!');
  }
}

deleteSession(String id) async {
  Uri url = Uri.https(api, '/auth/session/$id');
  final response = await http.delete(url, headers: {
    'x-session-token': Client.token,
  });
  if (response.statusCode == 204) {
    if (kDebugMode) print('[session] successful logout!');
  }
}
