import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi/Models/UserModel.dart';
import 'package:hi/utils/utils.dart';

final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(fireStore: FirebaseFirestore.instance),
);

class SelectContactRepository {
  final FirebaseFirestore fireStore;

  SelectContactRepository({required this.fireStore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
            withProperties: true, withPhoto: true);
      }
    } catch (e) {
      debugPrint('MyLogData contacts error -- ${e.toString()}');
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await fireStore.collection('users').get();
      bool isFound = false;

      for (var doc in userCollection.docs) {
        var userData = UserModel.fromMap(doc.data());
        String selectedPhoneNo =
            selectedContact.phones[0].number.replaceAll(' ', '');
        if (selectedPhoneNo == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(context, '/MobileChatScreen', arguments: {
            'name': userData.name,
            'uid': userData.uid,
          });
        }
      }
      if (!isFound) {
        showSnackBar(
            context: context,
            content: 'This number does not exist in this app.');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
