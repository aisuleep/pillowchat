class Session {
  late String id;
  late String? name;

  Session(this.id, this.name);

  Session.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    name = json["name"];
  }
}
