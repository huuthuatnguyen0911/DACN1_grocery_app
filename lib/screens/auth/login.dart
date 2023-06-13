import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/fetch_screen.dart';
import 'package:grocery_app/screens/auth/forget_pass.dart';
import 'package:grocery_app/screens/auth/register.dart';
import 'package:grocery_app/screens/auth/register1.dart';
import 'package:grocery_app/screens/btm_bar.dart';
import 'package:grocery_app/screens/loading_manager.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:email_validator/email_validator.dart';
import '../../consts/contss.dart';
import '../../consts/firebase_consts.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/google_button.dart';
import '../../widgets/text_widget.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(children: [
          Swiper(
            duration: 800,
            autoplayDelay: 8000,
            itemBuilder: (BuildContext context, int index) {
              return Image.asset(
                Constss.authImagesPaths[index],
                fit: BoxFit.cover,
              );
            },
            autoplay: true,
            itemCount: Constss.authImagesPaths.length,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 120.0,
                  ),
                  TextWidget(
                    text: 'Chào mừng quay trở lại',
                    color: Colors.white,
                    textSize: 30,
                    isTitle: true,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextWidget(
                    text: "Vui lòng đăng nhập để tiếp tục",
                    color: Colors.white,
                    textSize: 18,
                    isTitle: false,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Form(
                      key: _formKey,
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
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
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
                            style: const TextStyle(color: Colors.white),
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
                                    color: Colors.white,
                                  )),
                              hintText: 'Mật khẩu',
                              hintStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context,
                            routeName: ForgetPasswordScreen.routeName);
                      },
                      child: const Text(
                        'Quên mật khẩu?',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AuthButton(
                    fct: _submitFormOnLogin,
                    buttonText: 'Đăng nhập',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //  const GoogleButton(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(            
                          color: Colors.white,
                          thickness: 2,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextWidget(
                        text: 'HOẶC',
                        color: Colors.white,
                        textSize: 18,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Expanded(
                        child: Divider(
                          color: Colors.white,
                          thickness: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AuthButton(
                    fct: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FetchScreen(),
                        ),
                      );
                    },
                    buttonText: 'Tiếp tục với vai trò khách',
                    primary: Colors.black,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                        text: TextSpan(
                            text: 'Bạn chưa có tài khoản?',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                            children: [
                          TextSpan(
                              text: '  Đăng kí',
                              style: const TextStyle(
                                  color: Colors.lightBlue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  GlobalMethods.navigateTo(
                                      ctx: context,
                                      routeName: RegisterScreen1.routeName);
                                }),
                        ])),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
