import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi/Models/UserModel.dart';
import 'package:hi/common/CommonFirebaseStorageRepository.dart';
import 'package:hi/utils/utils.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void saveDataToFirebase(
      {required String name,
      required File? profilePic,
      required ProviderRef providerRef,
      required BuildContext context,
      required String fcmToken}) async {
    try {
      dialogProgress(context);
      String uid = auth.currentUser!.uid;
      var image =
          'https://firebasestorage.googleapis.com/v0/b/my-chat-68cad.appspot.com/o/profilePic%2Fcool%20boy%20avatar.jpg?alt=media&token=2fa28b5f-6053-4fae-af0e-503492446d28';
      if (profilePic != null) {
        image = await providerRef
            .read(commonFirebaseStorageRepositoryProvider)
            .storageFileToFirebase('profilePic/$uid', profilePic);
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: image,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId: [],
          fcmToken: fcmToken);
      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pop(context);
      Navigator.pushNamed(context, '/Home');
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    //converting firebase user collections to user model
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(event.data()!),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'isOnline': isOnline});
  }
}
