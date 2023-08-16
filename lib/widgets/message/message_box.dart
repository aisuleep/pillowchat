// ignore_for_file:

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/themes/ui.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({super.key});

  static TextEditingController messageController = TextEditingController();
  static bool unlocked = true;
  static bool editing = false;

  static late String id;
  static late String initialContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 2,
        bottom: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Dark.secondaryHeader.value,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Obx(
          () => Column(
            children: [
              if (ChannelController.controller.editing.value)
                // EDITING BANNER

                Material(
                  type: MaterialType.transparency,
                  child: ListTile(
                      textColor: Dark.secondaryHeader.value,
                      leading: const Icon(Icons.edit),
                      title: const Text('Editing'),
                      trailing: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Dark.accent.value,
                          ),
                          onPressed: () {
                            editing = false;
                            ChannelController.controller.toggleEditing(editing);
                            messageController.clear();
                          })),
                ),
              // BOX
              ListTile(
                horizontalTitleGap: 0,
                minVerticalPadding: 0,
                minLeadingWidth: 0,
                contentPadding: const EdgeInsets.all(0),
                title: TextField(
                  controller: messageController,
                  maxLines: null,
                  maxLength: 2000,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  readOnly: !ChannelController.controller.unlocked.value,
                  decoration: InputDecoration(
                      filled: false,
                      constraints: const BoxConstraints(maxHeight: 220),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: unlocked ? 4 : 8,
                      ),
                      border: InputBorder.none,

                      // SAVED NOTES HINT TEXT

                      hintText: ClientController.controller.home.value &&
                              ChannelController
                                      .controller.selected.value.type ==
                                  'SavedMessages'
                          ? "Save to your notes"

                          // CHANNEL HINT TEXT

                          : ChannelController.controller.unlocked.value == false
                              ? ''
                              : ClientController.controller.home.value &&
                                      ChannelController
                                              .controller.selected.value.name !=
                                          null
                                  ? 'Message ${ChannelController.controller.selected.value.name}'
                                  : ChannelController
                                              .controller.selected.value.type ==
                                          "DirectMessage"
                                      ? 'Message friend'
                                      : 'Message #${ChannelController.controller.selected.value.name}',
                      hintStyle: TextStyle(
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                          color: Dark.secondaryForeground.value),
                      counterText: ''),
                ),
                leading: Visibility(
                  visible: unlocked,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                    ),
                  ),
                ),
                trailing: unlocked && !editing
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.emoji_emotions,
                            ),
                          ),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(
                              Icons.send,
                            ),
                            onPressed: () {
                              // MAKE MESSAGE BOX CONTROLLER TEXT = CONTENT

                              final content = messageController.text;
                              if (content.trim() != '') {
                                Message.send(content);
                                messageController.clear();
                              }
                              ItemScrollController().jumpTo(index: 0);
                            },
                          ),
                        ],
                      )
                    : editing == true
                        ? IconButton(
                            onPressed: () {
                              if (messageController.text != initialContent) {
                                final content = messageController.text;
                                Message.edit(content, id);
                              }

                              editing = false;
                              ChannelController.controller
                                  .toggleEditing(editing);
                              messageController.clear();
                            },
                            icon: Icon(
                              Icons.send,
                              color: Dark.accent.value,
                            ))
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.lock_rounded,
                              color: Dark.accent.value,
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
