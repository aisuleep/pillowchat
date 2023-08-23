// ignore_for_file: prefer_const_constructors,

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillowchat/widgets/home_channels.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/controllers/panels.dart';
import 'package:pillowchat/controllers/servers.dart';
import 'package:pillowchat/custom/hole_puncher.dart';
import 'package:pillowchat/models/client.dart';
import 'package:pillowchat/models/user.dart';
import 'package:pillowchat/pages/friends.dart';
import 'package:pillowchat/pages/home/discover.dart';
import 'package:pillowchat/pages/notifications.dart';
import 'package:pillowchat/pages/server/chat_page.dart';
import 'package:pillowchat/pages/home/welcome.dart';
import 'package:pillowchat/pages/server/members_page.dart';
import 'package:pillowchat/pages/server/server_page.dart';
import 'package:pillowchat/pages/settings/settings.dart';
import 'package:pillowchat/themes/ui.dart';

class Panels extends StatelessWidget {
  const Panels({super.key, required server});
  // State<Panels> createState() => PanelsState();
// }

// class PanelsState extends State<Panels> {
  // initial page
  // 1 for homescreen first login
  static int selectedPanel = 1;
  // depends on initial page is left/right -> offset/-offset

  // initial page position
  // 0 for homescreen first login
  static double panelLeft = 0;
  static bool fromLeft = true;

  static slideLeft(BuildContext context) {
    PanelController.controller.changePanelLeft(-offSet);
    PanelController.controller.changePanel(2);
    PanelController.controller.isFromLeft(true);
  }

  static slideRight(BuildContext context) {
    PanelController.controller.changePanelLeft(offSet);
    PanelController.controller.changePanel(0);
    PanelController.controller.isFromLeft(true);
  }

  static slideToMiddle(BuildContext context) {
    PanelController.controller.changePanelLeft(0);
    PanelController.controller.changePanel(1);
    PanelController.controller.isFromLeft(true);
  }

