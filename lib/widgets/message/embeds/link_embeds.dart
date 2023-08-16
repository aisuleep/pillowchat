export 'package:pillowchat/components/message/embeds/link_embeds.dart';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/themes/ui.dart';
import 'package:pillowchat/themes/markdown.dart';

class LinkEmbeds extends StatelessWidget {
  const LinkEmbeds(this.messageIndex, this.e, this.index, {super.key});
  final dynamic messageIndex;
  final int e;
  final dynamic index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
        right: 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: const Border(
              left: BorderSide(
                width: 4,
                color: Colors.transparent,
              ),
            ),
            color: Dark.background.value,
          ),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.all(8),
            title: MarkdownBody(
              softLineBreak: true,
              data:
                  '[${ChannelController.controller.selected.value.messages[index].embeds![e].title}](${ChannelController.controller.selected.value.messages[index].embeds![e].url})',
              styleSheet: markdown.styleSheet,
              onTapLink: (text, href, title) {},
            ),
            subtitle: MarkdownBody(
              softLineBreak: true,
              selectable: true,
              data: ChannelController.controller.selected.value.messages[index]
                  .embeds![e].description,
              styleSheet: markdown.styleSheet,
              onTapLink: ((text, href, title) {}),
            ),
          ),
        ),
      ),
    );
  }
}
