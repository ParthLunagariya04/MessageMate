

///this code was belong to MOBILELAYOUTSCREEN ( While long press on user container to show dialog )
/*showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      insetAnimationDuration:
                                          const Duration(seconds: 1),
                                      backgroundColor:
                                          ColorsCustom.secondaryDark,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 20),
                                          Text(
                                            chatContactData.name,
                                            style: GoogleFonts.kalam(
                                                fontSize: 22,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                right: 10,
                                                left: 10,
                                                bottom: 8,
                                                top: 10),
                                            child: Text(
                                              'This will remove all the messages from cloud. You won\'t be able to get it back !!..',
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                minimumSize:
                                                    const Size.fromHeight(20)),
                                            onPressed: () {
                                              ///deleting user.......................................................
                                              ref
                                                  .read(chatControllerProvider)
                                                  .deleteChatContact(
                                                      context,
                                                      chatContactData.contactId,
                                                      1);
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Delete User',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.orangeAccent),
                                            ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                minimumSize:
                                                    const Size.fromHeight(20)),
                                            onPressed: () {
                                              ///deleting chats / messages.......................................................
                                              ref
                                                  .read(chatControllerProvider)
                                                  .deleteChatContact(
                                                      context,
                                                      chatContactData.contactId,
                                                      2);
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Clear Messages',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.green),
                                            ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              minimumSize:
                                                  const Size.fromHeight(20),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(25),
                                                  bottomRight:
                                                      Radius.circular(25),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.cyan),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );*/
/*ref
                                    .read(chatControllerProvider)
                                    .deleteChatContact(
                                        context, chatContactData.contactId);*/

///this code is belong from BOTTOMCHATFIELD Widget ( this code is to show dialog items )
/*InkWell(
                              onTap: () {},
                              child: const DialogItem(
                                  icon: Icons.location_on_rounded,
                                  name: 'Location',
                                  color: Color(0xfff093fb)),
                            ),
                            InkWell(
                              onTap: () {},
                              child: const DialogItem(
                                  icon: Icons.contacts_rounded,
                                  name: 'Contacts',
                                  color: Color(0xff3d077e)),
                            ),*/

///this code belong from main.dart ( notification code )
/*void showNotification() {
    debugPrint('MyLogData notification');
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }*/

// For handling notification when the app is in terminated state
/*checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print('helllooooooooo');
      var temp = json.decode(initialMessage.data['data']);
      PushNotification notification = PushNotification(
        title: temp['title'],
        body: temp['message'],
      );
      setState(() {
        //_notificationInfo = notification;
        //_totalNotifications++;
      });
    }
  }*/

/*class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}*/
