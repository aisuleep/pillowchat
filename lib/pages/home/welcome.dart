// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pillowchat/widgets/headers/chat_header.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ChatHeader(
              leading: Icons.home,
            ),
            Expanded(
              child: ListView(
                children: [
                  Center(
                    child: Text(
                      'Welcome to',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      // works but makes transition weird on hold swipe?
                      minVerticalPadding: 0,
                      leading: Icon(Icons.add_circle),
                      title: Text('Create a group'),
                      subtitle: Text('desc'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        //todo: make group creation work
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      minVerticalPadding: 0,
                      leading: Icon(Icons.explore),
                      title: Text('Discover !'),
                      subtitle: Text('desc'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(Icons.arrow_circle_right),
                      title: Text('Go to testers server'),
                      subtitle: Text('desc'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      minVerticalPadding: 0,
                      leading: Icon(Icons.add_circle),
                      title: Text('Give feedback'),
                      subtitle: Text('desc'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(Icons.monetization_on),
                      title: Text('Donate to Revolt'),
                      subtitle: Text('desc'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Open settings'),
                      subtitle: Text('desc'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
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
