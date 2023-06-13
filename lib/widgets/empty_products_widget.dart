import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../services/utils.dart';

class EmptyProdWidget extends StatelessWidget {
  const EmptyProdWidget({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(58.0),
                      child: Image.asset("assets/images/box.png"),
                    ),
                    Text(text,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: color,fontSize: 25, fontWeight: FontWeight.w700),),
                  ],
                ),
              ),
            );
  }
}