import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi/utils/ColorsCustom.dart';
import 'package:intl/intl.dart';

import '../Models/UserModel.dart';
import '../feature/repositery/AuthRepositery.dart';
import '../widgets/BottomChatField.dart';
import '../widgets/ChatList.dart';

class MobileChatScreen extends ConsumerWidget {
  const MobileChatScreen({
    Key? key,
  }) : super(key: key);

  /* void makeCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).makeCall(
      context,
      name,
      uid,
      profilePic,
      isGroupChat,
    );
  }
*/
  //var data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      backgroundColor: ColorsCustom.primary,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        shadowColor: Colors.transparent,
        backgroundColor: ColorsCustom.primary,
        leading: Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
          decoration: BoxDecoration(
            color: const Color(0x592b2250),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        title: StreamBuilder<UserModel>(
          stream: ref.read(authRepositoryProvider).userData(data['uid']),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Loading...'),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, bottom: 4, top: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0x6643e97b),
                              Color(0x6638f9d7),
                            ],
                          )
                          //color: const Color(0x477cff00),
                          ),
                      child: const Text(
                        'Loading..',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  toBeginningOfSentenceCase(data['name']).toString(),
                  style: const TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, bottom: 4, top: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0x6643e97b),
                            Color(0x6638f9d7),
                          ],
                        )
                        //color: const Color(0x477cff00),
                        ),
                    child: Text(
                      snapshot.data!.isOnline ? '🕊️ online' : '😴 offline',
                      style: TextStyle(
                        fontSize: 13,
                        color: snapshot.data!.isOnline
                            ? Colors.lightGreenAccent
                            : Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
        centerTitle: true,
        actions: [
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/UserImageScreen',
                  arguments: {
                    'myImg': data['networkImage'],
                    'code': 2,
                  },
                );
              },
              child: Hero(
                tag: 'image',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: data['networkImage'] == null
                      ? const FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: AssetImage('assets/avatar.jpg'),
                          image: AssetImage('assets/avatar.jpg'),
                        )
                      : FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: const AssetImage('assets/avatar.jpg'),
                          image: NetworkImage(
                            data['networkImage'],
                          ),
                        ),
                ),
              ),
            ),
          )
          /*IconButton(
            onPressed: () */ /*=> makeCall(ref, context)*/ /* {},
            icon: const Icon(Icons.video_call),
          ),*/
          /*IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),*/
          /*IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),*/
        ],
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          color: ColorsCustom.secondaryDark2,
          child: Column(
            children: [
              Expanded(
                child: ChatList(
                  recieverUserId: data['uid'],
                  //isGroupChat: isGroupChat,
                ),
              ),
              BottomChatField(
                recieverUserId: data['uid'],
                //isGroupChat: isGroupChat,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
