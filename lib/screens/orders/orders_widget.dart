import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/inner_screens/product_details.dart';
import 'package:grocery_app/models/orders_model.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String orderDateToShow;
  late String orderHourToShow;

  @override
  void didChangeDependencies() {
    final ordersModel = Provider.of<OrderModel>(context);
    var orderDate = ordersModel.orderDate.toDate();
    var vietnamTime = orderDate.toUtc().add(const Duration(hours: 7));
    orderDateToShow = DateFormat('dd/MM/yyyy').format(vietnamTime);
    orderHourToShow = DateFormat('HH:mm').format(vietnamTime);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<OrderModel>(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productProvider.findProdById(ordersModel.productId);
    return ListTile(
      subtitle: Text(
          'Thanh toán: ${double.parse(ordersModel.price).toStringAsFixed(0)}đ'),
      onTap: () {
        GlobalMethods.navigateTo(
            ctx: context, routeName: ProductDetails.routeName);
      },
      leading: FancyShimmerImage(
        width: size.width * 0.2,
        imageUrl: getCurrProduct.imageUrl,
        boxFit: BoxFit.fill,
      ),
      trailing: TextWidget(
          text: '${getCurrProduct.title}  x${ordersModel.quantity}',
          color: color,
          textSize: 15),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              TextWidget(text: orderDateToShow, color: color, textSize: 15),
              const SizedBox(width: 5),
              TextWidget(
                text: orderHourToShow,
                color: color,
                textSize: 15,
              ),
            ],
          )
        ],
      ),
      // trailing:
    );
  }
}
