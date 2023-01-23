import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi/feature/controller/AuthController.dart';
import 'package:hi/utils/ColorsCustom.dart';
import 'package:hi/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInformation extends ConsumerStatefulWidget {
  const UserInformation({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends ConsumerState<UserInformation> {
  var nameController = TextEditingController();
  File? image;
  SharedPreferences? pref;
  late FirebaseMessaging _messaging;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  Future<void> selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  Future<void> storeUserData() async {
    String name = nameController.text.trim();

    final bytes = image!.readAsBytesSync();
    var imageString = base64Encode(bytes);

    if (name.isNotEmpty) {
      _messaging.getToken().then((token) async {
        print(" MyLogData fcmToken ==> $token");

        ref
            .read(authControllerProvider)
            .saveUserDataTofirebase(context, name, image, token!);
        pref = await SharedPreferences.getInstance();
        pref!.setString('userName', nameController.text);
        pref!.setString('userImage', imageString);
        pref!.setBool('user', true);
        pref!.setString('fcmToken', token);

        //await api.localStorage.write('notificationToken', '$token');
        //ref.read(chatControllerProvider).
      });
    }
  }

  /*Future<void> prefData() async {

    userName = pref!.getString('userName');
    userImage = pref!.getString('userImage');
    imageMemory = base64Decode(userImage);
    debugPrint('MyLodData userName -- $userName');
    debugPrint('MyLodData userImage -- $userImage');
    debugPrint('MyLodData imageMemory -- $imageMemory');
  }*/

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _messaging = FirebaseMessaging.instance;

    return Scaffold(
      backgroundColor: ColorsCustom.secondaryDark,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Stack(
                  children: [
                    image == null
                        ? const CircleAvatar(
                            backgroundImage: AssetImage('assets/avatar.jpg'),
                            radius: 50,
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(image!),
                            radius: 50,
                          ),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: IconButton(
                        onPressed: () {
                          selectImage();
                        },
                        icon: const Icon(Icons.camera_alt_rounded,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SizedBox(
                        width: size.width * 0.75,
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                left: 10, top: 0, bottom: 0),
                            label: const Text('Enter your name'),
                            labelStyle: const TextStyle(color: Colors.white),
                            floatingLabelStyle:
                                const TextStyle(color: Colors.blueAccent),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Colors.blueAccent)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        storeUserData();
                      },
                      icon: const Icon(Icons.done_rounded, color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
