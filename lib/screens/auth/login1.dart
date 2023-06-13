import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:grocery_app/screens/auth/register.dart';
import 'package:grocery_app/screens/auth/register1.dart';

import '../../consts/firebase_consts.dart';
import '../../fetch_screen.dart';
import '../../services/global_methods.dart';
import '../../widgets/apple_button.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/google_button.dart';
import '../loading_manager.dart';
import 'forget_pass.dart';

class LoginScreen1 extends StatefulWidget {
  static const routeName = '/LoginScreen1';
  const LoginScreen1({super.key});

  @override
  State<LoginScreen1> createState() => _LoginScreen1State();
}

class _LoginScreen1State extends State<LoginScreen1> {
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;
  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.signInWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const FetchScreen(),
        ));

        print('Successfully Logined');
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
                    'Chào mừng bạn quay trở lại!',
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
                            onEditingComplete: () {
                              _submitFormOnLogin();
                            },
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
                                  borderSide: BorderSide(color: Colors.white),
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
                    fct: _submitFormOnLogin,
                    buttonText: 'Đăng nhập',
                  ),

                  const SizedBox(height: 40),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Hoặc tiếp tục với',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // google + apple sign in buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      // google button
                      GoogleButton(),

                      SizedBox(width: 25),

                      // apple button
                      AppleButton(),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const FetchScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Tài khoản khách',
                          maxLines: 1,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(width: 4),
                      TextButton(
                        onPressed: () {
                          GlobalMethods.navigateTo(
                              ctx: context,
                              routeName: RegisterScreen1.routeName);
                        },
                        child: const Text(
                          'Đăng kí tài khoản',
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
