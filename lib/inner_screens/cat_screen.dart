import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/models/products_model.dart';
import 'package:grocery_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../consts/contss.dart';
import '../services/utils.dart';
import '../widgets/back_widget.dart';
import '../widgets/empty_products_widget.dart';
import '../widgets/feed_items.dart';
import '../widgets/text_widget.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = "/CategoryScreenState";
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  List<ProductModel> listProductSearch = [];
  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productsProvider = Provider.of<ProductsProvider>(context);
    final catName = ModalRoute.of(context)!.settings.arguments as String;
    List<ProductModel> productByCate = productsProvider.findByCategory(catName);
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: TextWidget(
          text: catName,
          color: color,
          textSize: 21,
          isTitle: true,
        ),
      ),
      body: productByCate.isEmpty
          ? const EmptyProdWidget(
              text:
                  "Danh sách sản phẩm thuộc danh mục trống! \nVui lòng quay lại sau",
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: kBottomNavigationBarHeight,
                      child: TextField(
                        focusNode: _searchTextFocusNode,
                        controller: _searchTextController,
                        onChanged: (value) {
                          setState(() {
                            listProductSearch =
                                productsProvider.searchQuery(value);
                          });
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.greenAccent,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.greenAccent,
                              width: 1,
                            ),
                          ),
                          hintText: "Tìm kiếm sản phẩm !",
                          prefixIcon: const Icon(Icons.search),
                          suffix: IconButton(
                            onPressed: () {
                              _searchTextController!.clear();
                              _searchTextFocusNode.unfocus();
                            },
                            icon: Icon(
                              Icons.close,
                              color: _searchTextFocusNode.hasFocus
                                  ? Colors.red
                                  : color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _searchTextController!.text.isNotEmpty &&
                          listProductSearch.isEmpty
                      ? const EmptyProdWidget(
                          text:
                              'Không tìm thấy sản phẩm, vui lòng tìm kiếm sản phẩm khác.')
                      : GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          padding: EdgeInsets.zero,
                          // crossAxisSpacing: 10,
                          childAspectRatio: size.width / (size.height * 0.59),
                          children: List.generate(
                              _searchTextController!.text.isNotEmpty
                                  ? listProductSearch.length
                                  : productByCate.length, (index) {
                            return ChangeNotifierProvider.value(
                              value: _searchTextController!.text.isNotEmpty
                                  ? listProductSearch[index]
                                  : productByCate[index],
                              child: const FeedsWidget(),
                            );
                          }),
                        ),
                ],
              ),
            ),
    );
  }
}