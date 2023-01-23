import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi/feature/enums/MessageEnums.dart';
import 'package:hi/feature/providers/MessageReplyProvider.dart';
import 'package:hi/utils/ColorsCustom.dart';
import 'package:hi/widgets/DisplayTextImageGif.dart';
import 'package:voice_message_package/voice_message_package.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: ColorsCustom.secondaryDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReply!.isMe ? 'Me' : 'Opponent',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              GestureDetector(
                child: const Icon(Icons.close_rounded, color: Colors.white),
                onTap: () => cancelReply(ref),
              )
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(100, 22, 44, 33),
              ),
              child: messageReply.messageEnum == MessageEnum.audio
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      child: VoiceMessage(
                        audioSrc: messageReply.message,
                        me: true,
                        meBgColor: Colors.cyan,
                      ),
                    )
                  : DisplayTextImageGif(
                      message: messageReply.message,
                      type: messageReply.messageEnum,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
