import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi/Models/StatusModel.dart';
import 'package:hi/Models/UserModel.dart';
import 'package:hi/common/CommonFirebaseStorageRepository.dart';
import 'package:hi/utils/utils.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatues({
    required String userName,
    required String profilePic,
    required String phoneNum,
    required File statuesImage,
    required BuildContext context,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storageFileToFirebase(
            '/status/$statusId$uid',
            statuesImage,
          );
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      List<String> uidWhoCanSee = [];
      for (int i = 0; i < contacts.length; i++) {
        if(contacts[i].phones.isNotEmpty){
          debugPrint('MyLogData upload statues');
          var userDataFirebase = await firestore
              .collection('users')
              .where(
            'phoneNumber',
            isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''),
          )
              .get();
          if (userDataFirebase.docs.isNotEmpty) {
            var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
            uidWhoCanSee.add(userData.uid);
          }
        }else{
          debugPrint('MyLogData getStatus number empty}');
        }

      }

      List<String> statusImageUrl = [];
      var statusSnapshot = await firestore
          .collection('status')
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          .get();
      /*.where('createdAt',
              isLessThan: DateTime.now().subtract(const Duration(hours: 24)))*/

      if (statusSnapshot.docs.isNotEmpty) {
        StatusModel status = StatusModel.fromMap(statusSnapshot.docs[0].data());
        statusImageUrl = status.photoUrl;
        statusImageUrl.add(imageUrl);
        await firestore
            .collection('status')
            .doc(statusSnapshot.docs[0].id)
            .update({'photoUrl': statusImageUrl});
        return;
      } else {
        statusImageUrl = [imageUrl];
      }

      StatusModel statusModel = StatusModel(
        uid: uid,
        userName: userName,
        phoneNumber: phoneNum,
        photoUrl: statusImageUrl,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      await firestore
          .collection('status')
          .doc(statusId)
          .set(statusModel.toMap());
    } catch (e) {
      //showSnackBar(context: context, content: e.toString());
      debugPrint('MyLogData upload statues error -- $e');
    }
  }

  Future<List<StatusModel>> getStatues(BuildContext context) async {
    List<StatusModel> statusData = [];
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (int i = 0; i < contacts.length; i++) {
        if (contacts[i].phones.isNotEmpty) {
          var statusSnapshot = await firestore
              .collection('status')
              .where(
                'phoneNumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''),
              )
              .where(
                'createdAt',
                isGreaterThan: DateTime.now()
                    .subtract(const Duration(hours: 24))
                    .millisecondsSinceEpoch,
              )
              .get();
          //print('MyLogData statusSnapshot isEmpty -- ${statusSnapshot.docs.isEmpty}');

          for (var tempData in statusSnapshot.docs) {
            StatusModel tempStatus = StatusModel.fromMap(tempData.data());
            if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
              statusData.add(tempStatus);
              //print('MyLogData tempStatus -- $tempStatus');
            }
          }
        } else {
          if (kDebugMode) print('MyLogData getStatus empty num');
        }
      }
    } catch (e) {
      if (kDebugMode) print('MyLogData getStatus error -- $e');
      //showSnackBar(context: context, content: e.toString());
    }
    return statusData;
  }
}
