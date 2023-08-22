import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:pillowchat/widgets/message/message_box.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/models/message/parts/reactions.dart';
import 'package:pillowchat/themes/ui.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MessageOptions extends StatelessWidget {
  MessageOptions({
    super.key,
    required this.messageId,
    required this.content,
    required this.author,
    required this.reactedTo,
    this.editTime,
    this.reactions,
    // this.reactors,
    this.messageIndex,
  });
  final dynamic messageIndex;
  final String messageId;
  final String content;
  final String author;
  final bool reactedTo;
  final String? editTime;
  final RxList<Reaction>? reactions;
  // final RxList<String>? reactors;
  final Rx<int>? tabIndex = 0.obs;
  final ItemScrollController? scrollController = ItemScrollController();
  final ItemPositionsListener? positionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener? offsetListener = ScrollOffsetListener.create();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: InkWell(
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Dark.primaryBackground.value,
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: InkWell(
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Dark.primaryBackground.value,
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: InkWell(
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Dark.primaryBackground.value,
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: InkWell(
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Dark.primaryBackground.value,
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: InkWell(
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Dark.primaryBackground.value,
                        child: Icon(
                          Icons.add_reaction,
                          size: 22,
                          color: Dark.accent.value,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Message.showEmoteMenu(
                          context,
                          messageId,
                          reactedTo,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  tileColor: Colors.transparent,
                  minLeadingWidth: 8,
                  dense: true,
                  onTap: () {},
                  leading: const Icon(
                    Icons.reply,
                    size: 22,
                  ),
                  title: const Text('Reply'),
                ),
                if (reactions != null)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    tileColor: Colors.transparent,
                    minLeadingWidth: 8,
                    dense: true,
                    onTap: () {
                      Navigator.pop(context);
                      // Reaction.showInfo(
                      //   context,
                      //   reactors!,
                      //   reactions!,
                      //   messageIndex,
                      //   tabIndex!,
                      //   scrollController!,
                      //   positionsListener!,
                      //   offsetListener!,
                      // );
                    },
                    leading: const Icon(
                      Icons.emoji_emotions,
                      size: 22,
                    ),
                    title: const Text('Reactions'),
                  ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  tileColor: Colors.transparent,
                  minLeadingWidth: 8,
                  dense: true,
                  onTap: () {},
                  leading: const Icon(
                    Icons.copy,
                    size: 22,
                  ),
                  title: const Text('Copy Text'),
                ),
                if (author == ClientController.controller.selectedUser.value.id)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    tileColor: Colors.transparent,
                    minLeadingWidth: 8,
                    dense: true,
                    onTap: () {
                      MessageBox.initialContent = content;
                      MessageBox.messageController.text =
                          MessageBox.initialContent;
                      MessageBox.id = messageId;
                      Navigator.pop(context);
                      MessageBox.editing = true;
                      ChannelController.controller
                          .toggleEditing(MessageBox.editing);
                    },
                    leading: const Icon(
                      Icons.edit,
                      size: 22,
                    ),
                    title: const Text('Edit Message'),
                  ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  tileColor: Colors.transparent,
                  minLeadingWidth: 8,
                  dense: true,
                  onTap: () {
                    Message.delete(messageId);
                    Navigator.pop(context);
                  },
                  leading: const Icon(
                    Icons.delete_forever,
                    size: 22,
                  ),
                  title: const Text('Delete Message'),
                ),
                Divider(
                  height: 4,
                  thickness: 4,
                  color: Dark.primaryBackground.value,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  tileColor: Colors.transparent,
                  minLeadingWidth: 8,
                  dense: true,
                  onTap: () {},
                  leading: const Icon(
                    Icons.info_rounded,
                    size: 22,
                  ),
                  title: const Text('Copy Message ID'),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  tileColor: Colors.transparent,
                  minLeadingWidth: 8,
                  dense: true,
                  onTap: () {},
                  leading: Icon(
                    Icons.flag,
                    size: 22,
                    color: Dark.error.value,
                  ),
                  title: Text(
                    'Report',
                    style: TextStyle(color: Dark.error.value),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  tileColor: Colors.transparent,
                  dense: true,
                  title: Center(child: Text(messageId)),
                ),
                if (editTime != '')
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    tileColor: Colors.transparent,
                    dense: true,
                    title: Center(
                        child: Text(
                            'edited at ${DateTime.parse(editTime!).toLocal()}')),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
