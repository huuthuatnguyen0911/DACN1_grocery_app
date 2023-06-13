import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:grocery_app/fetch_screen.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/widgets/text_widget.dart';

import '../screens/btm_bar.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  Future<void> _googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await authInstance.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken),
          );
          if (authResult.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(authResult.user!.uid)
                .set({
              'id': authResult.user!.uid,
              'name': authResult.user!.displayName,
              'email': authResult.user!.email,
              'shipping-address': '',
              'userWish': [],
              'userCart': [],
              'createdAt': Timestamp.now(),
            });
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const FetchScreen(),
            ),
          );
        } on FirebaseException catch (error) {
          GlobalMethods.errorDialog(
              subtitle: "${error.message}", context: context);
        } catch (error) {
          GlobalMethods.errorDialog(subtitle: "$error", context: context);
        } finally {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // color: Colors.blue,
      child: InkWell(
        onTap: () {
          _googleSignIn(context);
        },
        child: Container(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,

          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
            color: Colors.grey[200],
          ),
          child: Image.asset(
            'assets/images/google1.png',
            height: 40,
          ),

          // const SizedBox(
          //   width: 8,
          // ),
          // TextWidget(
          //   text: 'Đăng nhập bằng google',
          //   color: Colors.white,
          //   textSize: 18,
          // ),
        ),
      ),
    );
  }
}
