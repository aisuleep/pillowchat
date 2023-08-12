// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:get/get.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/custom/overlapping_panels.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/pages/login.dart';
import 'package:pillowchat/pages/server/chat_page.dart';
import 'package:pillowchat/pages/server/server_page.dart';
import 'package:pillowchat/pages/settings/pages/profile_page.dart';
import 'package:pillowchat/pages/settings/pages/sessions_page.dart';
import 'package:pillowchat/pages/settings/pages/status_page.dart';
import 'package:pillowchat/pages/settings/settings.dart';
import 'package:pillowchat/themes/ui.dart';

import 'pages/home/discover.dart';
import 'pages/home/welcome.dart';

void main() {
  // initMeeduPlayer();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static showPopup({required Widget widget, required BuildContext context}) {
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 400,
                    height: 400,
                    color: Dark.background.value,
                    child: widget,
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Dark.background.value,
        systemNavigationBarColor: Dark.background.value,
      ),
    );
    return MaterialApp(
      title: 'A Flutter Client',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Dark.primaryBackground.value,
          dragHandleColor: Dark.foreground.value,
        ),
        splashColor: Colors.transparent,

        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStatePropertyAll(
            Dark.accent.value,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Dark.foreground.value),
          border: InputBorder.none,
          filled: true,
          fillColor: Dark.primaryBackground.value,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Dark.accent.value,
        ),
        // primarySwatch: Colors.red,
        scaffoldBackgroundColor: Dark.primaryBackground.value,
        appBarTheme: AppBarTheme(
          color: Dark.primaryBackground.value,
        ),
        textTheme: TextTheme(
          labelLarge: TextStyle(
            color: Dark.foreground.value,
          ),
          bodyLarge: TextStyle(
            color: Dark.foreground.value,
          ),
          bodyMedium: TextStyle(
            color: Dark.foreground.value,
          ),
          titleMedium: TextStyle(
            color: Dark.foreground.value,
          ),
          titleSmall: TextStyle(
            color: Dark.foreground.value,
          ),
        ),
        buttonTheme: const ButtonThemeData(splashColor: Colors.transparent),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Dark.accent.value,
                ),
                textStyle: MaterialStatePropertyAll(
                  TextStyle(
                    fontSize: ClientController.controller.fontSize.value,
                    foreground: Paint()..color = Dark.foreground.value,
                  ),
                ))),
        listTileTheme: ListTileThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titleTextStyle:
              TextStyle(fontSize: ClientController.controller.fontSize.value),
          tileColor: Colors.transparent,
          textColor: Dark.foreground.value,
          iconColor: Dark.secondaryForeground.value,
          visualDensity: const VisualDensity(
            vertical: -4,
          ),
        ),
        iconTheme: const IconThemeData(
          // ignore: use_full_hex_values_for_flutter_colors
          color: Color(0xfffc8c8c8),
          size: 25,
        ),
        primaryIconTheme: IconThemeData(
          color: Dark.foreground.value,
          size: 25,
        ),
        dividerColor: Colors.transparent,

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 0,
          selectedIconTheme: const IconThemeData(size: 28),
          unselectedIconTheme: const IconThemeData(size: 28),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Dark.background.value,
          selectedItemColor: Dark.accent.value,
          unselectedItemColor: Dark.foreground.value,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
        fontFamilyFallback: [],
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/': (context) => Client.isMobile
            ? Panels(
                server: ServerController.controller.selected.value,
              )
            : const Panel(),
        '/settings': (context) => const SettingsPage(),
        '/settings/profile': (context) => SettingsSubPage(
              page: ProfilePage(),
              title: 'Profile',
              leading: Icons.close,
              isSubpage: true,
            ),
        '/settings/status': (context) => SettingsSubPage(
              page: StatusPage(),
              title: 'Status',
              leading: Icons.close,
              isSubpage: true,
            ),
        '/settings/sessions': (context) => const SettingsSubPage(
              page: SessionsPage(),
              title: 'Sessions',
              leading: Icons.close,
              isSubpage: true,
            ),

        //   TODO: MAKE ROUTES FOR WEB (SERVERS/CHANNELS ETC.)
      },
    );
  }
}

class Panel extends StatelessWidget {
  const Panel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            constraints: const BoxConstraints(
              maxWidth: 300,
              minWidth: 150,
            ),
            child: ServersPage(
              server: ClientController.controller.selectedUser.value.homeServer,
            ),
          ),
          Expanded(
            flex: 4,
            child: Obx(() => ClientController.controller.home.value == false ||
                    ServerController.controller.homeIndex.value >= -1
                ? const ChatPage()
                : ServerController.controller.homeIndex.value == -3
                    ? const WelcomePage()
                    : const DiscoverPage()),
          ),
        ],
      ),
    );
  }
}
