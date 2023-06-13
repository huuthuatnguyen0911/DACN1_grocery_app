import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/screens/auth/forget_pass.dart';
import 'package:grocery_app/screens/auth/login.dart';
import 'package:grocery_app/screens/loading_manager.dart';
import 'package:grocery_app/screens/viewed_recently/viewed_recently.dart';
import 'package:grocery_app/screens/wishlist/wishlist_screen.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../providers/dart_theme_provider.dart';
import '../widgets/text_widget.dart';
import 'auth/login1.dart';
import 'orders/orders_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
      TextEditingController(text: "");
  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  String? _email;
  String? _name;
  String? _address;
  bool _isLoading = false;
  final User? user = authInstance.currentUser;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        _address = userDoc.get('shipping-address');
        _addressTextController.text = userDoc.get('shipping-address');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subtitle: "$error", context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(
                          text: 'Hi, ',
                          style: const TextStyle(
                              color: Colors.cyan,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                        TextSpan(
                            text: _name == null ? 'Khách hàng' : _name,
                            style: TextStyle(
                                color: color,
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print("Tên của bạn đã đc nhấn");
                              })
                      ])),
                  const SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: _email == null ? 'Tạm đóng' : _email!,
                    color: color,
                    textSize: 18,
                    // isTitle: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 3,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _listTiles(
                      title: 'Địa chỉ nhận hàng',
                      subtitle: _address == null ? 'Tạm đóng' : _address,
                      icon: IconlyLight.profile,
                      onPressed: () async {
                        await _showAddressDialog();
                      },
                      color: color),
                  _listTiles(
                      title: 'Đơn hàng đã đặt',
                      icon: IconlyLight.bag,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: OrdersScreen.routeName);
                      },
                      color: color),
                  _listTiles(
                      title: 'Yêu thích',
                      icon: IconlyLight.heart,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: WishlistScreen.routeName);
                      },
                      color: color),
                  _listTiles(
                      title: 'Đã xem',
                      icon: IconlyLight.show,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context,
                            routeName: ViewedRecentlyScreen.routeName);
                      },
                      color: color),
                  _listTiles(
                      title: 'Quên mật khẩu',
                      icon: IconlyLight.unlock,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ForgetPasswordScreen(),
                          ),
                        );
                      },
                      color: color),
                  _listTiles(
                      title: user == null ? "Đăng nhập" : 'Đăng xuất',
                      icon:
                          user == null ? IconlyLight.login : IconlyLight.logout,
                      onPressed: () {
                        if (user == null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen1(),
                            ),
                          );
                          return;
                        }
                        GlobalMethods.warningDialog(
                            title: 'Đăng xuất',
                            subtitle: 'Bạn có muốn đăng xuất?',
                            fct: () async {
                              await authInstance.signOut();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen1(),
                                ),
                              );
                            },
                            context: context);
                      },
                      color: color),
                  SwitchListTile(
                    title: TextWidget(
                      text: themeState.getDarkTheme
                          ? 'Chế độ tối'
                          : 'Chế độ sáng',
                      color: color,
                      textSize: 18,
                    ),
                    secondary: Icon(themeState.getDarkTheme
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined),
                    onChanged: (bool value) {
                      setState(() {
                        themeState.setDarkTheme = value;
                      });
                    },
                    value: themeState.getDarkTheme,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [
              Image.asset(
                'assets/images/warning-sign.png',
                height: 20,
                width: 20,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text('Đăng xuất')
            ]),
            content: const Text('Bạn có muốn đăng xuất?'),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.cyan,
                  text: 'Huỷ',
                  textSize: 18,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: TextWidget(
                  color: Colors.red,
                  text: 'Thoát',
                  textSize: 18,
                ),
              ),
            ],
          );
        });
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              // onChanged: (value) {
              //   print('_addressTextController.text ${_addressTextController.text}');
              // },
              controller: _addressTextController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'Địa chỉ của bạn'),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  String _uid = user!.uid;
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_uid)
                        .update({
                      'shipping-address': _addressTextController.text,
                    });
                    Navigator.pop(context);
                    setState(() {
                      _address = _addressTextController.text;
                    });
                  } catch (e) {
                    GlobalMethods.errorDialog(
                        subtitle: e.toString(), context: context);
                  }
                },
                child: const Text('Cập nhật'),
              )
            ],
          );
        });
  }

  Widget _listTiles(
      {required String title,
      String? subtitle,
      required IconData icon,
      required Function onPressed,
      required Color color}) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 18,
        // isTitle: true,
      ),
      subtitle: TextWidget(
        text: subtitle == null ? "" : subtitle,
        color: color,
        textSize: 17,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }
}
