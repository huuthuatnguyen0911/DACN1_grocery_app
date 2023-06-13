import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/screens/categories.dart';
import 'package:grocery_app/screens/home.screen.dart';
import 'package:grocery_app/screens/user.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
// import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/dart_theme_provider.dart';
import 'cart/cart_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0; //Khi bắt đầu sẽ là màn hình user
  final List<Map<String, dynamic>> _pages = [
    {'page': const HomeScreen(), 'title': 'Home Screen'},
    {'page': CategoriesScreen(), 'title': 'Categories Screen'},
    {'page': const CartScreen(), 'title': 'Cart Screen'},
    {'page': const UserScreen(), 'title': 'User Screen'},
  ];
  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDart = themeState.getDarkTheme;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_pages[_selectedIndex]['title']),
      // ),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: _isDart ? Theme.of(context).cardColor : Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          unselectedItemColor: _isDart ? Colors.white10 : Colors.black12,
          selectedItemColor:
              _isDart ? Colors.lightBlue.shade200 : Colors.black87,
          onTap: _selectedPage,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                    _selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(_selectedIndex == 1
                    ? IconlyBold.category
                    : IconlyLight.category),
                label: "Categories"),
            BottomNavigationBarItem(
                icon: Consumer<CartProvider>(
                  builder: (_, myCart, ch) {
                    return badges.Badge(
                      toAnimate: true,
                      shape: BadgeShape.circle,
                      animationType: BadgeAnimationType.slide,
                      badgeColor: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                      badgeContent:
                          Text(myCart.getCartItems.length.toString(), style: TextStyle(color: Colors.white)),
                      child: Icon(
                          _selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy),
                    );
                  }
                ),
                label: "Cart"),
            BottomNavigationBarItem(
                icon: Icon(
                    _selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2),
                label: "User"),
          ]),
    );
  }
}
