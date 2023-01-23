import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi/Models/ChatContactModel.dart';
import 'package:hi/Models/MessageModel.dart';
import 'package:hi/Models/UserModel.dart';
import 'package:hi/Models/WorldWideModel.dart';
import 'package:hi/common/CommonFirebaseStorageRepository.dart';
import 'package:hi/feature/enums/MessageEnums.dart';
import 'package:hi/feature/providers/MessageReplyProvider.dart';
import 'package:hi/utils/utils.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<ChatContactModel>> getChatContact() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .orderBy('timeSent')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContactModel> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContactModel.fromMap(document.data());
        var userdata = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userdata.data()!);
        contacts.add(
          ChatContactModel(
              name: user.name,
              profilePic: user.profilePic,
              contactId: chatContact.contactId,
              timeSent: chatContact.timeSent,
              lastMessage: chatContact.lastMessage),
        );
      }
      return contacts;
    });
  }

  Stream<List<WorldWideModel>> getAllUsers() {
    return firestore.collection('users').snapshots().map((event) {
      List<WorldWideModel> allUsers = [];
      for (var document in event.docs) {
        allUsers.add(
          WorldWideModel.fromMap(
            document.data(),
          ),
        );
      }
      return allUsers;
    });
  }

  void deleteParticularChatContact(
      String recieverUserId, BuildContext context, int deleteId) async {
    //here 1 is for deleting user and it's messages and 2 is for only deleting messages
    if (deleteId == 1) {
      ///this is delete user contact list data
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .delete()
          .then((_) {
        debugPrint('MyLogData firebase delete operation Success');
        showSnackBar(context: context, content: 'user data deleted');
      }).catchError((error) {
        debugPrint('MyLogData firebase delete error -- $error');
        showSnackBar(
            context: context,
            content: 'Something went wrong, please try again.');
      });

      ///this is delete user's all messages
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      }).catchError((error) {
        debugPrint('MyLogData firebase delete error -- $error');
      });
    } else {
      ///this is delete user's all messages
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
        showSnackBar(context: context, content: 'Messages deleted.');
      }).catchError((error) {
        debugPrint('MyLogData firebase delete error -- $error');
        showSnackBar(
            context: context,
            content: 'Something went wrong, please try again.');
      });
    }
  }

  void deleteSingleMessage(
    String recieverUserId,
    String messageId,
  ) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageId)
        .delete()
        .then((_) {
      debugPrint('MyLogData msg delete Success');
      //showSnackBar(context: context, content: 'user data deleted');
    }).catchError((error) {
      debugPrint('MyLogData msg delete error -- $error');
    });
  }

  Stream<List<MessageModel>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var document in event.docs) {
        messages.add(MessageModel.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDataToContactSubCollection(
    UserModel senderUserData,
    UserModel recieverUsersData,
    String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {
    ///reciever chat contact
    var recieverChatContact = ChatContactModel(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          recieverChatContact.toMap(),
        );

    ///sender chat contact
    var senderChatContact = ChatContactModel(
      name: recieverUsersData.name,
      profilePic: recieverUsersData.profilePic,
      contactId: recieverUsersData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  Future<void> _saveMessageToMessageSubCollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required recieverUserName,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUserName,
    required String recieverUsername,
  }) async {
    final message = MessageModel(
      senderId: auth.currentUser!.uid,
      recieverId: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUserName
              : recieverUsername,
      repliedMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );

    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;
      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactSubCollection(
        senderUser,
        recieverUserData,
        text,
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubCollection(
        recieverUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        recieverUserName: recieverUserData.name,
        userName: senderUser.name,
        messageReply: messageReply,
        recieverUsername: recieverUserData.name,
        senderUserName: senderUser.name,
      ).then((value) => sendPushNotification(
          recieverUserData.fcmToken, senderUser.name, text));
    } catch (e) {
      debugPrint('MyLodData sendTextMessage error -- ${e.toString()}');
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storageFileToFirebase(
              'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
              file);

      UserModel recieverUserData;
      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      String contactMessage;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMessage = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMessage = '📹 Video';
          break;
        case MessageEnum.audio:
          contactMessage = '🎶 Audio';
          break;
        case MessageEnum.gif:
          contactMessage = 'GIF';
          break;
        default:
          contactMessage = 'GIF';
      }

      _saveDataToContactSubCollection(
        senderUserData,
        recieverUserData,
        contactMessage,
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubCollection(
        recieverUserId: recieverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUserData.name,
        recieverUserName: recieverUserData.name,
        messageType: messageEnum,
        messageReply: messageReply,
        recieverUsername: recieverUserData.name,
        senderUserName: senderUserData.name,
      ).then((value) => sendPushNotification(
          recieverUserData.fcmToken, senderUserData.name, contactMessage));
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  /*Future<void> checkMessageSeen(
    BuildContext context,
    String isSeen,
    String recieverUserId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(isSeen)
          .get();

    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }*/

/*void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String recieverUserId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;
      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactSubCollection(
        senderUser,
        recieverUserData,
        'GIF',
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubCollection(
        recieverUserId: recieverUserId,
        text: gifUrl,
        timeSent: timeSent,
        messageType: MessageEnum.gif,
        messageId: messageId,
        recieverUserName: recieverUserData.name,
        userName: senderUser.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }*/
}
