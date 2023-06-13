import 'package:card_swiper/card_swiper.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:grocery_app/screens/loading_manager.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/back_widget.dart';

import '../../consts/contss.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/text_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgetPasswordScreen';
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailTextController = TextEditingController();
  // bool _isLoading = false;
  @override
  void dispose() {
    _emailTextController.dispose();

    super.dispose();
  }

  bool _isLoading = false;
  void _forgetPassFCT() async {
    if (_emailTextController.text.isEmpty ||
        !EmailValidator.validate(_emailTextController.text)) {
      GlobalMethods.errorDialog(
          subtitle: 'Vui lòng nhập đúng email', context: context);
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.sendPasswordResetEmail(
            email: _emailTextController.text.toLowerCase());
        Fluttertoast.showToast(
            msg: "Vui lòng kiểm tra Email để lấy lại mật khẩu",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: "${error.message}", context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: "$error", context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   Size size = Utils(context).getScreenSize;
  //   return Scaffold(
  //     // backgroundColor: Colors.blue,
  //     body: LoadingManager(
  //       isLoading: _isLoading,
  //       child: Stack(
  //         children: [
  //           Swiper(
  //             itemBuilder: (BuildContext context, int index) {
  //               return Image.asset(
  //                 Constss.authImagesPaths[index],
  //                 fit: BoxFit.cover,
  //               );
  //             },
  //             autoplay: true,
  //             itemCount: Constss.authImagesPaths.length,

  //             // control: const SwiperControl(),
  //           ),
  //           Container(
  //             color: Colors.black.withOpacity(0.7),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 16,
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 SizedBox(
  //                   height: size.height * 0.1,
  //                 ),
  //                 Row(
  //                   children: [
  //                     const BackWidget(),
  //                     const SizedBox(
  //                       width: 35,
  //                       height: 20,
  //                     ),
  //                     TextWidget(
  //                       text: 'Quên mật khẩu',
  //                       color: Colors.white,
  //                       textSize: 30,
  //                     ),
  //                     const SizedBox(
  //                       height: 30,
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 50,),
  //                 TextField(
  //                   controller: _emailTextController,
  //                   style: const TextStyle(color: Colors.white),
  //                   decoration: const InputDecoration(
  //                     hintText: 'Địa chỉ email',
  //                     hintStyle: TextStyle(color: Colors.white),
  //                     enabledBorder: UnderlineInputBorder(
  //                       borderSide: BorderSide(color: Colors.white),
  //                     ),
  //                     focusedBorder: UnderlineInputBorder(
  //                       borderSide: BorderSide(color: Colors.white),
  //                     ),
  //                     errorBorder: UnderlineInputBorder(
  //                       borderSide: BorderSide(color: Colors.red),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 15,
  //                 ),
  //                 AuthButton(
  //                   buttonText: 'Lấy lại mật khẩu',
  //                   fct: () {
  //                     _forgetPassFCT();
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: LoadingManager(
        isLoading: _isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  // logo
                  const Icon(
                    Icons.private_connectivity,
                    size: 100,
                  ),
                  const SizedBox(height: 10),

                  Text(
                    'Quên mật khẩu grocery !',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 50),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Không được để trống trường này!';
                            }
                            if (!EmailValidator.validate(value)) {
                              return 'Vui lòng nhập đúng định dạng email';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintText: "Địa chỉ email",
                              hintStyle: TextStyle(color: Colors.grey[500])),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  AuthButton(
                    buttonText: 'Lấy lại mật khẩu',
                    fct: () {
                      _forgetPassFCT();
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
