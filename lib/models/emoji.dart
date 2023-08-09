class Emoji {
  String id;
  Parent parent;
  String creatorId;
  String name;

  Emoji({
    required this.id,
    required this.parent,
    required this.creatorId,
    required this.name,
  });

  factory Emoji.fromJson(Map<String, dynamic> json) {
    return Emoji(
      id: json["_id"],
      parent: Parent.fromJson(json["parent"]),
      creatorId: json["creator_id"],
      name: json["name"],
    );
  }
}

class Parent {
  String type;
  String id;

  Parent({
    required this.type,
    required this.id,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      type: json["type"],
      id: json["id"],
    );
  }
}
