import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:hi/screens/Drawer/ManuPage.dart';
import 'package:hi/screens/Drawer/MenuItemm.dart';
import 'package:hi/screens/MobileLayoutScreen.dart';
import 'package:hi/screens/SelectContactScreen.dart';
import 'package:hi/screens/UserInformation.dart';
import 'package:hi/screens/UserScreen.dart';
import 'package:hi/screens/WorldWide.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  MenuItemm currentItem = MenuItems.one;

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      borderRadius: 40,
      angle: -10,
      slideWidth: MediaQuery.of(context).size.width * 0.6,
      showShadow: true,
      drawerShadowsBackgroundColor: Colors.lightBlueAccent,
      style: DrawerStyle.defaultStyle,
      mainScreen: getScreen(),
      mainScreenTapClose: true,
      isRtl: true,
      menuBackgroundColor: Colors.indigo,
      menuScreen: Builder(builder: (context) {
        return ManuPage(
          currentItem: currentItem,
          onSelectedItem: (item) {
            setState(() {
              currentItem = item;
            });
            ZoomDrawer.of(context)!.close();
          },
        );
      }),
    );
  }

  // getIndex(){
  //   IndexedStack(
  //     index: 4,
  //     //overlap: true,
  //     children: const [
  //       MobileLayoutScreen(),
  //       UserInformation(),
  //       SelectContactScreen(),
  //       UserScreen(),
  //       WorldWide()
  //     ],
  //   );
  // }

  getScreen() {
    switch (currentItem) {
      case MenuItems.one:
        return const MobileLayoutScreen();
      case MenuItems.two:
        return const UserInformation();
      case MenuItems.three:
        return const SelectContactScreen();
      case MenuItems.four:
        return const UserScreen();
      case MenuItems.five:
        return const WorldWide();
    }
  }
}
