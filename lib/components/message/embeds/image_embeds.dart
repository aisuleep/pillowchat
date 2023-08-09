import 'package:flutter/material.dart';
import 'package:pillowchat/models/message/parts/embeds.dart';

class ImageEmbeds extends StatelessWidget {
  const ImageEmbeds(this.messageIndex, this.index, {super.key});
  final dynamic messageIndex;
  final dynamic index;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 1,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Picture.view(
              context,
              messageIndex.embeds[index].url,
              messageIndex.embeds[index].url,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                      maxHeight: 300,
                    ),
                    child: ClipRRect(
                      // borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        messageIndex.embeds[index].url,
                        filterQuality: FilterQuality.medium,
                        alignment: Alignment.topLeft,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
