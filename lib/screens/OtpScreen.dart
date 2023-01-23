import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/utils.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var smsCode;
  FirebaseAuth auth = FirebaseAuth.instance;
  static const IS_LOGIN = 'isLogIn';

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Enter OTP.',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w700,
                        fontSize: 25)),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Lottie.asset(
                    'assets/otp.json',
                    height: 300,
                    reverse: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 20, bottom: 20),
                  child: Pinput(
                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsRetrieverApi,
                    keyboardType: TextInputType.number,
                    closeKeyboardWhenCompleted: true,
                    length: 6,
                    onChanged: (value) async {
                      smsCode = value;
                    },
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        dialogProgress(context);
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(
                            verificationId: data['verificationId'], smsCode: smsCode);
                        await auth.signInWithCredential(credential);
                        _toast('Otp verification success');

                        var pref = await SharedPreferences.getInstance();
                        pref.setBool(IS_LOGIN, true);

                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/UserInformation');
                      } catch (e) {
                        Navigator.pop(context);
                        debugPrint('MyOtp error -- $e');
                        _toast(e.toString());
                      }
                    },
                    child: const Text('Verify otp'))
              ],
            ),
          ),
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
