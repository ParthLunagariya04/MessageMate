import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi/Models/ChatContactModel.dart';
import 'package:hi/common/widgets/UserContainer.dart';
import 'package:hi/common/widgets/loader.dart';
import 'package:hi/feature/controller/AuthController.dart';
import 'package:hi/feature/controller/ChatController.dart';
import 'package:hi/utils/ColorsCustom.dart';
import 'package:hi/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/StatusModel.dart';
import '../feature/controller/StatusController.dart';
import '../widgets/MobileLayoutLoadingEffect.dart';
import '../widgets/StatusLoading.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  var userName;
  var userImage;
  var imageMemory;
  late Animation animation;
  late AnimationController animController;
  final List<Color> colorGradiant = [];
  final random = Random();

  //this is for time
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    prefData();
    animController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    animation = Tween(begin: 0.0, end: 600.0)
        .animate(CurvedAnimation(parent: animController, curve: Curves.linear));
    animation.addListener(() {
      setState(() {});
    });
    animController.forward();
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

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  Future<void> prefData() async {
    var pref = await SharedPreferences.getInstance();
    userName = pref.getString('userName');
    userImage = pref.getString('userImage');
    imageMemory = base64Decode(userImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsCustom.primary,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FutureBuilder(
              future: prefData(),
              builder: (context, snapshot) {
                /*if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Center(
                        child: Text(
                      'connection state waiting',
                      style: TextStyle(color: Colors.white),
                    )),
                  );
                }*/
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0x809be15d),
                                    Color(0x8000e3ae)
                                  ],
                                )
                                //color: const Color(0x477cff00),
                                ),
                            child: Text(
                              greeting(),
                              style: GoogleFonts.pacifico(
                                  letterSpacing: 1,
                                  color: Colors.cyanAccent,
                                  fontSize: 10),
                            ),
                          ),
                          Text(
                            userName == ''
                                ? 'name is empty'
                                : toBeginningOfSentenceCase(userName)
                                    .toString(),
                            style: GoogleFonts.pacifico(
                                letterSpacing: 1,
                                color: Colors.cyanAccent,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          //Navigator.pushNamed(context, '/UserInformation');
                          ZoomDrawer.of(context)!.toggle();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: imageMemory == null
                              ? const FadeInImage(
                                  height: 45.0,
                                  width: 45.0,
                                  fit: BoxFit.cover,
                                  placeholder: AssetImage('assets/avatar.jpg'),
                                  image: AssetImage('assets/avatar.jpg'),
                                )
                              : FadeInImage(
                                  height: 45.0,
                                  width: 45.0,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      const AssetImage('assets/avatar.jpg'),
                                  image: MemoryImage(imageMemory),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            InkWell(
                              onTap: () async {
                                File? pickImage =
                                    await pickImageFromGallery(context);
                                if (pickImage != null) {
                                  Navigator.pushNamed(
                                      context, '/ConfirmStatuesScreen',
                                      arguments: {
                                        'imageFile': pickImage,
                                      });
                                }
                              },
                              child: FutureBuilder(
                                future: prefData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircleAvatar(
                                      radius: 30,
                                      child: Loader(),
                                    );
                                  }
                                  return CircleAvatar(
                                      backgroundImage:
                                          MemoryImage(imageMemory!),
                                      radius: 30);
                                },
                              ),
                            ),
                            const Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: ColorsCustom.primary,
                                radius: 10,
                                child: Icon(Icons.add_circle,
                                    color: Colors.black, size: 20),
                              ),
                            )
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child:
                              Text('Me', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),

                  ///this is for horizontal statuses
                  FutureBuilder<List<StatusModel>>(
                    future:
                        ref.read(statusControllerProvider).getStatus(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Expanded(
                          child: SizedBox(
                            width: 200,
                            height: 90,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data?.length ?? 10,
                              itemBuilder: (context, index) {
                                return StatusLoading();
                              },
                            ),
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        debugPrint('MyLogData no data found');
                        return const Center(child: Text('no data found'));
                      }
                      return Expanded(
                        child: SizedBox(
                          width: 200,
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var statusData = snapshot.data![index];

                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/StatuesShowScreen',
                                      arguments: {
                                        'statusData': statusData.photoUrl,
                                        'userName': statusData.userName,
                                        'profilePic': statusData.profilePic,
                                        'createdAt': statusData.createdAt,
                                      });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.lightGreen,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      padding: const EdgeInsets.all(2.5),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              statusData.profilePic),
                                          radius: 27),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(statusData.userName,
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.only(top: 5),
                decoration: const BoxDecoration(
                  color: ColorsCustom.secondaryDark,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: StreamBuilder<List<ChatContactModel>>(
                    stream: ref.watch(chatControllerProvider).chatContacts(),
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
                      return SingleChildScrollView(
                        child: ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var chatContactData = snapshot.data![index];
                            return InkWell(
                              onLongPress: () {
                                mobileLayoutScreenDialog(
                                  context: context,
                                  name: chatContactData.name,
                                  contactId: chatContactData.contactId,
                                  ref: ref,
                                );
                              },
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/MobileChatScreen',
                                  arguments: {
                                    'uid': chatContactData.contactId,
                                    'name': chatContactData.name,
                                    'networkImage': chatContactData.profilePic,
                                    'time': chatContactData.timeSent
                                  },
                                );
                              },
                              child: UserContainer(
                                  gradiant: [
                                    colorGradiant[random.nextInt(15)],
                                    colorGradiant[random.nextInt(15)]
                                  ],
                                  name: chatContactData.name,
                                  lastMessage: chatContactData.lastMessage,
                                  networkImage: chatContactData.profilePic,
                                  time: chatContactData.timeSent),
                            );
                          },
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsCustom.primary,
        onPressed: () {
          Navigator.pushNamed(context, '/SelectContactScreen');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
