import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi/Models/MessageModel.dart';
import 'package:intl/intl.dart';

import '../common/widgets/loader.dart';
import '../feature/controller/ChatController.dart';
import '../feature/enums/MessageEnums.dart';
import '../feature/providers/MessageReplyProvider.dart';
import 'MyMessageCard.dart';
import 'SenderMessage.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;

  //final bool isGroupChat;
  const ChatList({
    Key? key,
    required this.recieverUserId,
    //required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    FirebaseMessaging.instance.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.unsubscribeFromTopic('chat');
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    ref.read(messageReplyProvider.notifier).update(
          (state) => MessageReply(
            message,
            isMe,
            messageEnum,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream:
          ref.read(chatControllerProvider).chatStream(widget.recieverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });

        return CustomScrollView(
          //reverse: true,
          //shrinkWrap: true,
          controller: messageController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: snapshot.data!.length,
                (context, index) {
                  //below reversedIndex is for start a first message from bottom while list is empty
                  //final reversedIndex = snapshot.data!.length - 1 - index;
                  final messageData = snapshot.data![index];
                  var timeSent =
                      DateFormat("h:mm a").format(messageData.timeSent);

                  if (!messageData.isSeen &&
                      messageData.recieverId ==
                          FirebaseAuth.instance.currentUser!.uid) {
                    ref.read(chatControllerProvider).setChatMessageSeen(
                          context,
                          widget.recieverUserId,
                          messageData.messageId,
                        );
                  }

                  if (messageData.senderId ==
                      FirebaseAuth.instance.currentUser!.uid) {
                    return InkWell(
                      onTap: () {
                        messageData.type == MessageEnum.image
                            ? Navigator.pushNamed(
                                context,
                                '/UserImageScreen',
                                arguments: {
                                  'myImg': messageData.text,
                                  'code': 3
                                },
                              )
                            : null;
                      },
                      onLongPress: () {
                        ref.read(chatControllerProvider).deleteMessage(
                            messageData.recieverId, messageData.messageId);
                      },
                      child: MyMessageCard(
                        message: messageData.text,
                        date: timeSent,
                        type: messageData.type,
                        repliedText: messageData.repliedMessage,
                        userName: messageData.repliedTo,
                        repliedMessageType: messageData.repliedMessageType,
                        onLeftSwipe: () => onMessageSwipe(
                            messageData.text, true, messageData.type),
                        isSeen: messageData.isSeen,
                      ),
                    );
                  }
                  return InkWell(
                    onTap: () {
                      messageData.type == MessageEnum.image
                          ? Navigator.pushNamed(
                              context,
                              '/UserImageScreen',
                              arguments: {'myImg': messageData.text, 'code': 3},
                            )
                          : null;
                    },
                    onLongPress: () {
                      ref.read(chatControllerProvider).deleteMessage(
                          messageData.senderId, messageData.messageId);
                    },
                    child: SenderMessageCard(
                      message: messageData.text,
                      date: timeSent,
                      type: messageData.type,
                      username: messageData.repliedTo,
                      repliedMessageType: messageData.repliedMessageType,
                      onRightSwipe: () => onMessageSwipe(
                        messageData.text,
                        false,
                        messageData.type,
                      ),
                      repliedText: messageData.repliedMessage,
                      /*type: messageData.type */
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
