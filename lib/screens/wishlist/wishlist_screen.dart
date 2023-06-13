import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/screens/wishlist/wishlist_widget.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = "/WishlistScreen";
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemsList =
        wishlistProvider.getWishlistItems.values.toList().reversed.toList();
    return wishlistItemsList.isEmpty
        ? const EmptyScreen(
            title: 'Danh sách trống 🛒',
            subtitle: 'Thêm sản phẩm yêu thích của bạn😀',
            buttonText: '👉 Thêm sản phẩm 👈',
            imagePath: 'assets/images/wishlist.png',
          )
        : Scaffold(
            appBar: AppBar(
                centerTitle: true,
                leading: const BackWidget(),
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: TextWidget(
                  text: "Yêu thích (${wishlistItemsList.length})",
                  color: color,
                  textSize: 20,
                  isTitle: true,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          title: 'Xoá sản phẩm !!!',
                          subtitle: 'Bạn có muốn xoá sản phẩm yêu thích?',
                          fct: () async {
                            await wishlistProvider.clearOnlineWishlist();
                            wishlistProvider.clearLocalWishlist();
                          },
                          context: context);
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ),
                  ),
                ]),
            body: MasonryGridView.count(
              itemCount: wishlistItemsList.length,
              crossAxisCount: 2,
              // mainAxisSpacing: 4,
              // crossAxisSpacing: 4,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                    value: wishlistItemsList[index],
                    child: const WishlistWidget());
              },
            ));
  }
}
