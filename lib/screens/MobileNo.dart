import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hi/utils/utils.dart';
import 'package:lottie/lottie.dart';

class MobileNo extends StatefulWidget {
  const MobileNo({Key? key}) : super(key: key);

  @override
  State<MobileNo> createState() => _MobileNoState();
}

class _MobileNoState extends State<MobileNo> {
  var moNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter Mobile No.',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w700,
                    fontSize: 25)),
            Lottie.asset('assets/security.json', height: 300),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: moNoController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: (value) {
                  if (value!.isEmpty) {
                    const Text('enter data');
                  } else if (value.length < 10) {
                    const Text('phone no must be 10 degites');
                  }
                },
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.only(left: 10, top: 0, bottom: 0),
                  label: const Text('Enter Number'),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.blueAccent)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.grey)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: Size.fromHeight(
                        MediaQuery.of(context).size.width * 0.1)),
                onPressed: () async {
                  if (moNoController.text == '') {
                    showSnackBar(
                        context: context, content: 'Enter Mobile Number');
                  } else if (moNoController.text.length < 10) {
                    showSnackBar(
                        context: context, content: 'invalid mobile number');
                  } else {
                    dialogProgress(context);
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: '+91${moNoController.text}',
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      timeout: const Duration(seconds: 60),
                      codeSent: (String verificationId, int? resendToken) {
                        ///code for that one which you want to do after send otp to user
                        Navigator.pop(context);
                        _toast('otp sent successfully');
                        Navigator.pushNamed(context, '/OtpScreen', arguments: {
                          'verificationId': verificationId.toString()
                        });
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  }
                },
                child: const Text('Send Otp'),
              ),
            )
          ],
        ),
      ),
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
