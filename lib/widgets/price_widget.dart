import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:grocery_app/widgets/text_widget.dart';

import '../services/utils.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget(
      {super.key,
      required this.salePrice,
      required this.price,
      required this.textPrice,
      required this.isOnSale});
  final double salePrice, price;
  final String textPrice;
  final bool isOnSale;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    double userPrice = isOnSale? salePrice : price;
    return FittedBox(
      child: Flexible(
        flex: 2,
        child: Row(
          children: [
            TextWidget(
              text: '${(userPrice * int.parse(textPrice)).toStringAsFixed(0)}đ',
              color: Colors.green,
              textSize: 18,
            ),
            const SizedBox(
              width: 5,
            ),
            Visibility(
              visible: isOnSale? true : false,
              child: Text(
                '${(price * int.parse(textPrice)).toStringAsFixed(0)}đ',
                style: TextStyle(
                    fontSize: 15,
                    color: color,
                    decoration: TextDecoration.lineThrough),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
