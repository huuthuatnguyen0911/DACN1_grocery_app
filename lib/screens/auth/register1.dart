import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:grocery_app/fetch_screen.dart';
import 'package:grocery_app/screens/auth/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:grocery_app/screens/btm_bar.dart';
import '../../consts/contss.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/text_widget.dart';
import '../loading_manager.dart';
import 'forget_pass.dart';
import 'login1.dart';

class RegisterScreen1 extends StatefulWidget {
  static const routeName = '/RegisterScreen1';
  const RegisterScreen1({Key? key}) : super(key: key);

  @override
  State<RegisterScreen1> createState() => _RegisterScreen1State();
}

class _RegisterScreen1State extends State<RegisterScreen1> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  bool _obscureText = true;
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _addressTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  void _submitFormOnRegister() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        final User? user = authInstance.currentUser;
        final _uid = user!.uid;
        user.updateDisplayName(_fullNameController.text);
        user.reload();
        await FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': _fullNameController.text,
          'email': _emailTextController.text,
          'shipping-address': _addressTextController.text,
          'userWish': [],
          'userCart': [],
          'createdAt': Timestamp.now(),
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const FetchScreen(),
        ));

        print('Successfully registered');
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

  @override
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
                  const SizedBox(height: 40),
                  // logo
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Đăng ký tài khoản của bạn!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        children: [
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_emailFocusNode),
                            controller: _fullNameController,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Vui lòng không để trống trường này";
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
                                hintText: "Họ và tên",
                                hintStyle: TextStyle(color: Colors.grey[500])),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passFocusNode),
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
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey[500])),
                          ),

                          const SizedBox(
                            height: 12,
                          ),
                          //Password

                          TextFormField(
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_addressFocusNode),
                            controller: _passTextController,
                            focusNode: _passFocusNode,
                            obscureText: _obscureText,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Không được để trống mật khẩu!';
                              }
                              if (value.isEmpty || value.length < 7) {
                                return 'Mật khẩu phải bao gồm 8 kí tự';
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child: Icon(
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.black,
                                    )),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                fillColor: Colors.grey.shade200,
                                filled: true,
                                hintText: 'Mật khẩu',
                                hintStyle: TextStyle(color: Colors.grey[500])),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            focusNode: _addressFocusNode,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: _submitFormOnRegister,
                            controller: _addressTextController,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 10) {
                                return "Không được để trống trường này";
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
                                hintText: "Địa chỉ nhận hàng",
                                hintStyle: TextStyle(color: Colors.grey[500])),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            GlobalMethods.navigateTo(
                                ctx: context,
                                routeName: ForgetPasswordScreen.routeName);
                          },
                          child: Text(
                            'Quên mật khẩu?',
                            maxLines: 1,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  AuthButton(
                    buttonText: 'Đăng kí',
                    fct: () {
                      _submitFormOnRegister();
                    },
                  ),

                  const SizedBox(height: 40),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // TextButton(
                      //   onPressed: () {},
                      //   child: const Text(
                      //     'Bạn đã có tài khoản ?',
                      //     maxLines: 1,
                      //     style: TextStyle(color: Colors.blue),
                      //   ),
                      // ),
                      // const SizedBox(width: 1),
                      TextButton(
                        onPressed: () {
                          GlobalMethods.navigateTo(
                              ctx: context, routeName: LoginScreen1.routeName);
                        },
                        child: const Text(
                          'Bạn đã có tài khoản? Đăng nhập',
                          maxLines: 1,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
