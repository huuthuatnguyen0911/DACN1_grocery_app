import 'package:flutter/material.dart';
import 'package:grocery_app/inner_screens/feeds_screen.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/widgets/text_widget.dart';

import '../services/utils.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.buttonText})
      : super(key: key);
  final String imagePath, title, subtitle, buttonText;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final themeState = Utils(context).getTheme;
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                imagePath,
                width: double.infinity,
                height: size.height * 0.4,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Whoops!',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 40,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(text: title, color: Colors.cyan, textSize: 20),
              const SizedBox(
                height: 20,
              ),
              TextWidget(text: subtitle, color: Colors.cyan, textSize: 20),
              SizedBox(
                height: size.height * 0.1,
              ),
              Container(
                width: 250,
                height: 80,
                decoration: const ShapeDecoration(
                  shape: StadiumBorder(),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue, Colors.orange, Colors.green],
                  ),
                ),
                child: MaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: const StadiumBorder(),
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    GlobalMethods.navigateTo(
                        ctx: context, routeName: FeedsScreen.routeName);
                  },
                ),
              )
            ]),
      )),
    );
  }
}
