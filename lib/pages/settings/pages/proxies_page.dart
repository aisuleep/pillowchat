import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/message/parts/message_components.dart';
import 'package:pillowchat/themes/ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProxiesPage extends StatelessWidget {
  const ProxiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Column(
                  children: List.generate(
                    ClientController.controller.proxies.length,
                    (index) {
                      Masquerade proxy =
                          ClientController.controller.proxies[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ProxyTile(proxy: proxy),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProxyTile extends StatelessWidget {
  ProxyTile({
    super.key,
    required this.proxy,
  });
  final Masquerade proxy;
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerIcon = TextEditingController();
  final RxBool isEditing = false.obs;
  final RxBool isEditingIcon = false.obs;
  final SharedPreferences? prefs = Client.prefs;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        color: Dark.background.value,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  EditableUserIcon(
                    controller: controllerIcon,
                    isEditing: isEditingIcon,
                    proxy: proxy.obs,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: CircleAvatar(
                            radius: 10,
                            foregroundColor: Colors.teal,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: EditableText(
                            isEditing: isEditing,
                            controller: controller,
                            proxy: proxy.obs,
                            text: proxy.name,
                            toChange: "name",
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Visibility(
                                visible: proxy.avatar !=
                                    ClientController.controller.selectedUser
                                        .value.avatar?.value.id,
                                child: IconButton(
                                    onPressed: () {
                                      int index = ClientController
                                          .controller.proxies
                                          .indexWhere(
                                              (proxies) => proxies == proxy);

                                      ClientController.controller
                                          .removeProxy(proxy, index);
                                      if (ClientController
                                              .controller.selectedProxy.value ==
                                          proxy) {
                                        ClientController.controller.selectProxy(
                                            ClientController
                                                .controller.proxies[0]);
                                      }
                                      Client.prefs?.remove('proxyIndex');
                                    },
                                    icon: const Icon((Icons.remove))),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditableUserIcon extends StatelessWidget {
  EditableUserIcon({
    super.key,
    required this.isEditing,
    required this.proxy,
    this.url,
    required this.controller,
  });
  final TextEditingController controller;
  final RxBool isEditing;
  final Rx<Masquerade> proxy;
  final RxString? url;

  void startEditing() {
    isEditing.value = true;
  }

  void stopEditing() {
    isEditing.value = false;
  }

  final SharedPreferences? prefs = Client.prefs;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => proxy.value.avatar != '' && !isEditing.value
          ? InkWell(
              onTap: () {
                startEditing();
              },
              onFocusChange: (value) {
                stopEditing();
              },
              child: UserIcon(
                  url: proxy.value.avatar.obs, hasStatus: false, radius: 48),
            )
          : isEditing.value
              ? EditableText(
                  controller: controller,
                  isEditing: isEditing,
                  proxy: proxy,
                  text: proxy.value.avatar,
                  toChange: "avatar",
                )
              : InkWell(
                  onTap: () {
                    startEditing();
                  },
                  onFocusChange: (value) {
                    stopEditing();
                  },
                  child: CircleAvatar(
                    foregroundColor: Dark.secondaryBackground.value,
                    child: const Icon(Icons.image),
                  ),
                ),
    );
  }
}

class EditableText extends StatelessWidget {
  const EditableText({
    super.key,
    required this.controller,
    required this.isEditing,
    required this.proxy,
    required this.text,
    required this.toChange,
  });
  final RxBool isEditing;
  final Rx<Masquerade> proxy;
  final TextEditingController controller;
  final String text;
  final String toChange;

  void startEditing() {
    Future.delayed(Duration.zero, () {
      isEditing.value = true;
      switch (toChange) {
        case 'name':
          controller.text = proxy.value.name;
          break;

        case 'avatar':
          controller.text = proxy.value.avatar;
          break;
      }
    });
  }

  void stopEditing() {
    isEditing.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => isEditing.value
          ? IntrinsicWidth(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                onSubmitted: (_) {
                  switch (toChange) {
                    case 'name':
                      proxy.value.name = controller.text;
                      break;

                    case 'avatar':
                      proxy.value.avatar = controller.text;
                      break;
                  }

                  stopEditing();
                },
                onTapOutside: (event) {
                  switch (toChange) {
                    case 'name':
                      proxy.value.name = controller.text;
                      break;

                    case 'avatar':
                      proxy.value.avatar = controller.text;
                      break;
                  }

                  stopEditing();
                },
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextButton(
                  onPressed: () {
                    if (!isEditing.value) {
                      startEditing();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.teal.withOpacity(0.5)),
                    alignment: Alignment.centerLeft,
                  ),
                  child: Text(proxy.value.name))),
    );
  }
}
