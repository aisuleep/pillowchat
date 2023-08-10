// ignore_for_file:

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/server.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/themes/ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static final emailController = TextEditingController();
  static final passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // ignore: unused_element
    getLoginState() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString("token") != null) {
        Client.token = prefs.getString("token")!;
        ClientController.controller.updateLogStatus(true);
        if (prefs.getBool('logged') == true) {
          // GET SAVED USER

          if (prefs.getString("user") != null) {
            Map<String, dynamic> userMap = jsonDecode(prefs.getString("user")!);
            User user = User.fromJson(userMap);
            ClientController.controller.selectUser(user);
          }

          // GET SAVED SERVERS

          if (prefs.getString("servers") != null) {
            List<dynamic> serversMap = jsonDecode(prefs.getString("servers")!);
            var servers = serversMap.map((s) => Server.fromJson(s)).toList();
            ServerController.controller.serversList.value = servers;
          }
        }
      }
    }

    // getLoginState();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Text(
                        "Welcome to !",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 20),
                      child: AutofillGroup(
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            fillColor: Dark.background.value,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 20),
                      child: AutofillGroup(
                        child: TextField(
                          keyboardType: TextInputType.visiblePassword,
                          autofillHints: const [AutofillHints.password],
                          controller: passController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            fillColor: Dark.background.value,
                          ),
                          obscureText: true,
                        ),
                      ),
                    ),
                    Button(
                      text: 'Login',
                      onTap: () {
                        Client.login(context);
                      },
                      color: Dark.accent.value,
                    ),
                  ],
                ),
              ),
            ),
            Button(
              text: 'Sign up',
              onTap: () {},
              color: Dark.background.value,
            )
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
  });
  final String text;
  final dynamic onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        height: 40,
        child: Material(
          color: color,
          child: InkWell(
              onTap: onTap,
              child: Center(
                  child: Text(
                text,
                style: TextStyle(
                  color: Dark.foreground.value,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ))),
        ),
      ),
    );
  }
}