  static double offSet = 0;
  @override
  Widget build(BuildContext context) {
    offSet = MediaQuery.of(context).size.width / 1.1;
    return Obx(
      () => Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: offSet,
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! < 0) {
                      // if (kDebugMode) print('servers right');
                      // setState(() {
                      // panelLeft = 0;
                      // selectedPanel = 1;
                      // _fromLeft = true;
                      // });
                      PanelController.controller.changePanel(0);
                      PanelController.controller.changePanelLeft(1);
                      PanelController.controller.isFromLeft(true);
                      if (kDebugMode) print(fromLeft);
                    } else if (details.primaryVelocity! > 0) {
                      // if (kDebugMode) print('servers left');

                      // do nothing if right-handed mode
                    }
                  },
                  child: Visibility(
                    visible:
                        PanelController.controller.selectedPanel.value != 2,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      child:
                          // ClientController.controller.home.value == false?
                          ServersPage(
                              server:
                                  ServerController.controller.selected.value)
                      // : HomeServerPage()
                      ,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (ClientController.controller.home.value == false ||
              Home.index >= 0)
            Row(
              children: [
                Expanded(child: SizedBox()),
                SizedBox(
                  width: offSet,
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! < 0) {
                        // if (kDebugMode) print('right');

                        // do nothing if right-handed mode
                      } else if (details.primaryVelocity! > 0) {
                        // if (kDebugMode) print('left');
                        // setState(() {
                        // panelLeft = 0;
                        // selectedPanel = 1;
                        // _fromLeft = false;
                        // });
                        PanelController.controller.changePanel(0);
                        PanelController.controller.changePanelLeft(1);
                        PanelController.controller.isFromLeft(false);
                        if (kDebugMode) print(fromLeft);
                      }
                    },
                    child: Visibility(
                      visible: PanelController.controller.selectedPanel.value ==
                              2 ||
                          PanelController.controller.selectedPanel.value == 1 &&
                              PanelController.controller.fromLeft.value ==
                                  false,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        child: MembersPage(),
                        // Panel 3
                      ),
                    ),
                  ),
                ),
              ],
            ),
          Obx(
            () => AnimatedPositioned(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 200),
              left: PanelController.controller.panelLeft.value,
              child: GestureDetector(
                onTap: () {
                  if (PanelController.controller.selectedPanel.value == 0) {
                    // setState(() {
                    // panelLeft = 0;
                    // selectedPanel = 1;
                    // _fromLeft = true;
                    // });

                    PanelController.controller.changePanelLeft(0);
                    PanelController.controller.changePanel(1);
                    PanelController.controller.isFromLeft(true);
                  }
                  if (PanelController.controller.selectedPanel.value == 2) {
                    // setState(() {
                    // panelLeft = 0;
                    // selectedPanel = 1;
                    // _fromLeft = false;
                    // });
                    PanelController.controller.changePanelLeft(0);
                    PanelController.controller.changePanel(1);

                    PanelController.controller.isFromLeft(false);
                  }
                },
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    // if being swiped left

                    if (PanelController.controller.selectedPanel.value == 1 &&
                            ClientController.controller.home.value == false ||
                        Home.index >= 0) {
                      // if (kDebugMode) print('chat left');
                      // setState(() {
                      // panelLeft = -offSet;
                      // selectedPanel = 2;
                      // _fromLeft = true;
                      // });

                      PanelController.controller.changePanelLeft(-offSet);
                      PanelController.controller.changePanel(2);
                      PanelController.controller.isFromLeft(true);
                    } else {
                      // if (kDebugMode) print('ucs left');
                      // setState(() {
                      // panelLeft = 0;
                      // selectedPanel = 1;
                      // _fromLeft = true;
                      // });

                      PanelController.controller.changePanelLeft(0);
                      PanelController.controller.changePanel(1);
                      PanelController.controller.isFromLeft(true);
                    }
                  } else if (details.primaryVelocity! > 0) {
                    // if being swiped right

                    if (PanelController.controller.selectedPanel.value == 1) {
                      // if (kDebugMode) print('chat right');
                      // setState(() {
                      // panelLeft = offSet;
                      // selectedPanel = 0;
                      // _fromLeft = false;
                      // });
                      PanelController.controller.changePanelLeft(offSet);
                      PanelController.controller.changePanel(0);

                      PanelController.controller.isFromLeft(false);
                    } else {
                      if (kDebugMode) print('unfocus chat swipe right');
                      panelLeft = 0;
                      selectedPanel = 1;
                      fromLeft = false;
                      PanelController.controller.changePanelLeft(0);
                      PanelController.controller.changePanel(1);

                      PanelController.controller.isFromLeft(false);
                    }
                  }
                },
                child: Transform(
                  transform: Matrix4.translationValues(0, 0, 0),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ClientController.controller.home.value == false
                        ? ChatPage()
                        : ServerController.controller.homeIndex.value == -4
                            ? FriendsPage()
                            : ServerController.controller.homeIndex.value == -3
                                ? WelcomePage()
                                : ServerController.controller.homeIndex.value ==
                                        -2
                                    ? DiscoverPage()
                                    : ServerController
                                                .controller.homeIndex.value >=
                                            -1
                                        ? ChatPage()
                                        : ChatPage(),

                    // animations to panels
                    //  switch (Home.index) {case 0 : WelcomePage() break; case 1: FriendsPage() break; }
                    // child: Stack(
                    //   children: [
                    //     Center(
                    //       child: Text(
                    //         "chat",
                    //       ),
                    //     ),
                    //     Align(
                    //       alignment: Alignment.topLeft,
                    //       child: IconButton(
                    //         icon: Icon(Icons.home),
                    //         onPressed: () {
                    //           if (selectedPanel == 1) {
                    // setState(() {
                    //               panelLeft = offSet;
                    //               selectedPanel = 0;
                    //               _fromLeft = false;
                    // });
                    //           } else if (selectedPanel == 0) {
                    // setState(() {
                    //               panelLeft = 0;
                    //               selectedPanel = 1;
                    //               _fromLeft = true;
                    // });
                    //           }
                    //         },
                    //       ),
                    //     ),
                    //     Align(
                    //       alignment: Alignment.topRight,
                    //       child: IconButton(
                    //         icon: Icon(Icons.people),
                    //         onPressed: () {
                    //           if (selectedPanel == 1) {
                    // setState(() {
                    //               panelLeft = -offSet;
                    //               selectedPanel = 2;
                    //               _fromLeft = true;
                    // });
                    //           } else if (selectedPanel == 2) {
                    // setState(() {
                    //               panelLeft = 0;
                    //               selectedPanel = 1;
                    //               _fromLeft = false;
                    // });
                    //           }
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              transform: PanelController.controller.panelLeft.value == offSet
                  ? Matrix4.translationValues(0, 0, 0)
                  : Matrix4.translationValues(0, 100, 0),
              curve: Curves.ease,
              duration: Duration(milliseconds: 300),
              child: BottomNavigationBar(
                  onTap: (value) {
                    if (value == 0) {}
                    if (value == 1) {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => NotificationsPage(),
                        ),
                      );
                    }
                    if (value == 2) {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => FriendsPage(),
                        ),
                      );
                    }
                    if (value == 3) {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => SettingsPage(),
                        ),
                      );
                    }
                  },
                  currentIndex: 0,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat),
                      label: 'chat',
                      tooltip: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notifications),
                      label: 'mentions',
                      tooltip: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.emoji_people),
                      label: 'friends',
                      tooltip: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Visibility(
                        visible: ClientController.controller.logged.value &&
                            ClientController
                                    .controller.selectedUser.value.avatar !=
                                null,
                        child: UserIcon(
                          user: ClientController.controller.selectedUser.value,
                          radius: 36,
                          hasStatus: true,
                        ),
                      ),
                      label: 'settings',
                      tooltip: '',
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

class UserIcon extends StatelessWidget {
  UserIcon({
    super.key,
    required this.hasStatus,
    required this.radius,
    this.user,
    this.onPressed,
    this.url,
  });
  final User? user;
  final double radius;
  final RxString? url;
  final bool hasStatus;
  final VoidCallback? onPressed;
  final RxBool? isHovered = false.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => MouseRegion(
        onEnter: (event) {
          isHovered!.value = true;
        },
        onExit: (event) {
          isHovered!.value = false;
        },
        child: Stack(
          children: [
            ClipPath(
              clipper: hasStatus
                  ? HolePuncher(
                      dimension: 18,
                      offset: 1.15,
                    )
                  : null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  IconBorder.radius.toDouble(),
                ),
                child: Image.network(
                  width: radius,
                  height: radius,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                  !ClientController.controller.home.value
                      ? url?.value ?? Client.getAvatar(user!)
                      : Client.getAvatar(user!),
                ),
              ),
            ),
            if (hasStatus)
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: user!.status.presence == 'Online'
                      ? Dark.online.value
                      : user!.status.presence == 'Idle'
                          ? Dark.away.value
                          : user!.status.presence == 'Busy'
                              ? Dark.dnd.value
                              : user!.status.presence == 'Focus'
                                  ? Dark.focus.value
                                  : Dark.offline.value,
                  radius: radius * 0.12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
