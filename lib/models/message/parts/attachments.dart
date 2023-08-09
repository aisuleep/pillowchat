class Attachment {
  late String? id;
  late String? tag;
  late String? filename;
  late dynamic metadata;
  late String? type;
  late int? width;
  late int? height;
  // late String objectId;

  Attachment(
    this.id,
    this.tag,
    this.filename,
    this.metadata,
    // this.objectId,
  );

  Attachment.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    tag = json['tag'];
    filename = json['filename'];
    metadata = json['metadata'];
    type = metadata['type'];
    height = metadata['height'];
    width = metadata['width'];
    // objectId = json['object_id'];
  }
}
