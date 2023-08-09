import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/themes/ui.dart';

class StatusPage extends StatelessWidget {
  StatusPage({super.key});
  final RxString originalContent =
      (ClientController.controller.selectedUser.value.profile?.content ?? '')
          .obs;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = originalContent.value;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  children: [
                    // STATUS

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "STATUS".toUpperCase(),
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
                        child: const Column(children: []),
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
                    // EDIT CUSTOM STATUS

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "CUSTOM STATUS TEXT".toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
