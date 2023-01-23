import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hi/utils/ColorsCustom.dart';
import 'package:hi/widgets/DisplayTextImageGif.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../feature/enums/MessageEnums.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageType;
  final bool isSeen;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.userName,
    required this.repliedMessageType,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      iconColor: Colors.white,
      animationDuration: const Duration(milliseconds: 200),
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// this is general audio message
              type == MessageEnum.audio
                  ? Padding(
                      padding:
                          const EdgeInsets.only(right: 15, bottom: 5, top: 5),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        child: VoiceMessage(
                          audioSrc: message,
                          me: true,
                          meBgColor: Colors.purple,
                        ),
                      ),
                    )

                  /// this is rest of other messages
                  : Container(
                      //elevation: 1,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(3)),
                        color: ColorsCustom.secondaryDark,
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(3),
                            topLeft: Radius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///this whole code for reply
                            if (isReplying) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, bottom: 10, right: 10),
                                child: Text(
                                  userName,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.lightGreen),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(100, 22, 44, 33),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),

                                    ///replayed audio message
                                    child: repliedMessageType ==
                                            MessageEnum.audio
                                        ? ClipRRect(
                                            borderRadius: const BorderRadius
                                                    .only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20)),
                                            child: VoiceMessage(
                                              audioSrc: message,
                                              me: true,
                                              meBgColor: Colors.cyan,
                                            ),
                                          )

                                        ///replayed rest of others message
                                        : DisplayTextImageGif(
                                            message: repliedText,
                                            type: repliedMessageType,
                                          ),
                                  ),
                                ),
                              ),
                            ],

                            ///this code for general
                            DisplayTextImageGif(
                              message: message,
                              type: type,
                            ),
                          ],
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(date,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10)),
                    const SizedBox(width: 5),
                    Icon(
                      isSeen ? Icons.done_all_rounded : Icons.done_rounded,
                      size: 15,
                      color: isSeen ? Colors.blueAccent : Colors.white,
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
