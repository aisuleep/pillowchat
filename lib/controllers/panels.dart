import 'package:get/get.dart';

class PanelController extends GetxController {
  // Rx<Channel> selected = Channel(id: '', name: '', type: '').obs;
  RxInt selectedPanel = 1.obs;
  RxDouble panelLeft = 0.0.obs;
  RxBool fromLeft = false.obs;

  static final PanelController controller = Get.put(PanelController());

  void changePanel(int selection) {
    selectedPanel.value = selection;
  }

  void changePanelLeft(double left) {
    panelLeft.value = left;
  }

  void isFromLeft(bool bool) {
    fromLeft.value = bool;
  }
}
