class System {
  late String type;
  late String content;

  System(
    this.type,
    this.content,
  );

  System.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    content = json['content'];
  }
}

class Mentions {
  late List<String> mentions;
  Mentions(
    this.mentions,
  );

  Mentions.fromJson(Map<String, dynamic> json) {
    mentions = json['replies'];
  }
}

class Reply {
  String? id;
  bool? mention;
  Reply(
    this.id,
    this.mention,
  );

  Reply.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mention = json['mention'];
  }
}

class Interactions {
  late List<String> reactions;
  late bool restrictReactions;
  Interactions(
    this.reactions,
    this.restrictReactions,
  );

  Interactions.fromJson(Map<String, dynamic> json) {
    reactions = json['reactions'];
    restrictReactions = json['restrict_reactions'];
  }
}

class Masquerade {
  late String name;
  late String avatar;
  String? color;
  Masquerade(
    this.name,
    this.avatar,
    this.color,
  );

  Masquerade.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    avatar = json['avatar'];
    color = json['colour'];

    // ignore: unused_element
    Map<String, dynamic> toJson() {
      return {
        'name': name,
        'avatar': avatar,
        'colour': color,
      };
    }
  }
}
