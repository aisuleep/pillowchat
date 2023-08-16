import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/widgets/home_channels.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/channel/channels.dart';
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/models/user.dart';

class ChannelController extends GetxController {
  Rx<Channel> selected = Channel(
    id: '',
    name: '',
    type: '',
    members: <Member>[].obs,
    users: <User>[].obs,
    messages: <Message>[].obs,
    isUnread: false.obs,
  ).obs;
  RxString avatar = "".obs;
  RxList<Message> messageList = <Message>[].obs;
  RxBool unlocked = true.obs;
  RxBool showMembers = true.obs;
  RxBool editing = false.obs;
  RxBool typing = false.obs;
  RxList<String> typingList = <String>[].obs;
  RxBool inCall = false.obs;
  RxBool muted = true.obs;
  RxBool deafened = false.obs;
  static final ChannelController controller = Get.put(ChannelController());

  void changeChannel(
    BuildContext context,
    Channel channel,
  ) {
    selected.value = channel;
    Panels.slideToMiddle(context);
  }

  void updateMessageList(
    int index,
    List<Message> messages,
    List<User> users,
  ) {
    Home.dms![index].messages.assignAll(messages);
    Home.dms![index].messages.refresh();

    Home.dms![index].users.addAll(users);
    Home.dms![index].users.refresh();
  }

  void addMessage(Message message) {
    messageList.add(message);
  }

  void toggleLock(bool bool) {
    unlocked.value = bool;
  }

  void toggleEditing(bool bool) {
    editing.value = bool;
  }

  void triggerTyping(bool bool) {
    typing.value = bool;
  }

  // void typingUsers(List<String> userId) {
  //   typingList.assignAll(userId);
  // }

  void changeCall(bool bool) {
    inCall.value = bool;
  }

  void toggleMute(bool bool) {
    muted.value = bool;
  }

  void toggleDeafen(bool bool) {
    deafened.value = bool;
  }
}
