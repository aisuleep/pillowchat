import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/widgets/reactions/reactor_tile.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/main.dart';
import 'package:pillowchat/models/client.dart';
import 'package:http/http.dart' as http;
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/themes/markdown.dart';
import 'package:pillowchat/themes/ui.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Reaction {
  Map<String, List<String>>? reactionMap;
  String emote;
  List<String> reactors;

  Reaction(
    this.emote,
    this.reactors,
    this.reactionMap,
  );

  factory Reaction.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>> map = {};

    json.forEach((key, value) {
      List<String> ulidList = List<String>.from(value.map((e) => e as String));
      map.putIfAbsent(key, () => ulidList);
    });
    late String emote;
    late List<String> reactors;
    for (var entry in map.entries) {
      emote = entry.key;
      reactors = entry.value;
    }
    // if (kDebugMode) print(emote);
    // if (kDebugMode) print(reactors);

    return Reaction(emote, reactors, map);
  }
  static add(String target, String message, String emoji) async {
    try {
      var url = Uri.https(
          api, '/channels/$target/messages/$message/reactions/$emoji');
      final response = await http.put(
        url,
        headers: {
          'x-session-token': Client.token,
        },
      );
      if (response.statusCode == 200) {
        // }
      }
    } catch (e) {
      if (kDebugMode) {
        print(api + '/channels/$target/messages/$message/reactions/$emoji');
      }
      if (kDebugMode) print(e);
    }
  }

  static remove(String target, String message, String emoji) async {
    final queryParameters = {
      'user_id': ClientController.controller.selectedUser.value.id,
    };
    try {
      var url = Uri.https(
          api,
          '/channels/$target/messages/$message/reactions/$emoji',
          queryParameters);
      final response = await http.delete(
        url,
        headers: {
          'x-session-token': Client.token,
        },
      );
      // TODO: FIX BUG THAT CRASHES APP WHEN REACTION IS REMOVED and doesnt acknowledge

      if (response.statusCode == 200) {
        if (kDebugMode) print('[Success] deleted reaction');
      }
    } catch (e) {
      if (kDebugMode) {
        print(api + '/channels/$target/messages/$message/reactions/$emoji');
      }
      if (kDebugMode) print(e);
    }
  }

  static showInfo(
    BuildContext context,
    RxList<dynamic> emotes,
    dynamic messageIndex,
    Rx<int> tabIndex,
    ItemScrollController scrollController,
    ItemPositionsListener positionsListener,
    ScrollOffsetListener offsetListener,
  ) {
    RxList<dynamic> reactors = [].obs;
    reactors.value = (messageIndex.reactions.reactionMap.values
        .elementAt(tabIndex.value)
        .map((e) => e)
        .toList());
    if (Client.isMobile) {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        showDragHandle: true,
        context: context,
        builder: (context) {
          return ReactorsMenu(
            reactors: reactors,
            emotes: emotes,
            offsetListener: offsetListener,
            positionsListener: positionsListener,
            scrollController: scrollController,
            message: messageIndex,
            tabIndex: tabIndex,
          );
        },
      );
    } else {
      MyApp.showPopup(
        context: context,
        widget: ReactorsMenu(
          reactors: reactors,
          emotes: emotes,
          scrollController: scrollController,
          offsetListener: offsetListener,
          positionsListener: positionsListener,
          tabIndex: tabIndex,
          message: messageIndex,
        ),
      );
    }
  }
}

class ReactorsMenu extends StatelessWidget {
  const ReactorsMenu({
    super.key,
    required this.reactors,
    required this.emotes,
    required this.offsetListener,
    required this.positionsListener,
    required this.scrollController,
    required this.message,
    required this.tabIndex,
  });

  final RxList<dynamic> reactors;
  final List emotes;

  final ScrollOffsetListener offsetListener;
  final ItemPositionsListener positionsListener;
  final ItemScrollController scrollController;
  final Message message;
  final Rx<int> tabIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 70,
          child: Row(
            children: [
              Flexible(
                // REACTION LIST
                child: ScrollConfiguration(
                  behavior:
                      ScrollConfiguration.of(context).copyWith(dragDevices: {
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.touch,
                  }),
                  child: ScrollablePositionedList.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const ScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemScrollController: scrollController,
                      itemPositionsListener: positionsListener,
                      scrollOffsetListener: offsetListener,
                      itemCount: emotes.length,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => Column(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: SizedBox(
                                    width: 24,
                                    child: emotes[index].length == 26
                                        ? Emote(
                                            size: 30,
                                            ulid: emotes[index],
                                            onTap: () {
                                              tabIndex.value = index;
                                              scrollController.scrollTo(
                                                index: index,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                              );
                                              reactors.assignAll(message
                                                  .reactions.reactionMap.values
                                                  .elementAt(tabIndex.value)
                                                  .map((e) => e)
                                                  .toList());
                                            },
                                          )
                                        : InkWell(
                                            onTap: () {
                                              tabIndex.value = index;
                                              scrollController.scrollTo(
                                                index: index,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                              );
                                              reactors.assignAll(message
                                                  .reactions.reactionMap.values
                                                  .elementAt(tabIndex.value)
                                                  .map((e) => e)
                                                  .toList());
                                            },
                                            child: Center(
                                              child: Text(
                                                emotes[index],
                                                style: const TextStyle(
                                                    fontSize: 24),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: index == tabIndex.value,
                                child: Container(
                                  height: 8,
                                  width: 20,
                                  color: Dark.accent.value,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: ReactorList(reactors: reactors),
        ),
      ],
    );
  }
}

class ReactorList extends StatelessWidget {
  const ReactorList({
    super.key,
    required this.reactors,
  });

  final RxList reactors;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: reactors.length,
          itemBuilder: (context, index) {
            late int userIndex;
            if (!ClientController.controller.home.value) {
              userIndex = ServerController.controller.selected.value.users
                  .indexWhere((user) => user.id == reactors[index]);
            } else {
              userIndex = ChannelController.controller.selected.value.users
                  .indexWhere((user) => user.id == reactors[index]);
            }

            User user = User(id: '', name: '');
            // IF NOT HOME

            if (!ClientController.controller.home.value && userIndex != -1) {
              user =
                  ServerController.controller.selected.value.users[userIndex];
            } else if (ClientController.controller.home.value == true &&
                userIndex != -1) {
              user =
                  ChannelController.controller.selected.value.users[userIndex];
            }
            final int memberIndex = ServerController
                .controller.selected.value.members
                .indexWhere((member) => member.userId == reactors[index]);
            Member? member;
            if (memberIndex != -1) {
              member = ServerController
                  .controller.selected.value.members[memberIndex];
            }
            return ReactorTile(
              userIndex: userIndex,
              user: user,
              member: member,
              reactors: reactors,
              index: index,
            );
          },
        ),
      ),
    );
  }
}
