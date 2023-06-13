import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/inner_screens/product_details.dart';
import 'package:grocery_app/models/wishlist_model.dart';
import 'package:grocery_app/providers/product_provider.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/widgets/heart_btn.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/wishlist_provider.dart';
import '../../services/utils.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final wishlistModel = Provider.of<WishlistModel>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final getCurrProduct =
        productProvider.findProdById(wishlistModel.productId);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;

    NumberFormat formatCurrency =
        NumberFormat.currency(locale: "vi_VN", symbol: "đ");
    String formattedusedPrice = formatCurrency.format(usedPrice);
    formattedusedPrice = formattedusedPrice.replaceAll(RegExp(r'\s+'), '');

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: wishlistModel.productId);
        },
        child: Container(
          height: size.height * 0.20,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: color, width: 1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 8),
                width: size.width * 0.2,
                height: size.width * 0.25,
                child: FancyShimmerImage(
                  imageUrl: getCurrProduct.imageUrl,
                  boxFit: BoxFit.fill,
                ),
              ),
              Column(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            IconlyLight.bag2,
                            color: color,
                          ),
                        ),
                        HeartBtn(
                          productId: getCurrProduct.id,
                          isInWishlist: _isInWishlist,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: TextWidget(
                      text: getCurrProduct.title,
                      color: color,
                      textSize: 15,
                      maxLines: 2,
                      isTitle: true,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                    text: formattedusedPrice,
                    color: color,
                    textSize: 18,
                    maxLines: 1,
                    isTitle: true,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
