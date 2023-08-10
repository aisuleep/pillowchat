import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/pages/login.dart';
import 'package:pillowchat/themes/markdown.dart';
import 'package:pillowchat/themes/ui.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final RxString originalContent =
      ClientController.controller.selectedUser.value.profile?.content!.obs ??
          ''.obs;

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = originalContent.value;

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
                  // PREVIEW PROFILE

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "preview".toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      color: Dark.background.value,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              if (ClientController.controller.selectedUser.value
                                      .profile?.background !=
                                  null)
                                Positioned.fill(
                                  child: Image.network(
                                    "$autumn/backgrounds/${ClientController.controller.selectedUser.value.profile?.background?.id}",
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.medium,
                                  ),
                                ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black,
                                        Colors.black.withOpacity(0.5),
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    UserIcon(
                                      user: ClientController
                                          .controller.selectedUser.value,
                                      radius: 48,
                                      hasStatus: true,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "@${ClientController.controller.selectedUser.value.name}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            constraints: const BoxConstraints(minHeight: 150),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    "information".toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Dark.secondaryForeground.value,
                                    ),
                                  ),
                                ),
                                MarkdownBody(
                                  softLineBreak: true,
                                  extensionSet: markdown.extensionSet,
                                  builders: markdown.builders,
                                  styleSheet: markdown.styleSheet,
                                  data: originalContent.value,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      height: 4,
                      thickness: 2,
                      color: Dark.foreground.value,
                    ),
                  ),
                  // EDIT PROFILE COMPONENTS

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "avatar".toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    IconBorder.radius.value),
                                child: Image.network(
                                  "$autumn/avatars/${ClientController.controller.selectedUser.value.avatar}",
                                  height: 60,
                                  filterQuality: FilterQuality.medium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "background".toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Stack(
                                children: [
                                  Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Dark.background.value,
                                      border: Border.all(
                                          color: Dark.foreground.value),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.add_photo_alternate),
                                    ),
                                  ),
                                  if (ClientController.controller.selectedUser
                                          .value.profile?.background !=
                                      null)
                                    Positioned.fill(
                                      child: Image.network(
                                        "$autumn/backgrounds/${ClientController.controller.selectedUser.value.profile?.background?.id}",
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "information".toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(minHeight: 80),
                        color: Dark.background.value,
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  color: Dark.primaryBackground.value,
                                  child: TextFormField(
                                    controller: controller,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      filled: false,
                                      contentPadding: EdgeInsets.all(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "Supports Markdown.",
                          style: TextStyle(
                            color: Dark.accent.value,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Button(
                      text: "SAVE",
                      onTap: () {
                        if (originalContent.value != controller.text) {
                          Profile.editDescription(
                            controller.text,
                            context,
                          );
                          Navigator.pop(context);
                        } else {
                          // ignore:
                          if (kDebugMode) print('no changes');
                        }
                      },
                      color: Dark.accent.value,
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
