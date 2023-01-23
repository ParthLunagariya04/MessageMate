import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi/screens/Drawer/MenuItemm.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuItems {
  static const one =
      MenuItemm(title: 'My Friends', icon: Icons.supervised_user_circle_sharp);
  static const two = MenuItemm(title: 'Profile', icon: Icons.edit_note_rounded);
  static const three =
      MenuItemm(title: 'Contacts', icon: Icons.contacts_rounded);
  static const four =
      MenuItemm(title: 'Close to me', icon: Icons.monitor_heart_rounded);
  static const five = MenuItemm(title: 'Global', icon: Icons.chat_rounded);

  static const all = <MenuItemm>[
    one,
    two,
    three,
    four,
    five,
  ];
}

class ManuPage extends StatefulWidget {
  final MenuItemm currentItem;
  final ValueChanged<MenuItemm> onSelectedItem;

  const ManuPage({
    Key? key,
    required this.currentItem,
    required this.onSelectedItem,
  }) : super(key: key);

  @override
  State<ManuPage> createState() => _ManuPageState();
}

class _ManuPageState extends State<ManuPage> {
  var userName;
  var userImage;
  var imageMemory;
  SharedPreferences? pref;

  Future<void> prefData() async {
    pref = await SharedPreferences.getInstance();
    userName = pref!.getString('userName');
    userImage = pref!.getString('userImage');
    imageMemory = base64Decode(userImage);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Colors.indigo,
        body: SafeArea(
          child: FutureBuilder(
            future: prefData(),
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Colors.cyan,
                        width: 3,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/UserImageScreen',
                          arguments: {
                            'myImg': imageMemory,
                            'code': 1,
                          },
                        );
                      },
                      child: Hero(
                        tag: 'image',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: FadeInImage(
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                            placeholder: const AssetImage('assets/avatar.jpg'),
                            image: MemoryImage(imageMemory),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    toBeginningOfSentenceCase(userName).toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.actor(
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                      fontSize: 23,
                    ),
                  ),
                  const SizedBox(height: 50),
                  ...MenuItems.all.map(buildMenuItem).toList(),
                  const Spacer(flex: 1),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0x33f6d365), Color(0x338ddad5)],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'from',
                              style: GoogleFonts.carroisGothic(fontSize: 13),
                            ),
                            Text(
                              'PARTH 🏹',
                              style: GoogleFonts.carroisGothicSc(
                                  fontSize: 16, letterSpacing: 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(MenuItemm item) => Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ListTileTheme(
          selectedColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            selected: widget.currentItem == item,
            selectedTileColor: Colors.black26,
            minLeadingWidth: 20,
            leading: Icon(item.icon),
            title: Text(item.title),
            onTap: () => widget.onSelectedItem(item),
          ),
        ),
      );
}
