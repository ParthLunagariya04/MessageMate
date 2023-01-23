import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi/feature/controller/StatusController.dart';
import 'package:hi/utils/ColorsCustom.dart';

class ConfirmStatuesScreen extends ConsumerWidget {
  const ConfirmStatuesScreen({Key? key}) : super(key: key);

  void addStatus(WidgetRef ref, BuildContext context, File image) {
    ref.read(statusControllerProvider).addStatus(image, context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      backgroundColor: ColorsCustom.secondaryDark2,
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Padding(
            padding: const EdgeInsets.only(right: 5, left: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                data['imageFile'],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addStatus(ref, context, data['imageFile']);
        },
        child: const Icon(
          Icons.send_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
