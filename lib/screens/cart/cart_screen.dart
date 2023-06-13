import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grocery_app/providers/product_provider.dart';
import 'package:grocery_app/widgets/empty_screen.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

import '../../consts/firebase_consts.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/payment_controller.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import 'cart_widget.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();

    return cartItemsList.isEmpty
        ? const EmptyScreen(
            title: 'Giỏ hàng trống 🛒',
            subtitle: 'Vui lòng thêm sản phẩm vào giỏ',
            buttonText: 'Thêm sản phẩm',
            imagePath: 'assets/images/cart.png',
          )
        : Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: TextWidget(
                  text: "Giỏ hàng (${cartItemsList.length})",
                  color: color,
                  textSize: 20,
                  isTitle: true,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                        title: 'Xoá giỏ hàng !!!',
                        subtitle: 'Bạn có muốn xoá giỏ hàng?',
                        fct: () async {
                          await cartProvider.clearOnlineCart();
                          cartProvider.clearLocalCart();
                        },
                        context: context,
                      );
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ),
                  ),
                ]),
            body: Column(
              children: [
                _checkout(ctx: context),
                Expanded(
                  child: ListView.builder(
                      itemCount: cartItemsList.length,
                      itemBuilder: (ctx, index) {
                        return ChangeNotifierProvider.value(
                            value: cartItemsList[index],
                            child: CartWidget(
                              q: cartItemsList[index].quantity,
                            ));
                      }),
                ),
              ],
            ),
          );
  }

  Widget _checkout({required BuildContext ctx}) {
    final PaymentController controller = Get.put(PaymentController());
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvider = Provider.of<ProductsProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);
    double total = 0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurProduct = productProvider.findProdById(value.productId);
      total += (getCurProduct.isOnSale
              ? getCurProduct.salePrice
              : getCurProduct.price) *
          value.quantity;
    });

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  User? user = authInstance.currentUser;
                  final orderId = const Uuid().v4();
                  final productProvider =
                      Provider.of<ProductsProvider>(ctx, listen: false);
                     try {
                      //  await initPayment(amount: total, context: ctx, email: user!.email ?? '');
                       await controller.makePayment(amount: "5", currency: 'USD');
                     } catch (e) {
                       print('Đã xảy ra lỗi $e');
                       return;
                     }
                  cartProvider.getCartItems.forEach((key, value) async {
                    final getCurrProduct = productProvider.findProdById(
                      value.productId,
                    );
                    try {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .set({
                        'orderId': orderId,
                        'userId': user!.uid,
                        'productId': value.productId,
                        'price': (getCurrProduct.isOnSale
                                ? getCurrProduct.salePrice
                                : getCurrProduct.price) *
                            value.quantity,
                        'totalPrice': total,
                        'quantity': value.quantity,
                        'imageUrl': getCurrProduct.imageUrl,
                        'userName': user.displayName,
                        'orderDate': Timestamp.now(),
                      });
                      await cartProvider.clearOnlineCart();
                      cartProvider.clearLocalCart();
                      ordersProvider.fetchOrders();
                      await Fluttertoast.showToast(
                        msg: "Đơn hàng của bạn đã được đặt",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );
                    } catch (error) {
                      GlobalMethods.errorDialog(
                          subtitle: error.toString(), context: ctx);
                    } finally {}
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextWidget(
                      text: "Đặt hàng", color: Colors.white, textSize: 18),
                ),
              ),
            ),
            const Spacer(),
            FittedBox(
                child: TextWidget(
              text: 'Tổng: ${total.toStringAsFixed(0)}đ',
              color: color,
              textSize: 18,
              isTitle: true,
            ))
          ],
        ),
      ),
    );
  }
  
  // Future<void> initPayment(
  //     {required String email,
  //     required double amount,
  //     required BuildContext context}) async {
  //   try {
  //     // 1. Create a payment intent on the server
  //     final response = await http.post(
  //         Uri.parse(
  //             'https://api.stripe.com/v1/payment_intents'),
  //             headers: {
  //           // 'Authorization': 'Bearer $SECRET_KEY',
  //           'Content-Type': 'application/x-www-form-urlencoded'
  //         },
  //         body: {
  //           'email': email,
  //           'amount': amount.toString(),
  //         });

  //     final jsonResponse = jsonDecode(response.body);
  //     if(jsonResponse['success'] == false){
  //       GlobalMethods.errorDialog(subtitle: jsonResponse['error'], context: context,);
  //       throw jsonResponse['error'];
  //     }
  //     log(jsonResponse.toString());
  //      var gpay = const PaymentSheetGooglePay(merchantCountryCode: "US",
  //         currencyCode: "VND",
  //         testEnv: true);
  //       //   var exchangeRate = await CurrencyConverter.convertCurrency("GBP", "VND");
  //       // var paymentIntentClientSecretInVND = exchangeRate * jsonResponse['paymentIntent'];
  //     // 2. Initialize the payment sheet
  //     await Stripe.instance.initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //       paymentIntentClientSecret: jsonResponse['paymentIntent'],
  //       merchantDisplayName: 'Đơn hàng Grocery',
  //       customerId: jsonResponse['customer'],
  //       customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
  //        googlePay: gpay
  //     ));
  //     await Stripe.instance.presentPaymentSheet();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Thanh toán thành công'),
  //       ),
  //     );
  //   } catch (errorr) {
  //     if (errorr is StripeException) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Đã xảy ra lỗi ${errorr.error.localizedMessage}'),
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Đã xảy ra lỗi $errorr'),
  //         ),
  //       );
  //     }
  //       throw '$errorr';
  //   }
  // }

}