import 'package:flutter/material.dart';
import 'package:hi/widgets/DisplayTextImageGif.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../feature/enums/MessageEnums.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
  }) : super(key: key);
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;

    return SwipeTo(
      iconColor: Colors.white,
      animationDuration: const Duration(milliseconds: 200),
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              type == MessageEnum.audio
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 15, bottom: 5, top: 5),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        child: VoiceMessage(
                          audioSrc: message,
                          me: true,
                          meBgColor: Colors.cyan,
                        ),
                      ),
                    )
                  : Container(
                      //elevation: 1,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            topLeft: Radius.circular(3)),
                        gradient: LinearGradient(
                          colors: [Color(0xff6a11cb), Color(0xff2575fc)],
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            topLeft: Radius.circular(3)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///this whole code for reply
                            if (isReplying) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 8, bottom: 8, right: 10),
                                child: Text(
                                  username,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.lightGreenAccent),
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
                                              meBgColor: Colors.lightBlue,
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
                            DisplayTextImageGif(
                              message: message,
                              type: type,
                            ),
                          ],
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(date,
                    style: const TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
