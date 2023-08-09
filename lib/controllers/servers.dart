import 'package:get/get.dart';
import 'package:pillowchat/models/channel/channels.dart';
import 'package:pillowchat/models/members.dart';
import 'package:pillowchat/models/message/message.dart';
import 'package:pillowchat/models/server.dart';
import 'package:pillowchat/models/unreads.dart';
import 'package:pillowchat/models/user.dart';

class ServerController extends GetxController {
  RxList<Server> serversList = <Server>[].obs;
  Rx<Server> selected = Rx<Server>(Server('', 0, '', '', '', '', [], []));
  RxList<Categories> categoriesList = <Categories>[].obs;
  Rx<User> userSelected = User(id: '', name: '').obs;
  // RxList<Member> membersList = <Member>[].obs;
  RxInt serverIndex = 0.obs;
  RxInt homeIndex = (-3).obs;
  RxList<Channel> dmsList = <Channel>[].obs;
  RxList<Unread> unreadsList = <Unread>[].obs;
  // final RxBool logged = false.obs;

  static final ServerController controller = Get.put(ServerController());

  updateServerList(List<Server> servers) {
    serversList.assignAll(servers);
    // ignore: avoid_print
    print(serversList.length);
  }

  updateMessageList(
    int index,
    List<Message> messages,
    List<User> users,
    List<Member> members,
  ) {
    selected.value.channels[index].messages.addAll(messages);
    selected.value.channels[index].messages.refresh();

    selected.value.channels[index].users.addAll(users);
    selected.value.channels[index].users.refresh();

    selected.value.channels[index].members.addAll(members);
    selected.value.channels[index].members.refresh();
  }

  void updateUserList(List<User> users) {
    selected.value.users.assignAll(users);
  }

  void updateMemberList(List<Member> members) {
    selected.value.members.assignAll(members);
  }

  updateDmsList(List<Channel> dms) {
    dmsList.assignAll(dms);
  }

  updateUnreadsList(List<Unread> unreads) {
    unreadsList.assignAll(unreads);
  }

  void updateCategoryList(List<Categories> categories) {
    categoriesList.assignAll(categories);
  }

  void changeServer(int index) {
    serverIndex.value = index;
  }

  void changeDm(int index) {
    homeIndex.value = index;
  }

  void setProfile(Profile profile, int index) {
    selected.value.users[index].profile = profile;
  }
}
