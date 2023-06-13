import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:grocery_app/models/products_model.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/widgets/price_widget.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../inner_screens/product_details.dart';
import '../models/cart_model.dart';
import '../providers/viewed_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/utils.dart';
import 'heart_btn.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({
    super.key,
  });
  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = "1";
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);
    final viewedProdProvider = Provider.of<ViewedProductProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            viewedProdProvider.addProductsToHistory(productId: productModel.id);
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
            // GlobalMethods.navigateTo(
            //     ctx: context, routeName: ProductDetails.routeName);
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              FancyShimmerImage(
                imageUrl: productModel.imageUrl,
                height: size.width * 0.21,
                width: size.width * 0.2,
                boxFit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextWidget(
                        text: productModel.title,
                        color: color,
                        maxLines: 1,
                        textSize: 18,
                        isTitle: true,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: HeartBtn(
                        productId: productModel.id,
                        isInWishlist: _isInWishlist,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      child: PriceWidget(
                        salePrice: productModel.salePrice,
                        price: productModel.price,
                        textPrice: _quantityTextController.text,
                        isOnSale: productModel.isOnSale ? true : false,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: FittedBox(
                              child: TextWidget(
                                text: productModel.isPiece ? "cái" : "kg",
                                color: color,
                                textSize: 18,
                                isTitle: true,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                              flex: 2,
                              child: TextFormField(
                                controller: _quantityTextController,
                                key: const ValueKey("10"),
                                style: TextStyle(color: color, fontSize: 17),
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                enabled: true,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[0-9.]'),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _isInCart
                      ? null
                      : () async {
                          final User? user = authInstance.currentUser;
                          if (user == null) {
                            GlobalMethods.errorDialog(
                                subtitle: "Vui lòng đăng nhập để sử dụng",
                                context: context);
                            return;
                          }
                          await GlobalMethods.addToCart(
                              productId: productModel.id,
                              quantity: int.parse(_quantityTextController.text),
                              context: context);
                          await cartProvider.fetchCart();

                          // cartProvider.addProductsToCart(
                          //     productId: productModel.id,
                          //     quantity:
                          //         int.parse(_quantityTextController.text));
                        },
                  child: TextWidget(
                    text: _isInCart ? "Đã thêm vào giỏ" : "Thêm giỏ hàng",
                    color: color,
                    textSize: 15,
                    maxLines: 1,
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        // Theme.of(context).cardColor,
                        Color.fromARGB(255, 48, 255, 7).withOpacity(0.6),
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
