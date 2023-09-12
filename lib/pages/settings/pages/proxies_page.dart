import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/message/parts/message_components.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/themes/ui.dart';

class ProxiesPage extends StatelessWidget {
  const ProxiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                children: [
                  ProxyTile(
                    proxy: Masquerade(
                        ClientController.controller.selectedUser.value.name,
                        '',
                        null),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Proxies"),
                  ),
                  Column(
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
                ],
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
  final RxBool isEditing = false.obs;

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
                  UserIcon(
                    user: ClientController.controller.selectedUser.value,
                    radius: 48,
                    hasStatus: false,
                  ),
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
                      // style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              ClientController.controller.removeProxy(proxy);
                            },
                            icon: const Icon((Icons.remove)))
                      ],
                    ),
                  )
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
  const EditableUserIcon({
    super.key,
    required this.user,
  });
  final User user;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: UserIcon(user: user, hasStatus: false, radius: 30),
    );
  }
}

class EditableText extends StatelessWidget {
  const EditableText({
    super.key,
    required this.controller,
    required this.isEditing,
    required this.proxy,
  });
  final RxBool isEditing;
  final Rx<Masquerade> proxy;
  final TextEditingController controller;

  void startEditing() {
    Future.delayed(Duration.zero, () {
      isEditing.value = true;
      controller.text = proxy.value.name;
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
                  stopEditing();
                },
                onTapOutside: (event) {
                  proxy.value.name = controller.text;
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
