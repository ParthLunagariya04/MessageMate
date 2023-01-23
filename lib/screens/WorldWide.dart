import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi/Models/WorldWideModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/ColorsCustom.dart';

class WorldWide extends ConsumerStatefulWidget {
  const WorldWide({Key? key}) : super(key: key);

  @override
  ConsumerState<WorldWide> createState() => _WorldWideState();
}

class _WorldWideState extends ConsumerState<WorldWide>
    with SingleTickerProviderStateMixin {
  final List<Color> colorGradiant = [];
  final random = Random();
  var userName;
  bool search = true;
  final _searchController = TextEditingController();
  var onSearchList = [];
  List<WorldWideModel> cntList = [];

  @override
  void initState() {
    super.initState();
    addColorToArray();
  }

  void addColorToArray() {
    colorGradiant.add(const Color(0x33a18cd1));
    colorGradiant.add(const Color(0x33fbc2eb));
    colorGradiant.add(const Color(0x33f6d365));
    colorGradiant.add(const Color(0x33a1c4fd));
    colorGradiant.add(const Color(0x3396e6a1));
    colorGradiant.add(const Color(0x33f093fb));
    colorGradiant.add(const Color(0x33f5576c));
    colorGradiant.add(const Color(0x334facfe));
    colorGradiant.add(const Color(0x33764ba2));
    colorGradiant.add(const Color(0x336a11cb));
    colorGradiant.add(const Color(0x33c471f5));
    colorGradiant.add(const Color(0x336f86d6));
    colorGradiant.add(const Color(0x330ba360));
    colorGradiant.add(const Color(0x33f77062));
    colorGradiant.add(const Color(0x33f09819));
    colorGradiant.add(const Color(0x338ddad5));
    colorGradiant.add(const Color(0x3304befe));
  }

  void prefData() async {
    var pref = await SharedPreferences.getInstance();
    userName = pref.getString('userName');
  }

  @override
  Widget build(BuildContext context) {
    prefData();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsCustom.primary,
        automaticallyImplyLeading: false,
        /*leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),*/
        title: search
            ? const Text('Global Users')
            : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      onSearchList = cntList
                          .where((element) => element.name
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                  controller: _searchController,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0x3396e6a1),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          search = true;
                          _searchController.text = '';
                        });
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                    ),
                    hintText: 'Search...',
                    hintStyle:
                        const TextStyle(color: Colors.white, fontSize: 20),
                    prefixIcon:
                        const Icon(Icons.search_rounded, color: Colors.white),
                  ),
                ),
              ),
        actions: [
          search
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          search = false;
                        });
                      },
                      icon: const Icon(Icons.search_rounded),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert_rounded))
                  ],
                )
              : Container()
        ],
      ),
      backgroundColor: ColorsCustom.secondaryDark,
      body: Center(
        child: Text(
          'Coming Soon',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.righteous(
              color: Colors.greenAccent,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
      ),

      // getting all users from firebase
      /*StreamBuilder<List<WorldWideModel>>(
          stream: ref.watch(chatControllerProvider).getAllUserWorldWide(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.length ?? 10,
                itemBuilder: (context, index) {
                  return MobileLayoutLoadingEffect();
                },
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var chatContactData = snapshot.data![index];
                if (chatContactData.name != userName) {
                  debugPrint('MyLogData name -- ${chatContactData.name} ');
                  //debugPrint('MyLogData userName -- ${userName} ');
                }

                return InkWell(
                  //focusColor: Colors.lightGreenAccent,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/MobileChatScreen',
                      arguments: {
                        'uid': chatContactData.uid,
                        'name': chatContactData.name,
                        'networkImage': chatContactData.profilePic,
                      },
                    );
                  },
                  child: WorldWideUserContainer(
                    gradiant: [
                      colorGradiant[random.nextInt(16)],
                      colorGradiant[random.nextInt(16)]
                    ],
                    name: chatContactData.name,
                    networkImage: chatContactData.profilePic,
                  ),
                );
              },
            );
          }),*/
    );
  }
}
