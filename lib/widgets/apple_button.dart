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

class AppleButton extends StatelessWidget {
  const AppleButton({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // color: Colors.blue,
      child: InkWell(
        onTap: () {
         
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
            'assets/images/apple.png',
            height: 40,
          ),

          
        ),
      ),
    );
  }
}
