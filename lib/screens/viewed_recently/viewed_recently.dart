import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/providers/viewed_provider.dart';
import 'package:grocery_app/screens/viewed_recently/viewed_widget.dart';
import 'package:grocery_app/widgets/back_widget.dart';
import 'package:provider/provider.dart';

import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
// import 'viewed_full.dart';

class ViewedRecentlyScreen extends StatefulWidget {
  static const routeName = '/ViewedRecentlyScreen';

  const ViewedRecentlyScreen({Key? key}) : super(key: key);

  @override
  _ViewedRecentlyScreenState createState() => _ViewedRecentlyScreenState();
}

class _ViewedRecentlyScreenState extends State<ViewedRecentlyScreen> {
  bool check = true;
  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    final viewedProdProvider = Provider.of<ViewedProductProvider>(context);
    final viewedProdItemsList =
        viewedProdProvider.getViewedProdlistItems.values.toList().reversed.toList();
    // Size size = Utils(context).getScreenSize;
    if (viewedProdItemsList.isEmpty) {
      return const EmptyScreen(
        title: 'Lịch sử đã xem trống 👀',
        subtitle: 'Không có sản phẩm đã xem',
        buttonText: '👉 Thêm sản phẩm 👈',
        imagePath: 'assets/images/history.png',
      );
    } else {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              GlobalMethods.warningDialog(
                  title: 'Xoá lịch sử xem?',
                  subtitle: 'Xác nhận xoá lịch sử xem sản phẩm?',
                  fct: () {},
                  context: context);
            },
            icon: Icon(
              IconlyBroken.delete,
              color: color,
            ),
          )
        ],
        leading: const BackWidget(),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: TextWidget(
          text: 'Sản phẩm đã xem',
          color: color,
          textSize: 20.0,
          isTitle: true,
        ),
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
      ),
      body: ListView.builder(
          itemCount: viewedProdItemsList.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              child: ChangeNotifierProvider.value(
                value: viewedProdItemsList[index],
                child: ViewedRecentlyWidget()),
            );
          }),
    );
  }
  }
}
