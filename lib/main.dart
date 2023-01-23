import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hi/common/widgets/loader.dart';
import 'package:hi/feature/controller/AuthController.dart';
import 'package:hi/screens/ConfirmStatusScreen.dart';
import 'package:hi/screens/Drawer/DrawerWidget.dart';
import 'package:hi/screens/ErrorScreen.dart';
import 'package:hi/screens/MobileChatScreen.dart';
import 'package:hi/screens/MobileLayoutScreen.dart';
import 'package:hi/screens/MobileNo.dart';
import 'package:hi/screens/OtpScreen.dart';
import 'package:hi/screens/SelectContactScreen.dart';
import 'package:hi/screens/SplashScreen.dart';
import 'package:hi/screens/StatusShowScreen.dart';
import 'package:hi/screens/UserImageScreen.dart';
import 'package:hi/screens/UserInformation.dart';

//Notification code
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
  playSound: true,
  enableLights: true,
  enableVibration: true,
  showBadge: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  if (Platform.operatingSystem == 'android') {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCo4oTl6rpOeAS6uWEa9rVwNlwzSbsnItA",
        appId: "1:397627824627:android:fb3899f27813f954749a86",
        messagingSenderId: '1',
        projectId: "com.parth.hi",
      ),
    );
  } else {
    debugPrint('MyLogData -- other system');
  }

  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/MobileNo': (context) => const MobileNo(),
          '/Home': (context) => const Home(),
          '/OtpScreen': (context) => const OtpScreen(),
          '/UserInformation': (context) => const UserInformation(),
          '/SelectContactScreen': (context) => const SelectContactScreen(),
          '/MobileLayoutScreen': (context) => const MobileLayoutScreen(),
          '/MobileChatScreen': (context) => const MobileChatScreen(),
          '/ConfirmStatuesScreen': (context) => const ConfirmStatuesScreen(),
          '/StatuesShowScreen': (context) => const StatuesShowScreen(),
          '/DrawerWidget': (context) => const DrawerWidget(),
          '/UserImageScreen': (context) => const UserImageScreen(),
        },
      ),
    ),
  );
}

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();

    //THIS IS FOR FOREGROUND MESSAGES
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    //THIS IS FOR ON MESSAGES TAP
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {

      }
    });
  }

  checkConnection() async {
    try {
      await InternetAddress.lookup('www.google.com');
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: 'No Internet Connection', backgroundColor: Colors.black87);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const UserInformation();
              }
              return const DrawerWidget();
            },
            error: (error, stackTrace) {
              return ErrorScreen(error: error.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}