import 'package:get/get.dart';
import 'package:pillowchat/models/message/parts/message_components.dart';
import 'package:pillowchat/models/user.dart';

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

  // INIT CONTROLLER
  static final ClientController controller = Get.put(ClientController());

  updateLogStatus(bool isLogged) {
    logged.value = isLogged;
  }

  selectUser(User user) {
    selectedUser.value = user;
  }

  addProxy(Masquerade proxy) {
    proxies.add(proxy);
  }

  removeProxy(Masquerade proxy) {
    proxies.removeWhere((proxies) => proxies.name == proxy.name);
  }
}
