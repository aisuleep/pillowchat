// ignore_for_file:  , must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/controllers/channels.dart';
import 'package:pillowchat/themes/ui.dart';

class VoiceChat extends StatelessWidget {
  VoiceChat({super.key});

  bool muted = false;
  bool deafened = false;
  bool inCall = true;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Visibility(
              visible: ChannelController.controller.inCall.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Dark.accent.value,
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Dark.accent.value,
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Dark.accent.value,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              minVerticalPadding: 0,
              contentPadding: const EdgeInsets.all(0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: ChannelController.controller.inCall.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ChannelController.controller.muted.value
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {
                                  ChannelController.controller
                                      .toggleMute(muted);
                                  if (kDebugMode) print(muted);
                                },
                                icon: Icon(
                                  Icons.mic_off,
                                  color: Dark.accent.value,
                                ),
                              ),
                            )
                          : Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                hoverColor: Dark.background.value,
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  ChannelController.controller
                                      .toggleMute(!muted);
                                  if (kDebugMode) print(!muted);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: CircleAvatar(
                                    backgroundColor: Dark.background.value,
                                    child: Icon(
                                      Icons.mic,
                                      color: Dark.secondaryForeground.value,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  Visibility(
                    visible: ChannelController.controller.inCall.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ChannelController.controller.deafened.value
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {
                                  ChannelController.controller
                                      .toggleDeafen(deafened);
                                  if (kDebugMode) print(deafened);
                                },
                                icon: Icon(
                                  Icons.headset_off,
                                  color: Dark.accent.value,
                                ),
                              ),
                            )
                          : Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                hoverColor: Dark.background.value,
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  ChannelController.controller
                                      .toggleDeafen(!deafened);
                                  if (kDebugMode) print(!deafened);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Dark.background.value,
                                    child: Icon(
                                      Icons.headset,
                                      color: Dark.secondaryForeground.value,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            hoverColor: Dark.background.value,
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              ChannelController.controller.changeCall(inCall);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Visibility(
                                    visible: !ChannelController
                                        .controller.inCall.value,
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text("Join call"),
                                    ),
                                  ),
                                  if (!ChannelController
                                      .controller.inCall.value)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Icon(
                                        Icons.mic,
                                        color: Dark.foreground.value,
                                      ),
                                    )
                                  else
                                    InkWell(
                                      hoverColor: Dark.background.value,
                                      borderRadius: BorderRadius.circular(15),
                                      onTap: () {
                                        ChannelController.controller
                                            .changeCall(!inCall);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.call_end,
                                          color: Dark.error.value,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
