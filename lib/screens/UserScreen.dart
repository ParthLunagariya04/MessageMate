import 'dart:convert';

import 'package:circular_rotation/circular_rotation.dart';
import 'package:circular_rotation/constants/dimens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi/utils/ColorsCustom.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/ChatContactModel.dart';
import '../common/widgets/loader.dart';
import '../feature/controller/ChatController.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  final List<Widget> _firstCircleImages = [];
  final List<Widget> _thirdCircleImages = [];

  //final List<Widget> _thirdCircleImages = [];
  String? userName;
  var userImage;
  Uint8List? imageMemory;
  late SharedPreferences pref;

  String? name;
  String? image;
  DateTime? time;

  @override
  void initState() {
    //generateImages();
    super.initState();
    prefData();
  }

  Future<void> prefData() async {
    pref = await SharedPreferences.getInstance();
    userName = pref.getString('userName');
    userImage = pref.getString('userImage');
    imageMemory = base64Decode(userImage);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsCustom.secondaryDark2,
      body: StreamBuilder<List<ChatContactModel>>(
        stream: ref.watch(chatControllerProvider).chatContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          snapshot.data!.sort((a, b) => a.timeSent.compareTo(b.timeSent));
          for (int i = 0; i < snapshot.data!.length; i++) {
            name = snapshot.data![i].name;
            image = snapshot.data![i].profilePic;
            time = snapshot.data![i].timeSent;
            debugPrint('MyLogData -- name : $name, time : $time');

            if (i < 3) {
              _thirdCircleImages.add(
                _GetProfile(name: name!, image: image!, radius: 20),
              );
            } else if (i >= 3 && i < 6) {
              _firstCircleImages.add(
                _GetProfile(name: name!, image: image!, radius: 20),
              );
            }
          }
          return Theme(
            data: ThemeData.dark(),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    decoration: BoxDecoration(
                      color: const Color(0x8001c9f1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'My Close Friends',
                      style: GoogleFonts.actor(
                          color: Colors.cyanAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: CircularRotation(
                      circularRotationProperty: CircularRotationModel(
                        /*firstCircleStrokeWidth: 2,
                        firstCircleStrokeColor: _firstCircleImages.isEmpty
                            ? Colors.transparent
                            : Color(0x3304befe),
                        thirdCircleStrokeColor: Color(0x338ddad5),
                        thirdCircleStrokeWidth: 2,*/
                        //visibleSecondCircle: false,
                        defaultCircleStrokeColor: Colors.transparent,
                        startAnimation: true,
                        repeatAnimation: true,

                        ///outer circle
                        firstCircleAnimationDuration: 15000,

                        ///inner circle
                        //secondCircleAnimationDuration: 15000,

                        ///inner circle
                        thirdCircleAnimationDuration: 20000,

                        centerWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap:
                                  CircularRotation.eitherStartOrStopAnimation,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: ColorsCustom.secondaryDark2,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.lightGreen,
                                    width: 3,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: FadeInImage(
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        const AssetImage('assets/avatar.jpg'),
                                    image: MemoryImage(imageMemory!),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 130,
                              child: Text(
                                textAlign: TextAlign.center,
                                toBeginningOfSentenceCase(userName!).toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            )
                          ],
                        ),
                        curve: Curves.linear,
                        firstCircleWidgets: _firstCircleImages,
                        //secondCircleWidgets: _secondCircleImages,
                        thirdCircleWidgets: _thirdCircleImages,
                        thirdCircleRadians: Dimens.radius_xsmall,
                        //secondCircleRadians: Dimens.radius_small,
                        firstCircleRadians: Dimens.radius_normal,
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 30, right: 20, left: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0x4dc40ef9),
                    ),
                    child: const Text(
                      'This is the latest feature that tells who You\'re closer to. Here are two orbits with '
                      'people arranged in their class according to their latest conversion with you. ',
                      style: TextStyle(color: Colors.cyanAccent, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GetProfile extends StatelessWidget {
  const _GetProfile({
    required this.name,
    required this.image,
    this.radius = Dimens.radius_normal,
    Key? key,
  }) : super(key: key);
  final String name;
  final String image;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(image, width: 40, height: 40, fit: BoxFit.cover),
        ),
        SizedBox(
          width: 50,
          child: Center(
            child: Text(
              name,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/*class _CircularImage extends StatelessWidget {
  const _CircularImage({required this.image, required this.radius, Key? key})
      : super(key: key);
  final String image;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(image),
      backgroundColor: Colors.transparent,
    );
  }
}*/
