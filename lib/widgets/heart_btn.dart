import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:grocery_app/providers/product_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../services/utils.dart';

class HeartBtn extends StatefulWidget {
  const HeartBtn(
      {super.key, required this.productId, this.isInWishlist = false});
  final String productId;
  final bool? isInWishlist;

  @override
  State<HeartBtn> createState() => _HeartBtnState();
}

class _HeartBtnState extends State<HeartBtn> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurProduct = productProvider.findProdById(widget.productId);

    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return GestureDetector(
      onTap: () async {
        setState(() {
          loading = true;
        });
        try {
          final User? user = authInstance.currentUser;
          if (user == null) {
            GlobalMethods.errorDialog(
                subtitle: "Vui lòng đăng nhập để sử dụng", context: context);
            return;
          }
          if (widget.isInWishlist == false && widget.isInWishlist != null) {
            await GlobalMethods.addToWishlist(
                productId: widget.productId, context: context);
          } else {
            await wishlistProvider.removeOneItem(
                wishlistId:
                    wishlistProvider.getWishlistItems[getCurProduct.id]!.id,
                productId: widget.productId);
          }
          await wishlistProvider.fetchWishlist();
          setState(() {
            loading = false;
          });
        } catch (error) {
          GlobalMethods.errorDialog(subtitle: '$error', context: context);
        } finally {
          setState(() {
            loading = false;
          });
        }

        // print('user id is ${user.uid}');
        // wishlistProvider.addRemoveProductsToWishlist(productId: productId);
      },
      child: loading
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 15, width: 15, child: CircularProgressIndicator()),
            )
          : Icon(
              widget.isInWishlist != null && widget.isInWishlist == true
                  ? IconlyBold.heart
                  : IconlyLight.heart,
              size: 22,
              color: widget.isInWishlist != null && widget.isInWishlist == true
                  ? Colors.red
                  : color,
            ),
    );
  }
}
