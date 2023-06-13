import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/products_model.dart';

class ProductsProvider with ChangeNotifier {
  static List<ProductModel> _productsList = [];
  List<ProductModel> get getProducts {
    return _productsList;
  }

  List<ProductModel> get getOnSaleProducts {
    return _productsList.where((element) => element.isOnSale).toList();
  }

  Future<void> fetchProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot) {
      _productsList = [];
      _productsList.clear();
      for (var element in productSnapshot.docs) {
        _productsList.insert(
            0,
            ProductModel(
              id: element.get('id'),
              title: element.get('title'),
              imageUrl: element.get('imageUrl'),
              productCategoryName: element.get('productCategoryName'),
              price: double.parse(element.get('price')),
              salePrice: double.parse(element.get('salePrice')),
              isOnSale: element.get('isOnSale'),
              isPiece: element.get('isPiece'),
            ));
      }
    });
    notifyListeners();
  }

  ProductModel findProdById(String productId) {
    return _productsList.firstWhere((element) => element.id == productId);
  }

  List<ProductModel> findByCategory(String categoryName) {
    List<ProductModel> _categoryList = _productsList
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return _categoryList;
  }

  List<ProductModel> searchQuery(String searchText) {
    List<ProductModel> _searchList = _productsList
        .where(
          (element) => element.title.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();
    return _searchList;
  }

  // static final List<ProductModel> _productsList = [
  //   ProductModel(
  //     id: 'Quả mơ',
  //     title: "Quả mơ",
  //     imageUrl: 'https://i.ibb.co/F0s3FHQ/Apricots.png',
  //     productCategoryName: "Trái cây",
  //     price: 15000,
  //     salePrice: 10000,
  //     isOnSale: true,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: '1',
  //     title: "Củ sắn",
  //     imageUrl: 'https://i.ibb.co/F0s3FHQ/Apricots.png',
  //     productCategoryName: "Trái cây",
  //     price: 15000,
  //     salePrice: 10000,
  //     isOnSale: true,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: '123',
  //     title: "Củ dền",
  //     imageUrl: 'https://i.ibb.co/F0s3FHQ/Apricots.png',
  //     productCategoryName: "Trái cây",
  //     price: 15000,
  //     salePrice: 10000,
  //     isOnSale: false,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Rau chân vịt',
  //     title: "Rau chân vịt",
  //     imageUrl: 'https://i.ibb.co/bbjvgcD/Spinach.png',
  //     productCategoryName: "Trái cây",
  //     price: 15000,
  //     salePrice: 10000,
  //     isOnSale: true,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Hạnh nhân',
  //     title: "Hạnh nhân",
  //     imageUrl: 'https://i.ibb.co/c8QtSr2/almand.png',
  //     productCategoryName: "Các loại hạt",
  //     price: 15000,
  //     salePrice: 10000,
  //     isOnSale: true,
  //     isPiece: true,
  //   ),
  // ];
}
