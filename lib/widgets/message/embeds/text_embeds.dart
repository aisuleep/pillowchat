// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pillowchat/themes/ui.dart';
import 'package:pillowchat/themes/markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class TextEmbeds extends StatelessWidget {
  const TextEmbeds(this.messageIndex, this.index, {super.key});
  final dynamic messageIndex;
  final dynamic index;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 4,
              color: messageIndex.embeds[0].color != null &&
                      messageIndex.embeds[0].color.contains('var') == false
                  ? Color(
                      int.parse(
                          messageIndex.embeds[0].color.replaceAll('#', '0xff')),
                    )
                  : Dark.secondaryForeground.value.withOpacity(0.5),
            ),
          ),
          color: Dark.background.value,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 4,
                ),
                child: Row(
                  children: [
                    if (messageIndex.embeds[0].iconUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.network(
                            messageIndex.embeds[0].iconUrl,
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                      ),
                    if (messageIndex.embeds[0].title != null)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            messageIndex.embeds[0].title,
                            style: TextStyle(
                              color: Dark.secondaryForeground.value,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (messageIndex.embeds[0].description != null)
                MarkdownBody(
                  softLineBreak: true,
                  selectable: true,
                  extensionSet: markdown.extensionSet,
                  data: messageIndex.embeds[0].description,
                  styleSheet: markdown.styleSheet,
                  onTapLink: ((text, href, title) {
                    Future<void> _launchUrl() async {
                      if (!await launchUrl(Uri.parse(href!))) {
                        throw Exception('Could not launch $href');
                      }
                    }

                    _launchUrl();
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
