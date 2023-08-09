import 'package:flutter/material.dart';
import 'package:pillowchat/components/headers/tab_header.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/themes/ui.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TabHeader(
              leading: Icons.menu,
              onPressed: () {
                Panels.slideRight(context);
              },
              title: 'Discover',
              icon: Icons.explore,
              color: Dark.foreground.value,
            ),
          ],
        ),
      ),
    );
  }
}
