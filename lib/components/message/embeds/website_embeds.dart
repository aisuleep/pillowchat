// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/themes/ui.dart';
import 'package:pillowchat/themes/markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pillowchat/models/message/parts/embeds.dart';

class WebsiteEmbeds extends StatelessWidget {
  const WebsiteEmbeds(this.messageIndex, this.e, this.index, {super.key});
  final dynamic messageIndex;
  final dynamic e;
  final dynamic index;
  @override
  Widget build(BuildContext context) {
    // EMBED GIFS FROM GIFBOX
    if (messageIndex.embeds[e].special == 'GIF') {
      return InkWell(
        onTap: () {
          Picture.view(context, messageIndex.embeds[e].image,
              messageIndex.embeds[e].url);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 200, maxWidth: 300),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                messageIndex.embeds[e].image,
              ),
            ),
          ),
        ),
      );
    }
    // print(messageIndex.embeds[e].color);
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
        right: 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 4,
                color: messageIndex.embeds[e].color != null &&
                        !messageIndex.embeds[e].color.contains("rgba")
                    ? Color(
                        int.parse(
                          messageIndex.embeds[e].color.replaceAll('#', '0xff'),
                        ),
                      )
                    : Dark.secondaryForeground.value.withOpacity(0.5),
              ),
            ),
            color: Dark.background.value,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.all(8),
              title: MarkdownBody(
                softLineBreak: true,
                data: ChannelController.controller.selected.value
                            .messages[index].embeds![e].title !=
                        null
                    ? '[${ChannelController.controller.selected.value.messages[index].embeds![e].title}](${ChannelController.controller.selected.value.messages[index].embeds![e].url})'
                    : '',
                styleSheet: markdown.styleSheet,
                onTapLink: (text, href, title) {
                  Future<void> _launchUrl() async {
                    if (!await launchUrl(Uri.parse(href!))) {
                      throw Exception('Could not launch $href');
                    }
                  }

                  _launchUrl();
                },
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ChannelController.controller.selected.value
                          .messages[index].embeds![e].description !=
                      null)
                    MarkdownBody(
                      selectable: true,
                      shrinkWrap: true,
                      // overflow: TextOverflow
                      // .ellipsis,
                      data: ChannelController.controller.selected.value
                          .messages[index].embeds![e].description,
                      styleSheet: markdown.styleSheet,
                      onTapLink: ((text, href, title) {
                        Future<void> _launchUrl() async {
                          if (!await launchUrl(Uri.parse(href!))) {
                            throw Exception('Could not launch $href');
                          }
                          _launchUrl();
                        }

                        _launchUrl();
                      }),
                    ),
                  if (ChannelController.controller.selected.value
                          .messages[index].embeds![e].image !=
                      '')
                    GestureDetector(
                      onTap: () {
                        Picture.view(
                            context,
                            ChannelController.controller.selected.value
                                .messages[index].embeds![e].image,
                            ChannelController.controller.selected.value
                                .messages[index].embeds![e].image);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            ChannelController.controller.selected.value
                                .messages[index].embeds![e].image,
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
