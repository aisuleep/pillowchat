// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/components/reactions/reactor_tile.dart';
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
    // print(emote);
    // print(reactors);

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
      print(api + '/channels/$target/messages/$message/reactions/$emoji');
      print(e);
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
        print('[Success] deleted reaction');
      }
    } catch (e) {
      print(api + '/channels/$target/messages/$message/reactions/$emoji');
      print(e);
    }
  }

  static showInfo(
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
    if (Platform.isAndroid || Platform.isIOS) {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        showDragHandle: true,
        context: MyApp.navigatorKey.currentState!.context,
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
          // return Obx(
          //   () => ClipRRect(
          //     borderRadius: const BorderRadius.vertical(
          //       top: Radius.circular(15),
          //     ),
          //     child: Container(
          //       color: Dark.background.value,
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 8,
          //       ),
          //       child: Column(
          //         children: [
          //           Flexible(
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(
          //                 horizontal: 8,
          //                 vertical: 16,
          //               ),
          //               // REACTION LIST
          //               child: ScrollablePositionedList.builder(
          //                 scrollDirection: Axis.horizontal,
          //                 shrinkWrap: true,
          //                 itemScrollController: scrollController,
          //                 itemPositionsListener: positionsListener,
          //                 scrollOffsetListener: offsetListener,
          //                 itemCount: emotes.length,
          //                 itemBuilder: (context, index) {
          //                   return Column(
          //                     children: [
          //                       if (emotes[index].toString().length == 26)
          //                         Flexible(
          //                           child: Emote(
          //                             ulid: emotes[index],
          //                             size: 30,
          //                             onTap: () {
          //                               tabIndex.value = index;

          //                               reactors = messageIndex
          //                                   .reactions.reactionMap.values
          //                                   .elementAt(tabIndex.value)
          //                                   .map((e) => e)
          //                                   .toList();
          //                               scrollController.scrollTo(
          //                                 index: index,
          //                                 duration:
          //                                     const Duration(milliseconds: 300),
          //                               );
          //                             },
          //                           ),
          //                         )
          //                       else
          //                         Flexible(
          //                           child: InkWell(
          //                             onTap: () {
          //                               tabIndex.value = index;
          //                               scrollController.scrollTo(
          //                                 index: index,
          //                                 duration:
          //                                     const Duration(milliseconds: 300),
          //                               );
          //                               reactors = messageIndex
          //                                   .reactions.reactionMap.values
          //                                   .elementAt(tabIndex.value)
          //                                   .map((e) => e)
          //                                   .toList();
          //                             },
          //                             child: Text(
          //                               emotes[index],
          //                             ),
          //                           ),
          //                         ),
          //                       Visibility(
          //                         visible: index == tabIndex.value,
          //                         child: Container(
          //                           height: 8,
          //                           width: 20,
          //                           color: Dark.accent.value,
          //                         ),
          //                       ),
          //                     ],
          //                   );
          //                 },
          //               ),
          //             ),
          //           ),
          //           // REACTORS
          //           ReactorList(reactors: reactors),
          //         ],
          //       ),
          //     ),
          //   ),
          // );
        },
      );
    } else {
      return showDialog(
        context: MyApp.navigatorKey.currentState!.context,
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Dark.background.value,
                  ),
                  child: ReactorsMenu(
                    reactors: reactors,
                    emotes: emotes,
                    scrollController: scrollController,
                    offsetListener: offsetListener,
                    positionsListener: positionsListener,
                    tabIndex: tabIndex,
                    message: messageIndex,
                  ),
                ),
              ),
            ),
          );
        },
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
    return Obx(
      () => Column(
        children: [
          Flexible(
            child: SizedBox(
              height: 70,
              child: Row(
                children: [
                  Flexible(
                    // REACTION LIST
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
                          return Column(
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
                                              reactors.assignAll(message
                                                  .reactions.reactionMap.values
                                                  .elementAt(tabIndex.value)
                                                  .map((e) => e)
                                                  .toList());
                                              tabIndex.value = index;

                                              // reactors.refresh();

                                              scrollController.scrollTo(
                                                index: index,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                              );
                                            },
                                          )
                                        : InkWell(
                                            onTap: () {
                                              reactors.assignAll(message
                                                  .reactions.reactionMap.values
                                                  .elementAt(tabIndex.value)
                                                  .map((e) => e)
                                                  .toList());
                                              tabIndex.value = index;

                                              // reactors.refresh();

                                              scrollController.scrollTo(
                                                index: index,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                              );
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
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
          ReactorList(reactors: reactors),
        ],
      ),
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
    return Expanded(
      flex: 3,
      child: Obx(
        () => ListView.builder(
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
