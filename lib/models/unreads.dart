import 'package:get/get.dart';

class Unread {
  late Id? id;
  late RxString lastId = ''.obs;
  late List<dynamic>? mentions;

  Unread.fromJson(Map<String, dynamic> json) {
    id = Id.fromJson(json["_id"]);
    if (json["last_id"] != null) {
      String last = json['last_id'];
      lastId.value = last;
    }

    if (json["mentions"] != null) {
      mentions = json["mentions"];
    }
  }
}

class Id {
  late String channel;
  late String user;

  Id.fromJson(Map<String, dynamic> json) {
    channel = json["channel"];
    user = json["user"];
  }
}
