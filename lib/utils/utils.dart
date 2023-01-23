import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi/feature/controller/ChatController.dart';
import 'package:hi/utils/ColorsCustom.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> pickImageFromCamera(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return video;
}

/*Future<GiphyGif?> pickGIF(BuildContext context) async {
  /// LB9v3srqeFdwFentzUE8jSSrEGkBFkuk
  //GiphyGif? gif;
  try {
    //gif = await Giphy.getGif(context: context, apiKey: 'LB9v3srqeFdwFentzUE8jSSrEGkBFkuk');
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  //return gif;
}*/

void dialogProgress(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child:
            LoadingAnimationWidget.beat(color: ColorsCustom.primary, size: 50),
      );
    },
  );
}

Future<void> sendPushNotification(
    String fcmToken, String name, String msg) async {
  try {
    final body = {
      "to": fcmToken,
      "notification": {
        "title": name, //our name should be send
        "body": msg,
        "android_channel_id": "high_importance_channel"
      },
// "data": {
//   "some_data": "User ID: ${me.id}",
// },
    };

    var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=AAAAXJR3GfM:APA91bHCUYXNrVt2bcP4qC4YW5bEDyXWEC1VO7rt_-HqPFjg-1emFFDuKKeBLJ2NRPRXu3YYVyU6qbeyV_0oIwdrkMzhMYueVOqiRUZ-8ZeJ5aHl7QN19RsmNDe1v67_TOSgY8cQpC93'
        },
        body: jsonEncode(body));
    debugPrint('MyLogData Response status: ${res.statusCode}');
    debugPrint('MyLogData Response body: ${res.body}');
  } catch (e) {
    debugPrint('MyLogData sendPushNotificationE: $e');
  }
}

void mobileLayoutScreenDialog({
  required WidgetRef ref,
  required BuildContext context,
  required String name,
  required String contactId,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetAnimationDuration: const Duration(seconds: 1),
        backgroundColor: ColorsCustom.secondaryDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Text(
              name,
              style: GoogleFonts.kalam(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 10, left: 10, bottom: 8, top: 10),
              child: Text(
                'This will remove all the messages from cloud. You won\'t be able to get it back !!..',
                maxLines: 2,
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 5),
            TextButton(
              style:
                  TextButton.styleFrom(minimumSize: const Size.fromHeight(20)),
              onPressed: () {
                ///deleting user.......................................................
                ref
                    .read(chatControllerProvider)
                    .deleteChatContact(context, contactId, 1);
                Navigator.pop(context);
              },
              child: const Text(
                'Delete User',
                style: TextStyle(fontSize: 20, color: Colors.orangeAccent),
              ),
            ),
            TextButton(
              style:
                  TextButton.styleFrom(minimumSize: const Size.fromHeight(20)),
              onPressed: () {
                ///deleting chats / messages.......................................................
                ref
                    .read(chatControllerProvider)
                    .deleteChatContact(context, contactId, 2);
                Navigator.pop(context);
                debugPrint("MyLogData clear messages!!");
              },
              child: const Text(
                'Clear Messages',
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(20),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 20, color: Colors.cyan),
              ),
            ),
          ],
        ),
      );
    },
  );
}
