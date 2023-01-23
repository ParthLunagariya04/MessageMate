import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hi/utils/ColorsCustom.dart';
import 'package:hi/utils/DialogItems.dart';
import 'package:hi/widgets/MessageReplyPreview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../feature/controller/ChatController.dart';
import '../feature/enums/MessageEnums.dart';
import '../feature/providers/MessageReplyProvider.dart';
import '../utils/utils.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;

  const BottomChatField({
    Key? key,
    required this.recieverUserId,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();

  //late AnimationController controller;

  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;

  //bool isShowEmojiContainer = false;
  bool isRecording = false;

  ///this is use for hide/show keyboard
  //FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.recieverUserId,
            //widget.isGroupChat,
          );
      setState(() {
        _messageController.text = '';
        isShowSendButton = false;
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    print("MyLogData Original Image Fie: ${file.lengthSync()}");

    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.recieverUserId,
          messageEnum,
        );
  }

  /*void imageCompress(File file) async {
    final compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      '${file.path}/img_${DateTime.now().millisecondsSinceEpoch}.jpg',
      quality: 50,
    );
    print("MyLogData compressed Image File Size: ${compressedImageFile!.lengthSync()}");
  }*/

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectImageCamera() async {
    File? image = await pickImageFromCamera(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideoGallery() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  /*void selectGIF() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      ref.read(chatControllerProvider).sendGIFMessage(
            context,
            gif.url,
            widget.recieverUserId,
          );
    }
  }*/

  /*void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }*/

  /*void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }*/

  /*void showKeyboard() => focusNode.requestFocus();

  void hideKeyboard() => focusNode.unfocus();*/

  /*void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }*/

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;

    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Row(
          children: [
            IconButton(
                color: Colors.grey,
                onPressed: () {
                  /*if (isShowEmojiContainer) {
                    setState(() {
                      isShowEmojiContainer = !isShowEmojiContainer;
                    });
                  }*/
                  showAnimatedDialog(
                    barrierDismissible: true,
                    animationType: DialogTransitionType.slideFromLeftFade,
                    context: context,
                    builder: (context) {
                      return Dialog(
                        alignment: Alignment.bottomLeft,
                        insetPadding: const EdgeInsets.only(
                            left: 20, right: 60, bottom: 70),
                        backgroundColor: const Color(0xff4481eb),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: GridView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          children: [
                            InkWell(
                              onTap: () {
                                selectImageCamera();
                                Navigator.pop(context);
                              },
                              child: const DialogItem(
                                  icon: Icons.camera_alt_rounded,
                                  name: 'Camera',
                                  color: Color(0xff4facfe)),
                            ),
                            InkWell(
                              focusColor: Colors.red,
                              onTap: () {
                                selectImage();
                                Navigator.pop(context);
                              },
                              child: const DialogItem(
                                  icon: Icons.photo_rounded,
                                  name: 'Gallery',
                                  color: Color(0xff6a11cb)),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                _toast(
                                    'For sending Files, you need to subscribe premium plane');
                              },
                              child: const DialogItem(
                                  icon: Icons.file_present_rounded,
                                  name: 'File',
                                  color: Color(0xff006fde)),
                            ),
                            InkWell(
                              onTap: () {
                                /*selectVideoGallery();
                                Navigator.pop(context);*/
                                _toast(
                                    'For sending videos, you need to subscribe premium plane');
                              },
                              child: const DialogItem(
                                  icon: Icons.video_collection_rounded,
                                  name: 'Video',
                                  color: Color(0xff0536f9)),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add_circle)),
            Expanded(
              child: TextFormField(
                maxLines: 10,
                minLines: 1,
                //focusNode: focusNode,
                controller: _messageController,
                /*onTap: () {
                  if (isShowEmojiContainer) {
                    setState(() {
                      isShowEmojiContainer = !isShowEmojiContainer;
                    });
                  }
                },*/
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorsCustom.secondaryDark,
                  /*prefixIcon: IconButton(
                    onPressed: toggleEmojiKeyboardContainer,
                    icon: Icon(
                      isShowEmojiContainer
                          ? Icons.keyboard
                          : Icons.emoji_emotions_rounded,
                      color: Colors.grey,
                    ),
                  ),*/
                  /*suffixIcon: _messageController.text == '' ? IconButton(
                    onPressed: toggleEmojiKeyboardContainer,
                    icon: const Icon(
                      Icons.gif_rounded,
                      color: Colors.grey,
                    ),
                  ): null,*/
                  hintText: 'Type a message!',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 5, right: 2, left: 7, top: 5),
              child: CircleAvatar(
                backgroundColor: ColorsCustom.primary,
                radius: 25,
                child: GestureDetector(
                  onTap: sendTextMessage,
                  child: Icon(
                    isShowSendButton
                        ? Icons.send_rounded
                        : isRecording
                            ? Icons.close_rounded
                            : Icons.mic_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        /*isShowEmojiContainer
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.36,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });
                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  },
                ),
              )
            : const SizedBox()*/
      ],
    );
  }

  _toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.black54,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }
}
