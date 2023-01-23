import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi/Models/MessageModel.dart';
import 'package:hi/Models/WorldWideModel.dart';
import 'package:hi/feature/controller/AuthController.dart';
import 'package:hi/feature/enums/MessageEnums.dart';
import 'package:hi/feature/providers/MessageReplyProvider.dart';
import 'package:hi/feature/repositery/ChatRepository.dart';

import '../../Models/ChatContactModel.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContactModel>> chatContacts() {
    return chatRepository.getChatContact();
  }

  Stream<List<WorldWideModel>> getAllUserWorldWide() {
    return chatRepository.getAllUsers();
  }

  void deleteChatContact(BuildContext context, String recieverUserId, int deleteId) {
    chatRepository.deleteParticularChatContact(recieverUserId, context, deleteId);
  }

  void deleteMessage(String recieverUserId, String messageId){
    chatRepository.deleteSingleMessage(recieverUserId, messageId);
  }

  Stream<List<MessageModel>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
              context: context,
              text: text,
              recieverUserId: recieverUserId,
              senderUser: value!,
              messageReply: messageReply),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String recieverUserId,
    MessageEnum messageEnum,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            recieverUserId: recieverUserId,
            senderUserData: value!,
            messageEnum: messageEnum,
            ref: ref,
            messageReply: messageReply,
          ),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(context, recieverUserId, messageId);
  }

/*void sendGIFMessage(
    BuildContext context,
    String gifUrl,
    String recieverUserId,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendGIFMessage(
            context: context,
            gifUrl: gifUrl,
            recieverUserId: recieverUserId,
            senderUser: value!,
          ),
        );
  }*/
}
