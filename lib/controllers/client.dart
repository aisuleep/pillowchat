import 'dart:convert';

import 'package:get/get.dart';
import 'package:pillowchat/models/message/parts/message_components.dart';
import 'package:pillowchat/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientController extends GetxController {
  final RxBool logged = false.obs;
  final RxString token = "".obs;
  final RxBool home = true.obs;
  final RxBool desktopMode = false.obs;
  final RxBool shareTypingEvents = true.obs;
  final RxBool compactMode = true.obs;
  final RxDouble fontSize = 14.0.obs;
  final RxInt time = 0.obs;
  Rx<User> selectedUser = Rx<User>(User(id: '', name: ''));
  RxList<Masquerade> proxies = <Masquerade>[].obs;
  Rx<Masquerade> selectedProxy = Masquerade('', '', null).obs;

  // INIT CONTROLLER
  static final ClientController controller = Get.put(ClientController());

  updateLogStatus(bool isLogged) {
    logged.value = isLogged;
  }

  selectUser(User user) {
    selectedUser.value = user;
  }

  selectProxy(Masquerade proxy) {
    selectedProxy.value = proxy;
  }

  addProxy(Masquerade proxy, int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    proxies.add(proxy);
    await prefs.setString('proxy$index',
        jsonEncode(Masquerade(proxy.name, proxy.avatar, proxy.color).toJson()));
  }

  removeProxy(Masquerade proxy, int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    proxies.remove(proxy);
    await prefs.remove('proxy$index');
  }
}
