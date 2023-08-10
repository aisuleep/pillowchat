import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/message/parts/message_components.dart';
import 'package:pillowchat/models/message/parts/reactions.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/themes/ui.dart';
export 'package:pillowchat/models/message/parts/embeds.dart';

class Embeds {
  late String? website;
  late String? type;
  late String? url;
  late String? originalUrl;
  late String? title;
  late String? description;
  late String? image = '';
  late Video? video;
  late String? siteName;
  late String? iconUrl;
  late dynamic special;
  late String? color;
  late Mentions? mentions;
  late Reply? replies;
  late Reaction? reactions;
  late Interactions? interactions;
  late Masquerade? masquerade;

  Embeds(
    this.url,
    this.type,
    // this.originalUrl,
    this.title,
    this.description,
    // this.image,
    // this.video,
    // this.siteName,
    // this.iconUrl,
    this.color,
    // this.mentions,
    // this.replies,
    // this.reactions,
    // this.interactions,
    // this.masquerade,
  );
  Embeds.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    iconUrl = json['icon_url'];
    // originalUrl = json['original_url'];
    title = json['title'];
    type = json['type'];
    description = json['description'];
    if (json['image'] != null) {
      var imageObject = json['image'];

      image = imageObject['url'];
    }
    // if (json['video'] != null) {
    //   video = Video.fromJson(json['video']);
    //   if (kDebugMode) print(video!.url);
    // }
    // siteName = json['site_name'];
    if (special = json['special'] != null) {
      special = json['special']['type'];
    }

    // iconUrl = json['icon_url'];
    color = json['colour'];
    // mentions = json[];
    // replies = json[];
    // reactions = json[];
    // interactions = json[];
    // masquerade = json[];
  }
}

class Picture {
  late String url;

  late int width;
  late int height;
  late String size;
  Picture(
    this.url,
    this.width,
    this.height,
    this.size,
  );

  Picture.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
    size = json['size'];
  }

  static view(BuildContext context, String url, String title,
      {User? user, bool? isServer}) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: PhotoView(
                    tightMode: true,
                    enablePanAlways: true,
                    filterQuality: FilterQuality.high,
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    imageProvider: NetworkImage(isServer == true
                            ? "$autumn/icons/$url"
                            : isServer == null
                                ? url
                                : Client.getAvatar(user!)
                        // :  "$autumn/icons/$url",
                        ),
                  ),
                ),
              ),
              Container(
                color: Dark.background.value,
                child: Row(
                  children: [
                    Flexible(
                      child: ListTile(
                        onTap: () {
                          // ignore:
                          if (kDebugMode) print('todo: copy filename');
                        },
                        dense: true,
                        horizontalTitleGap: 0,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        title: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Material(
                            type: MaterialType.transparency,
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              splashColor: Dark.accent.value,
                              splashRadius: 20,
                              icon: Icon(
                                Icons.open_in_browser,
                                color: Dark.foreground.value,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Material(
                            type: MaterialType.transparency,
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              splashColor: Dark.accent.value,
                              splashRadius: 20,
                              icon: Icon(
                                Icons.download_rounded,
                                color: Dark.foreground.value,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Video {
  late String url;
  late int width;
  late int height;
  Video(
    this.url,
    this.width,
    this.height,
  );

  Video.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }
}
